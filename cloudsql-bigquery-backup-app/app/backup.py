#!/usr/bin/env python3
import datetime
import logging
import argparse
import json
import sys
import google.auth
from pprint import pprint
from googleapiclient import discovery

from helper_utils import exec_shell_command

def backup_dataset(dataset, tablename, source_project, destination_project):
    """
    Store table snapshot
    :param dataset: BigQuery dataset name
    :param tablename: BigQuery table name
    :param source_project: Source GCP Project
    :param destination_project: Backup Destination GCP Project
    :return: None
    """
    if not destination_project:
        destination_project = source_project

    full_table_name = '{}.{}'.format(dataset, tablename)
    full_table_snapshot_name = '{}_snapshot.{}_{}'.format(
        dataset,
        tablename,
        datetime.datetime.now().strftime(
            '%Y%m%d%H%M'
        )
    )
    _ = exec_shell_command([
        'bq', 'mk',
        '--project_id={}'.format(destination_project),
        f'{dataset}_snapshot'
    ])

    if datetime.datetime.now().strftime('%d') == '01':
        _ = exec_shell_command([
            'bq', 'cp',
            '--snapshot',
            '--no_clobber',  # required
            f'{source_project}:{full_table_name}', 
            f'{destination_project}:{full_table_snapshot_name}'
        ])
    else:
        _ = exec_shell_command([
            'bq', 'cp',
            '--snapshot',
            '--no_clobber',  # required
            '--expiration=1209600',  # 2 week
            f'{source_project}:{full_table_name}', 
            f'{destination_project}:{full_table_snapshot_name}'
        ])


def backup_instance(instance, project):
    """
    Create db backup
    :param instance: CLoudSQL instance name
    :param project: GCP project
    :return: None
    """
    try:
        credentials, quota_project = google.auth.default()
        gcp_service_cloudsql = discovery.build('sqladmin', 'v1beta4', credentials=credentials, cache_discovery=False)
        if instance:
            instances = [instance]
        else:
            instances_request = gcp_service_cloudsql.instances().list(project=project)
            instances_resp = instances_request.execute()
            instances = instances_resp.get('items', [])
            instances = [_instance['name'] for _instance in instances if _instance['state']
                         == 'RUNNABLE' and _instance['settings']['activationPolicy'] != 'NEVER']
        print(f"Backing up {len(instances)} active Cloud SQL instance(s)..")
        for instance in instances:
            request = gcp_service_cloudsql.backupRuns().insert(project=project, instance=instance)
            response = request.execute()
            pprint(response)
            print(f"Successfully backed up '{instance}' Cloud SQL instance.")
    except Exception as e:
        print(f"Error creating a new cloudsql backup: {e}")
        sys.exit(1)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Backup a BigQuery dataset (schema + data) to Google Cloud Storage'
    )
    parser.add_argument('--resource', required=True, help='Specify Source resource of data(cloudsql or bigquery)')
    parser.add_argument('--source_project', required=True, help='Specify Data source GCP project')
    parser.add_argument('--input', required=False, help='Specify Source of data(Dataset or Instance)')
    parser.add_argument('--destination_project', required=False, help='Specify Destination GCP project for the bigquery snapshots')
    parser.add_argument('--quiet', action='store_true', help='Turn off verbose logging')

    args = parser.parse_args()
    if not args.quiet:
        logging.basicConfig(level=logging.INFO)
    source_project = args.source_project
    
 
    if args.resource == "bigquery":
        destination_project = args.destination_project
        if args.input:
            datasets = [args.input]
        else:
            # Get all datasets in the project
            datasets_str = exec_shell_command(
                ['bq', '--format=json', 'ls', '--max_results=1000',
                    f'--project_id={source_project}']
            )
            datasets = json.loads(datasets_str)
            datasets = [_dataset['datasetReference']['datasetId']
                        for _dataset in datasets if 'dataset' in _dataset['kind']]
        
        backedup_tables = {_dataset: 0 for _dataset in datasets}

        for dataset in datasets:
            dataset_contents = exec_shell_command(
                ['bq', '--format=json', 'ls',
                    '--max_results=1000', '--project_id={}'.format(source_project), dataset]
            )
            dataset_contents = json.loads(dataset_contents) # array of dicts
            
            for entry in dataset_contents:
                if entry['type'] == 'TABLE' or entry['type'] == 'VIEW':
                    backedup_tables[dataset] += 1
                    backup_dataset(dataset, entry['tableReference']['tableId'], source_project, destination_project)
                else:
                    logging.warning(f"Not backing up {entry['id']} because it is a {entry['type']}")
        
            print(f"Successfully backed up {backedup_tables[dataset]} tables in '{dataset}' dataset.")

    elif args.resource == "cloudsql":
        instance = args.input
        backup_instance(instance, source_project)

    else:
        print("A resource of either Cloudsql or Bigquery is needed")
