#!/bin/bash


# required env vars SOURCE_DB_SERVER,SOURCE_DB_NAME,SOURCE_DB_RESOURCE_GROUP_NAME,SOURCE_DB_USER,SOURCE_DB_PASSWORD
# SOURCE_DB_PASSWORD,DESTINATION_DB_NAME,DESTINATION_DB_RESOURCE_GROUP_NAME,DESTINATION_DB_USER,DESTINATION_DB_PASSWORD

# unix timestamp
DATE=$(date +%s)

. /azure/bin/activate && az login --federated-token "$(cat $AZURE_FEDERATED_TOKEN_FILE)" \
--service-principal -u ${AZURE_CLIENT_ID} -t ${AZURE_TENANT_ID}

## export sql db 
az sql db export -s ${SOURCE_DB_SERVER} -n ${SOURCE_DB_NAME} -g ${SOURCE_DB_RESOURCE_GROUP_NAME} \
-p ${SOURCE_DB_PASSWORD} -u ${SOURCE_DB_USER} \
--storage-key ${STORAGE_ACCESS_KEY} --storage-key-type StorageAccessKey \
--auth-type SQL --storage-uri "${STORAGE_URI}/${SOURCE_DB_NAME}-db-backup-${DATE}.bacpac"

## delete sql db as one can only import to an empty db
az sql db delete -s ${DESTINATION_DB_SERVER} -n ${DESTINATION_DB_NAME} \
-g ${DESTINATION_DB_RESOURCE_GROUP_NAME} -y

## create sql db 
az sql db create -s ${DESTINATION_DB_SERVER} -n ${DESTINATION_DB_NAME} \
-g ${DESTINATION_DB_RESOURCE_GROUP_NAME} -e GeneralPurpose \
-f Gen5 -c 1 --compute-model Serverless --auto-pause-delay 60

## update db server to allow public access required by import

az sql server update -n ${DESTINATION_DB_SERVER} -g ${DESTINATION_DB_RESOURCE_GROUP_NAME} \
-e true

## import sql db
az sql db import -s ${DESTINATION_DB_SERVER}  -n ${DESTINATION_DB_NAME} -g ${DESTINATION_DB_RESOURCE_GROUP_NAME} \
-p ${DESTINATION_DB_PASSWORD} -u ${DESTINATION_DB_USER} \
--storage-key ${STORAGE_ACCESS_KEY} --storage-key-type StorageAccessKey \
--auth-type SQL --storage-uri "${STORAGE_URI}/${SOURCE_DB_NAME}-db-backup-${DATE}.bacpac"

## update db server to disable public access

az sql server update -n ${DESTINATION_DB_SERVER} -g ${DESTINATION_DB_RESOURCE_GROUP_NAME} \
--enable-public-network false