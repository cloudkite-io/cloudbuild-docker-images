# sonna-scanner-cli
 This image helps us to keep a copy of `sonarsource/sonar-scanner-cli` docker image in our CK library and also add additional packages to it. Currently, we only have `sudo` added.


 ### How to build

 This image is build manually with `gcloud builds submit . --tag=gcr.io/cloudkite-public/sonar-scanner-cli:<tag> --project=cloudkite-public`