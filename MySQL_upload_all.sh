#!/bin/bash

# -------------------------------
# ----------- CONFIG ------------
# Set Database Information here
DB_USER="root"
DB_PSWD="PASSWORD_VERY_SECRET"
DB_HOST="127.0.0.1"
PATH_TO_BACKUP_FILES="mysql_backups/path/to/dumps"
# -------------------------------
# -------------------------------



# -------------------------------
# ------------ CODE ------------
echo "\nIMPORT START"
mkdir $PATH_TO_BACKUP_FILES"/processed"

function process() {
  filename="${1##*/}"

  echo "โ ๐งจ Processing $1 ($filename)"
  echo "โ" # ----
  echo "โโฌ ๐ unzip file"
  gunzip $1 
  unzipped=${1%.gz}
  echo "โโ ๐ new file: $unzipped"
  echo "โโ โ"
  echo "โ" # ----
  echo "โโฌ ๐ replace definer in $unzipped"
  # $1 = echo LC_CTYPE=C && LANG=C && sed -E 's/CREATE(.*)FUNCTION/CREATE FUNCTION/g' $1;
  # $1 = echo LC_CTYPE=C && LANG=C && sed -E 's/CREATE(.*)PROCEDURE/CREATE PROCEDURE/g' $1;
  sed -i '' -E 's/CREATE(.*)FUNCTION/CREATE FUNCTION/g' $unzipped
  sed -i '' -E 's/CREATE(.*)PROCEDURE/CREATE PROCEDURE/g' $unzipped
  echo "โโ โ"
  echo "โ" # ----
  echo "โโฌ ๐ re-zip file"
  gzip $unzipped
  echo "โโ โ"
  echo "โ" # ----
  echo "โโฌ ๐ upload to MySQL Server"
  sh MySQL_upload_single.sh -u $DB_USER -p$DB_PSWD -h $DB_HOST $1
  echo "โโ โ"
  echo "โ" # ----
  echo "โโฌ ๐ move zip file to processed directory"
  mv $1 $PATH_TO_BACKUP_FILES"/processed/$filename"
  echo "โโ โ"
  echo "โ โ"
  echo "โ ๐ next"
}

for i in $PATH_TO_BACKUP_FILES/*
do
  if  [[ $i == *.sql ]] || [[ $i == *.sql.gz ]] ;
  then
    echo "\nโฌ ๐ PROCESS: $i"
    process $i
  else
    echo "\nโ ๐ SKIPPED: $i"
  fi
done


echo "\nโ IMPORT DONE"
