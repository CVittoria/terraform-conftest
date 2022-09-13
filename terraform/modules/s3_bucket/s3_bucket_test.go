package test

import (
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/cvittoria/rego-terraform/terraform/terratest/utils"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/tidwall/gjson"
)

func TestTerragruntExample(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:    "./example",
		TerraformBinary: "terragrunt",
	})

	inputs, err := utils.GetInputs(terraformOptions.TerraformDir)
	if err != nil {
		t.Errorf("problem getting terragrunt inputs: %v", err)
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.Apply(t, terraformOptions)

	var assume_role string

	err = utils.Unmarshaller(gjson.GetBytes(inputs, "assume_role"), &assume_role)
	if err != nil {
		t.Errorf("problem running unmarshaller on assume_role: %v", err)
	}

	var aws_region string

	err = utils.Unmarshaller(gjson.GetBytes(inputs, "aws_region"), &aws_region)
	if err != nil {
		t.Errorf("problem running unmarshaller on aws_region: %v", err)
	}

	s3_client, err := initS3Client(aws_region, assume_role)
	if err != nil {
		t.Errorf("problem init'ing S3 Client: %v", err)
	}

	var bucket_name string

	err = utils.Unmarshaller(gjson.GetBytes(inputs, "bucket_name"), &bucket_name)
	if err != nil {
		t.Errorf("problem running unmarshaller on bucket_name: %v", err)
	}

	fetched_tags, err := getS3BucketTags(s3_client, bucket_name)
	if err != nil {
		t.Errorf("problem getting s3 bucket tags: %v", err)
	}

	var tags map[string]string

	err = utils.Unmarshaller(gjson.GetBytes(inputs, "tags"), &tags)
	if err != nil {
		t.Errorf("problem running unmarshaller on tags: %v", err)
	}

	validateS3BucketTags(t, fetched_tags, tags)
}

func initS3Client(region string, role string) (*s3.S3, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region),
	})
	if err != nil {
		return nil, fmt.Errorf("unable to start AWS session: %v", err)
	}

	creds := stscreds.NewCredentials(sess, role)

	svc := s3.New(sess, &aws.Config{Credentials: creds})
	return svc, nil
}

func getS3BucketTags(svc *s3.S3, bucket_name string) ([]*s3.Tag, error) {
	result, err := svc.GetBucketTagging(&s3.GetBucketTaggingInput{
		Bucket: aws.String(bucket_name),
	})
	if err != nil {
		return nil, fmt.Errorf("unable to get bucket tags: %v", err)
	}

	return result.TagSet, nil
}

func validateS3BucketTags(t *testing.T, remote_tags []*s3.Tag, input_tags map[string]string) {
	var missing_tags []string

	for _, tag := range remote_tags {
		if value, ok := input_tags[*tag.Key]; ok {
			assert.Equalf(t, value, *tag.Value, "The remote tag value: %v doesn't match the input value: %v.", *tag.Value, value)
		} else {
			missing_tags = append(missing_tags, *tag.Key)
		}
	}

	if len(missing_tags) > 0 {
		t.Fail()
		t.Logf("tags missing: %v", missing_tags)
	}
}
