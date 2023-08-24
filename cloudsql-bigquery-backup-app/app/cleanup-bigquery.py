#!/usr/bin/env python3
import json
import argparse
import logging
from helper_utils import is_deletion_candidate, exec_shell_command, epoch_millisecs_to_date


def delete_snapshot(entry_id):
    try:
        _ = exec_shell_command([
            'bq', 'rm',
            '-f',
            f'{entry_id}'
        ])
        print(f"Successfully deleted table snapshot: {entry_id}")
    except Exception as delSnapErr:
       print(f"Error deleting table snapshot {entry_id}: {delSnapErr}")
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Delete the old BigQuery Snapshots objects in a GCP project'
    )
    parser.add_argument('--project', required=True, help='Specify BigQuery Snapshots GCP project')
    parser.add_argument('--dataset', required=False, help='Specify the BigQuery datset')
    parser.add_argument('--quiet', action='store_true', help='Turn off verbose logging')

    args = parser.parse_args()
    if not args.quiet:
        logging.basicConfig(level=logging.INFO)

    project = args.project

    if args.dataset:
        datasets = [args.dataset]
    else:
        # Get all datasets in the project
        datasets_str = exec_shell_command(
            ['bq', '--format=json', 'ls',
                f'--project_id={project}']
        )
        datasets = json.loads(datasets_str)
        datasets = [_dataset['datasetReference']['datasetId']
                    for _dataset in datasets if 'dataset' in _dataset['kind']]

        for dataset in datasets:
            dataset_contents = exec_shell_command(
                ['bq', '--format=json', 'ls', '--project_id={}'.format(project), dataset]
            )
            if dataset_contents:
                dataset_contents = json.loads(dataset_contents)
                
                for entry in dataset_contents:
                    # Filter out Snapshots
                    if entry['type'] == "SNAPSHOT":
                        entry_id = entry['id']
                        
                        entry_contents = json.loads(exec_shell_command(
                            ['bq', '--format=json', 'show',
                                f'{entry_id}']
                        ))
                        creation_date = epoch_millisecs_to_date(
                            entry_contents['creationTime'])
                        # Delete snapshots older than 2 weeks (but not taken on first day of the month)
                        if is_deletion_candidate(creation_date):
                            delete_snapshot(entry_id)
        

    print("Job complete!")
