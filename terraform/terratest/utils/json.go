package utils

import (
	"encoding/json"
	"fmt"

	"github.com/tidwall/gjson"
)

func Unmarshaller(result gjson.Result, intype any) error {
	raw := []byte(result.Raw)
	if err := json.Unmarshal(raw, &intype); err != nil {
		return fmt.Errorf("unable to unmarshal JSON: %v", err)
	}
	return nil
}
