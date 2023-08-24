#!/bin/bash

read -p "Enter cloudbuild GCP project (e.g. \"test\"): " _CLOUDBUILD_PROJECT
read -p "Enter destination BigQuery Dataset (e.g. \"test\"): " _DEST_DATASET
read -p "Enter source GCS bucket (e.g. \"gs://..../dataset/\"): " _SOURCE_BUCKET
read -p "Enter destination BigQuery Dataset's location (e.g. \"US\"): " _DEST_DATASET_LOCATION
read -p "Enter destination BigQuery GCP project (e.g. \"cloudkite-dev\"): " _PROJECT
read -p "Restore image tag TO USE (e.g. \"DEFAULTS TO LATEST\"): " _IMAGE_TAG

echo ""
echo "Variables collected are:"
echo ""
echo "GCS source bucket as ===> ${_SOURCE_BUCKET}"
echo "BigQuery dataset as ===> ${_DEST_DATASET}"
echo "BigQuery location as ===> ${_DEST_DATASET_LOCATION}"
echo "BigQuery GCP project as ===> ${_PROJECT}"
echo "Cloudbuild GCP project as ===> ${_CLOUDBUILD_PROJECT}"
echo "Restore image tag as===> ${_IMAGE_TAG}"
echo ""

function verify() {
  read -r -p "Do you wish to continue? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY]) 
      true
      ;;
    *)
      exit 1
      ;;
  esac
}
verify
  
bq_tables="tables.csv"
gsutil ls ${_SOURCE_BUCKET}> $bq_tables

line_num=0
count=1
while read -r line
do

gcloud builds submit --no-source --async \
    --config=cloudbuild-bq-restore.yaml \
    --project=${_CLOUDBUILD_PROJECT} \
    --substitutions=_SOURCE_BUCKET="${line}",_DEST_DATASET="${_DEST_DATASET}",_PROJECT="${_PROJECT}",_DEST_DATASET_LOCATION="${_DEST_DATASET_LOCATION}",_IMAGE_TAG="${_IMAGE_TAG}"

echo $count
count=$(( $count + 1 ))
done < $bq_tables
