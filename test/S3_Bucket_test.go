package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Standard Go test, with the "Test" prefix and accepting the *testing.T struct.
func TestS3Bucket(t *testing.T) {
	//Setting the region
	awsRegion := "us-east-1"

	// This is using the terraform package that has a sensible retry function.
	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The directory of the main.tf file
		TerraformDir: "../Terraform",

		// Defines the "bucket_name" variable in the main.tf file
		Vars: map[string]interface{}{
			"bucket_name": fmt.Sprintf("-%v", strings.ToLower(random.UniqueId())),
		},

		// Sets the AWS region.
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// Destroys the infrastructure after testing.
	defer terraform.Destroy(t, terraformOpts)

	// Deploys the infrastructure with the options defined above
	terraform.InitAndApply(t, terraformOpts)

	// Gets the bucket ID so we can query AWS
	bucketID := terraform.Output(t, terraformOpts, "bucket_id")

	//Retrieves the contents and any error (if any) from the bucket
	contents, err := aws.GetS3ObjectContentsE(t, awsRegion, bucketID, "test1")

	//Checks if there was any error when fetching the butcket contents
	assert.NoError(t, err, contents)
}
