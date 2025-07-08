# Custom GCP Airflow image

This image currently contains:
 * latest Airflow Google provider v1.16.0


After editing, to build and push the new Docker image manually, `cloudbuild` and `GAR` permissions are needed, but if you do have the permissions please run:

```bash
# After commiting changes run:
AIRFLOW_IMAGE_TAG=airflow-gcp-$(git log -1 --format=%cd --date=format:'%Y%m%d%H%M')

gcloud builds submit --config build.yaml --substitutions _IMAGE_TAG=$AIRFLOW_IMAGE_TAG --project=cloudkite-public .

```
Thanks.
