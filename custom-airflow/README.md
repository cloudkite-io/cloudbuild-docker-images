# Custom Airflow image

After editing, to build and push the new Docker image, `cloudbuild` and `GAR` permissions are needed, but if you do have the permissions please run:

```bash
gcloud builds submit --config build.yaml . --project=cloudkite-public

```
Thanks.
