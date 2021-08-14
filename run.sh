#!/bin/bash
COMMAND=$1
TARGET_FOLDER="docs"
TAR_FILE_NAME="${TARGET_FOLDER}.tgz"
ALG="aes-256-cbc"

if [ $1 = "encrypt" ]; then
    if [ ! -d "${PWD}/${TARGET_FOLDER}" ]; then
        echo "${PWD}/$TARGET_FOLDER not found! Aborting"
        exit 1
    fi
   tar -czvf "${TAR_FILE_NAME}" "${TARGET_FOLDER}" && \
   openssl "${ALG}" -in "${TAR_FILE_NAME}" -out "${TAR_FILE_NAME}.${ALG}.encrypted" && \
   rm "${TAR_FILE_NAME}"
else
    if [ $1 = "decrypt" ]; then
        ENCRYPTED_FILE_NAME="${TAR_FILE_NAME}.${ALG}.encrypted"
        if [ ! -f "${PWD}/${ENCRYPTED_FILE_NAME}" ]; then
            echo "${PWD}/${ENCRYPTED_FILE_NAME} not found! Aborting"
            exit 1
        fi
        if [ -d "${PWD}/${TARGET_FOLDER}" ]; then
            echo "${PWD}/$TARGET_FOLDER already exists! Aborting"
            exit 1
        fi
        openssl "$ALG" -d -in "${ENCRYPTED_FILE_NAME}" -out "${TAR_FILE_NAME}" && \
        tar -xvf "${TAR_FILE_NAME}" && \
        rm "${TAR_FILE_NAME}"
    else
        echo "Invalid command: ${COMMAND}."
        echo "Valid options are encrypt, decrypt."
    fi
fi