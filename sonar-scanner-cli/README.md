# sonna-scanner-cli
 This is a `sonarsource/sonar-scanner-cli` with `sudo` docker image which allows us to run `sonar` CLI commands and Tailscale GitHub action steps. `sudo` is required in the Tailscale GHA step.


 ### How to build

 This image is build manually with `gcloud builds submit . --tag=gcr.io/cloudkite-public/sonar-scanner-cli:<tag> --project=cloudkite-public`