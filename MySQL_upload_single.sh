#!/bin/bash
# backup one database file
# sh MySQL_upload_single.sh -u {user} -p{password} -h {server_ip} {path_to_sql_file} -v;

usage() {
	echo "$0 wrong usage." >&2
	echo "use it like this:"
	echo "     -> sh MySQL_upload_single.sh -u{user} -p{password} -h {server_ip} {path_to_sql_file} -v;"
	exit 1
}

ARGS=()
FILES=()
arg() {
	ARGS=("${ARGS[@]}" "$1")
}
file() {
	FILES=("${FILES[@]}" "$1")
}

[[ $# == 0 ]] && usage

# Slightly modified getopts alternative
while [[ $# != 0 ]] ; do
	case $1 in
		--)
			break
		;;
		-\?)
			usage
		;;
		-[uphS]) 
			arg $1
			arg $2
			shift
		;;
		-*)
			arg $1
		;;
		*)
			file $1
		;;
	esac
	shift
done

for FILE in "${FILES[@]}" ; do
	if [[ ! -f $FILE ]] ; then
		echo "-> Skipping '$FILE' (not a file)"
		continue
	fi
	NAME=${FILE##*/}
		
		echo "││┬ 📋 create result directory"
		mkdir results
		echo "││└ ✅"
  		echo "││" # ----

	if [[ $FILE == *.[gG][zZ] ]] ; then
		NAME=${NAME%.[gG][zZ]}
		DB=${NAME%.[sS][qQ][lL]}
		
		echo "││┬ 📋 create result file for $DB"
		db_res="results/$DB.result.txt"
		touch "$db_res"
		echo "││└ ✅"
  		echo "││" # ----
		echo "││┬ 📋 uploading DB \033[1m$DB\033[0m from file \033[1m$FILE\033[0m"
		mysql "${ARGS[@]}" -e "create database if not exists \`$DB\`;" | sed 's/^/  /'
		gunzip < "$FILE" | mysql $DB "${ARGS[@]}" -f >> $db_res 2>&1 | sed 's/^/  /'
		echo "││└ ✅"
		# the command  | sed 's/^/  /' is only for formatting
	else
		DB=${NAME%.[sS][qQ][lL]}

		echo "││┬ 📋 create result file for $DB"
		db_res="results/$DB.result.txt"
		touch "$db_res"
		echo "││└ ✅"
  		echo "││" # ---- 
		echo "││┬ 📋 uploading DB \033[1m$DB\033[0m from file \033[1m$FILE\033[0m"
		mysql "${ARGS[@]}" -e "create database if not exists \`$DB\`;" | sed 's/^/  /'
		mysql $DB "${ARGS[@]}" < "$FILE" -f >> $db_res 2>&1 | sed 's/^/  /'
		echo "││└ ✅"
	fi
done
