#!/usr/bin/env bash

# make newlines the only separator
IFS=$'\n'

EXIT_CODE_SUCCESS=0

PATH_CONVERT_FILE=""
PATH_CONVERT_DIR=""

ARG_PATH="$1"

CONFIG_MODE_DIR=0
CONFIG_MODE_FILE=1
CONFIG_MODE=-1

COUNT_TOTAL=0
COUNT_CONVERTED_SUCCESS=0
COUNT_CONVERTED_FAIL=0
COUNT_ALREADY_UTF8=0
COUNT_NOT_RECOGNIZED=0

function requirements ()
{
    type file
    type iconv
    type dos2unix
    type enca
}

function args_validate ()
{
    exit_code_args=$EXIT_CODE_SUCCESS
    if [[ -f "$ARG_PATH" ]];then
        echo "[✓] File exists "$ARG_PATH
        PATH_CONVERT_FILE="$ARG_PATH"
        CONFIG_MODE=$CONFIG_MODE_FILE
    elif [[ -d "$ARG_PATH" ]]; then
        echo "[✓] Directory exists "$ARG_PATH
        PATH_CONVERT_DIR="$ARG_PATH"
        CONFIG_MODE=$CONFIG_MODE_DIR
    else
        exit_code_args=1
    fi
    return $exit_code_args
}

function convert_single_file ()
{
  file "$1"
}

function convert_files ()
{
  for line in `find "$1" -type f -iname "*.txt"` ; do
    convert_single_file $line;
  done;
}

function run ()
{
    args_validate
    if [ $? -eq 0 ]
    then
      requirements
      if [[ $CONFIG_MODE = $CONFIG_MODE_FILE ]]
      then
        convert_single_file $PATH_CONVERT_FILE
      elif [[ $CONFIG_MODE = $CONFIG_MODE_DIR ]]
      then
        convert_files $PATH_CONVERT_DIR
      fi
    else
      echo "[✗] Invalid arguments"
    fi
}

run
