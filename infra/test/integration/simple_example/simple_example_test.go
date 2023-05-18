// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package simple_example

import (
	"fmt"
	"net/http"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestSimpleExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		projectID := example.GetTFSetupStringOutput("project_id")
		gcloudArgs := gcloud.WithCommonArgs([]string{"--project", projectID})

		// check cloud run status
		services := gcloud.Run(t, ("run services list --format=json"), gcloudArgs).Array()
		for _, service := range services {
			conditions := service.Get("status.conditions").Array()
			for _, condition := range conditions {
				assert.True(condition.Get("status").Bool())
			}
		}

		// check cloud storage exist default content
		bucketName := example.GetStringOutput("cdn_bucket_name")
		storage := gcloud.Run(t, fmt.Sprintf("storage buckets describe gs://%s --format=json", bucketName), gcloudArgs)
		assert.NotEmpty(storage)

		// check app e2e is working
		lb_global_ip := example.GetStringOutput("lb_global_ip")
		serviceUrl := fmt.Sprintf("http://%s", lb_global_ip)
		isServing := func() (bool, error) {
			resp, err := http.Get(serviceUrl)
			if err != nil || resp.StatusCode != 200 {
				return true, nil
			}
			return false, nil
		}
		utils.Poll(t, isServing, 10, time.Minute*1)

		// Check cloud run jobs status
		isJobCompletion := func() (bool, error) {
			cloudRunJobs := gcloud.Run(t, ("beta run jobs list --format=json"), gcloudArgs).Array()
			var jobResults []bool
			for _, cloudRunJob := range cloudRunJobs {
				jobName := cloudRunJob.Get("metadata.name").String()
				jobCompletionTime := cloudRunJob.Get("status.latestCreatedExecution.completionTimestamp").String()
				jobExecutionCount := cloudRunJob.Get("status.executionCount").Int()
				fmt.Printf("Job %s completion time: %s, executionCount: %d\n", jobName, jobCompletionTime, jobExecutionCount)
				if jobCompletionTime == "" || jobExecutionCount < 1 {
					fmt.Printf("Job %s is not completed\n", jobName)
					jobResults = append(jobResults, false)
				} else {
					fmt.Printf("Job %s is completed\n", jobName)
					jobResults = append(jobResults, true)
				}
			}
			if allTrue(jobResults) {
				return false, nil
			}
			return true, nil
		}
		utils.Poll(t, isJobCompletion, 180, time.Second * 3)
	})
	example.Test()
}

func allTrue(arr []bool) bool {
    for _, value := range arr {
        if !value {
            return false
        }
    }
    return true
}
