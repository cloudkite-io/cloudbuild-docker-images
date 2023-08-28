#!/usr/bin/env python3

import logging
import argparse
import tempfile
import json
import os


from helper_utils import exec_shell_command, read_json_string

def create_dataset(dataset, location, project):

    exec_shell_command([
        'bq', '--location={}'.format(location), 
        'mk', '--dataset', 
        '{}:{}'.format(project, dataset)
    ])

def restore_view(tbldef, fromdir, todataset, project):
    """
    Restore schema & data from GCS to BigQuery table
    :param tbldef: Table definition dict
    :param fromdir: GCS input directory gs://..../dataset/tablename/
    :param todataset: BigQuery dataset name
    """

    query = tbldef['view']['query']
    view_name = tbldef['tableReference']['tableId']
    legacy_sql = tbldef['view']['useLegacySql']

    exec_shell_command([
        'bq', 'mk',
        '--view', query,
        '--{}use_legacy_sql'.format('no' if not legacy_sql else ''),
        '--project_id={}'.format(project), 
        '{}.{}'.format(todataset, view_name)
    ])

def restore_table(fromdir, todataset, project):
    """
    Restore schema & data from GCS to BigQuery table
    :param fromdir: GCS input directory gs://..../dataset/tablename/
    :param todataset: BigQuery dataset name
    """

    # start to create load command
    load_command = [
        'bq', 'load',
        '--project_id={}'.format(project), 
        '--source_format', 'AVRO',
        '--use_avro_logical_types', # for DATE, TIME, NUMERIC
    ]

    # get table definition
    tbldef = read_json_string(os.path.join(fromdir, 'tbldef.json'))

    if tbldef['type'] == 'VIEW':
        restore_view(tbldef, fromdir, todataset, project)
        return

    if 'timePartitioning' in tbldef:
        load_command += [
            '--time_partitioning_expiration', tbldef['timePartitioning']['expirationMs'],
            '--time_partitioning_field', tbldef['timePartitioning']['field'],
            '--time_partitioning_type', tbldef['timePartitioning']['type'],
        ]

    if 'rangePartitioning' in tbldef:
        load_command += [
            '--range_partitioning',
            '{},{},{},{}'.format(
                tbldef['rangePartitioning']['field'],
                tbldef['rangePartitioning']['range']['start'],
                tbldef['rangePartitioning']['range']['end'],
                tbldef['rangePartitioning']['range']['interval']
            )
        ]

    if 'clustering' in tbldef:
        load_command += [
            '--clustering_fields',
            ','.join(tbldef['clustering']['fields'])
        ]

    # write schema to a temporary file
    schema = tbldef['schema']['fields']  # array of dicts
    fd, schema_file = tempfile.mkstemp()
    with open(schema_file, 'w') as ofp:
        json.dump(schema, ofp, sort_keys=False, indent=2)
    os.close(fd)
    load_command += [
        '--schema', schema_file,
    ]

    # load the data into BigQuery
    table_name = tbldef['tableReference']['tableId']
    load_command += [
        '{}.{}'.format(todataset, table_name),
        os.path.join(fromdir, 'data_*.avro')
    ]
    
    exec_shell_command(load_command)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Restore a BigQuery dataset from Google Cloud Storage'
    )
    parser.add_argument('--input', required=True, help='GCS URL gs://..../dataset/tablename/ ')
    parser.add_argument('--output', required=True, help='destination dataset')
    parser.add_argument('--location', required=True, help='LOcation of bigquery dataset')
    parser.add_argument('--project', required=True, help='Specify Data source GCP project')
    parser.add_argument('--quiet', action='store_true', help='Turn off verbose logging')

    args = parser.parse_args()
    if not args.quiet:
        logging.basicConfig(level=logging.INFO)
    
    create_dataset(args.output, args.location, args.project)
    restore_table(args.input, args.output, args.project)
