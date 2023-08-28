# Data Backup
Backup is initiated via Cloud Scheduler via terraform.  Example:

```terraform
variable "scheduled_data_backup" {
  type        = map
  default     = {
      # BigQuery
      bq-backup = {
        description = "Data backup using cloud build and cloud scheduler"
        schedule = "0 3 * * *"
        source_project = "<source-project>"
        destination_project = "<dest-project>"
        source = "bigquery"
        destination = "gs://<gcs-bucket>/<folder-name>"
      }
      # CloudSQL
      cloudsql-backup = {
        description = "Data backup using cloud build and cloud scheduler"
        schedule = "0 3 * * *"
        source_project = "<dest-project>"
        destination_project = ""
        source = "cloudsql"
        destination = "gs://<gcs-bucket>/<folder-name>"
      }
  }
}


resource "google_cloud_scheduler_job" "backup-job" {
  for_each         = var.scheduled_data_backup
  name             = "${each.key}-data-backup-job"
  description      = each.value.description
  schedule         = each.value.schedule
  attempt_deadline = "360s"
  project      = var.gcp["project"]

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/projects/${var.gcp.project}/builds"
    body        = base64encode(jsonencode({
        "steps": [{
            "args": [
                "/app/backup.py", 
                "--resource=${each.value.source}",
                "--source_project=${each.value.source_project}"
                "--destination_project=${each.value.destination_project}"
            ],
            "name": "gcr.io/cloudkite-public/bigquery-cloudsql-backup:<tag>"
        }],
          "timeout": "43200s"
      }))

    oauth_token {
      service_account_email = google_service_account.data_backup.email
    }
  }
}

# Create a service account for Data backup
resource "google_service_account" "data_backup" {
  project      = var.gcp["project"]
  account_id   = "data-backup"
  display_name = "Data backup Service Account"
}
```
# How to deploy `cloudsql-bigquery-backup-app` image ?
> export _tag=`date +%Y%m%d` && gcloud builds submit . --tag=gcr.io/cloudkite-public/cloudsql-bigquery-backup-app:$_tag



# Restore

## BigQuery

### Bucket backups
This script restores backed up BQ tables into an existing BQ dataset.
The script takes 4 args:

1. `--input`: This is the GCS bucket path to the the backed-up table.
`gs://<gcs-bucket>/<folder-name>/<yyyy-mm-dd>/<dataset-name>/<table-name>/`: Use this to restore a single table
`gs://<gcs-bucket>/<folder-name>/<yyyy-mm-dd>/<dataset-name>/`: Use this to restore a whole dataset
2. `--output`: This is the name of the destination dataset, where you are restoring to in big query
3. `--location`: This is the location of the bigquery dataset you are restoring to. `US`
4. `--project`: This is the GCP project housing the bigquery dataset.


If you wish to restore just a single table to a dataset, run this script.

    ./start-bq-restore-table.sh

If you wish to restore a whole dataset to bigquery, run this script instead.

    ./start-bq-restore-dataset.sh


The scripts kick off a cloudbuild (or cloudbuilds in the case of restoring a dataset) that restores data to bigquery dataset or table.

Under the hood, the scripts are simply bash wrappers that run gcloud with the right substitutions.

```bash
gcloud builds submit --no-source --async --config=cloudbuild-bq-restore.yaml --project=${CLOUDBUILD_PROJECT} --substitutions="..."
```

See `cloudbuild-bq-restore.yaml` for details.


### Snapshots

> `bq cp --restore --no_clobber <source dataset>_snapshot.<source table> <target dateset>.<target table>`

## Cloudsql

The backup process for cloudsql use the in-built cloudsql snapshot to back-up.

To restore the backups, follow these steps:

1. On the instance page, click the on the backups tab on the left panel.

![Backup Tab](images/backup-tab.png?raw=true "Backup Tab")

2. From the list of backups, choose the one you wish to restore and click on the restore button on the right of that backup.

![Restore Button](images/restore-btn.png?raw=true "Restore Button")

3. Enter the details requested in the resulting dialog box and click on the restore button.

![Restore Details](images/restore-details.png?raw=true "Restore Details")


