# MySQL Upload multiple MySQL database files, archives and dumps

This set of scripts is a command line tool to upload one or multiple MySQL files to a MySQL Server.


![screencast](https://github.com/VanDerLars/MySQL-Upload-multiple-Dumps/blob/main/screenshot.png)

## Dependencies

**You need to have the mysql cli installed:**
- MacOS: https://formulae.brew.sh/formula/mysql#default `brew install mysql`
- Linux: https://computingforgeeks.com/how-to-install-mysql-8-on-ubuntu/
- Windows: make a web search :)

## usage with one single .sql file or .sql.gz archive

The script `MySQL_upload_single.sh` uploads one single .sql file or .sql.gz archive to a MySQL server.
1. `cd` into repository directory
2. run `sh MySQL_upload_single.sh` it tells you to run the follwing structure: 
`sh MySQL_upload_single.sh -u{user} -p{password} -h {server_ip} {path_to_sql_file} -v;`
3. run it in this structure and the upload begins

## usage with multiple files or archives

The script `MySQL_upload_all.sh` goes through all files within a specific directory, validates it and uploads it. Before this, you have to set some options within this file.

1. Open the file `MySQL_upload_all.sh``
2. Have a look at the top of the file, there are some variable you have to change: 
 - `DB_USER` The user on the MySQL server. Needs privileges to dump and create databases.
 - `DB_PSWD` Your password of the Server. Keep it save.
 - `DB_HOST` The IP or domain where the server lives, without the port. If you need to set another port, get in touch with me.
 - `PATH_TO_BACKUP_FILES` The directory where your about-to-uploaded-files are. Needs to be a **subdirectory** of the current repo directory.
3. Save the file
4. make sure that the names of the sql-files you're about to upload have the same name as the database which they have to executed.
5. If a database doesn't exists yet, the script will create one
6. run `sh MySQL_upload_all.sh`
7. It now starts to go through all the files within `PATH_TO_BACKUP_FILES` and tries to upload them.

## Features and behavior

- Uploads multiple SQL files and archives
- Created databases by the file name of the sql file. For example the file `myDatabase.sql.gz` will be executed in the database `myDatabase`. If it doesn't exists yet, it created the database `myDatabase`
- Makes some changes to your procedures and functions to work properly.
- Unzips and zips the files for you to improve speed and traffic usage.
- Writes the complete output of the mysql client to textfiles so that you can have a look at error messages that may occur.
- Moves the ready processed sql files to a `processed` directory for better overview.

## Hint for creating dumps

If you want to upload MySQL dumps, than I recomment to use this options for the `mysqldump` or the `mysqldump-secure` CLI:
`--opt --default-character-set=utf8 --hex-blob --complete-insert --extended-insert --compress --skip-triggers --routines --set-gtid-purged=OFF --column-statistics=0`

-> Triggers always makes problems, I skip them here and create them later manually or over other scripts. I recommend this to you as well.

## thats all

Allright, this little set should give you everything you need. With `mysqldump` or the `mysqldump-secure` CLI you have now everything to synch to MySQL servers comletely automated.

Send me a line if I can help you.

And: I am totally no Bash/Zsh/Shell professional. Most things here are just hours of reading on stackoverflow and trying around. So, if you find something to improve, I am happy to see a pull request!
