#!/usr/bin/env python3

import logging
import argparse
import google.auth
import sys

from pprint import pprint
from googleapiclient import discovery

from helper_utils import is_deletion_candidate

def delete_backups(backup_id, instance, project, credentials):
    """Delete specific cloudsql backups in an instance"""
    try:
        gcp_service_cloudsql = discovery.build('sqladmin', 'v1beta4', credentials=credentials, cache_discovery=False)
        request = gcp_service_cloudsql.backupRuns().delete(project=project, instance=instance, id=backup_id)
        response = request.execute()
        pprint(response)
    except Exception as e:
        print(f"Error creating a new cloudsql backup: {e}")
        sys.exit(1)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Delete the backup objects in Google Cloud Storage'
    )
    parser.add_argument('--project', required=True, help='Specify CloudSQL GCP project')
    parser.add_argument('--instance', required=False, help='Specify the CloudSQL instance')
    parser.add_argument('--quiet', action='store_true', help='Turn off verbose logging')

    args = parser.parse_args()
    if not args.quiet:
        logging.basicConfig(level=logging.INFO)
    project = args.project
    instance = args.instance
    try:
        credentials, quota_project = google.auth.default()
        gcp_service_cloudsql = discovery.build('sqladmin', 'v1beta4', credentials=credentials, cache_discovery=False)
        if instance:
            instances = [instance]
        else:
            instances_request = gcp_service_cloudsql.instances().list(project=project)
            instances_resp = instances_request.execute()
            instances = instances_resp.get('items', [])
            instances = [_instance['name'] for _instance in instances]
        for instance in instances:
            try:
                request = gcp_service_cloudsql.backupRuns().list(project=project, instance=instance)
                while request is not None:
                    response = request.execute()

                    for backup in response['items']:
                        if backup['status'].upper() == "SUCCESSFUL":
                            timeCreated = backup['startTime'].split('T')
                            if is_deletion_candidate(timeCreated[0]):
                                delete_backups(backup['id'], instance, args.project, credentials)

                    request = gcp_service_cloudsql.operations().list_next(previous_request=request, previous_response=response)
            except Exception as delErr:
                print(f"Error fetching cloudsql backups for '{instance}' : {delErr}")
    except Exception as e:
        print(f"Error deleting cloudsql backups: {e}")
        sys.exit(1)

    print("ALL GOOD")
