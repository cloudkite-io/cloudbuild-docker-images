#!/bin/bash
set -eo pipefail

# --- Configuration ---
DB_SERVER="${DB_SERVER:-localhost}"
DB_DATABASE="${DB_DATABASE}"
DB_USER="${DB_USER:-sa}"
DB_PASSWORD="${MSSQL_SA_PASSWORD}"

# S3 Backup details from environment variables
S3_BUCKET="${S3_BUCKET}"
S3_REGION="${S3_REGION}"
S3_ENDPOINT="${S3_BUCKET}.s3.${S3_REGION}.amazonaws.com"
BACKUP_FILENAME="${DB_DATABASE}-diff-$(date +%Y-%m-%d-%H-%M).bak"
S3_URL="s3://${S3_ENDPOINT}/backups/${DB_DATABASE}/differential/${BACKUP_FILENAME}"
CREDENTIAL_NAME="s3://${S3_ENDPOINT}"

echo "Starting DIFFERENTIAL backup for database [${DB_DATABASE}] to ${S3_URL}"

# --- T-SQL Commands ---
CREATE_CREDENTIAL_SQL="
IF NOT EXISTS (SELECT 1 FROM sys.credentials WHERE name = '${CREDENTIAL_NAME}')
BEGIN
  CREATE CREDENTIAL [${CREDENTIAL_NAME}]
  WITH IDENTITY = 'S3 Access Key',
  SECRET = '${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}'
END"

BACKUP_DATABASE_SQL="
BACKUP DATABASE [${DB_DATABASE}]
TO URL = '${S3_URL}'
WITH DIFFERENTIAL, COMPRESSION, STATS = 10, MAXTRANSFERSIZE = 5242880;"

# --- Execution ---
echo "Ensuring S3 credential exists..."
sqlcmd -S "${DB_SERVER}" -U "${DB_USER}" -P "${DB_PASSWORD}" -Q "${CREATE_CREDENTIAL_SQL}" -b -C

echo "Executing DIFFERENTIAL backup..."
sqlcmd -S "${DB_SERVER}" -U "${DB_USER}" -P "${DB_PASSWORD}" -Q "${BACKUP_DATABASE_SQL}" -b -C -t 600

echo "DIFFERENTIAL backup of [${DB_DATABASE}] completed successfully."
