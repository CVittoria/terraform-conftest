package utils

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/tidwall/gjson"
)

// GetInputs takes a path to a terragrunt directory containing a terragrunt.hcl file
// and returns a byte slice for user with buger/jsonparser package.
func GetInputs(tfdir string) ([]byte, error) {
	outjson := filepath.Join(tfdir, "/terragrunt_rendered.json")
	cmd := exec.Command("terragrunt", "render-json")
	cmd.Dir = tfdir

	err := cmd.Run()
	if err != nil {
		return nil, fmt.Errorf("problem rendering terragrunt json: %v", err)
	}

	tghcl, err := os.ReadFile(outjson)
	if err != nil {
		return nil, fmt.Errorf("problem reading terragrunt.json: %v", err)
	}

	inputs := gjson.GetBytes(tghcl, "inputs")

	os.Remove(outjson)
	return []byte(inputs.Raw), nil
}
