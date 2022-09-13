package test

import (
	"fmt"
	"net"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/credentials/stscreds"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
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

	vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpc_id)

	cidr_map := terraform.OutputMap(t, terraformOptions, "subnet_cidrs")
	for _, cidr := range cidr_map {
		_, _, err := net.ParseCIDR(cidr)
		assert.NoError(t, err)
	}

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

	azs, err := getAWSRegionAZs(aws_region, assume_role)
	if err != nil {
		t.Errorf("problem describing region AZ's: %v", err)
	}

	az_map := terraform.OutputMap(t, terraformOptions, "subnet_id_by_az")
	for az, _ := range az_map {
		assert.Contains(t, azs, az)
	}
}

func getAWSRegionAZs(region string, role string) ([]string, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region),
	})
	if err != nil {
		return nil, fmt.Errorf("unable to start AWS session: %v", err)
	}

	creds := stscreds.NewCredentials(sess, role)

	svc := ec2.New(sess, &aws.Config{Credentials: creds})
	input := &ec2.DescribeAvailabilityZonesInput{}

	result, err := svc.DescribeAvailabilityZones(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			fmt.Println(err.Error())
		}
		return nil, err
	}

	var azs []string
	for _, az := range result.AvailabilityZones {
		azs = append(azs, *az.ZoneName)
	}

	return azs, nil
}
