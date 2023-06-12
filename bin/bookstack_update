#!/bin/sh

# Creates or Updates a Page on Bookstack
# the name of the book is taken from $1
# the name of the page is taken from $2
# uses an sqlite db to keep track of the pages and their ids
# if the $2 id doesnt exists in the db
#   then it creates it and adds it to the db
#   else it updates the page

DB_PATH=~/code/github/simpleql/bookstack/bookstack.db
BOOK=$(echo $1 | rev | cut -d/ -f1 | rev)
PAGE_NAME=$(echo $2 | \
            awk -F '.' '{print $1}' | \
            tr '-' ' ' | \
            awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')
PAGE_CONTENT=$(sed 's/$/\\n/' $1/$2 | tr -d '\n')
PAGE_ID=$(sqlite3 ${DB_PATH} "select id from pages where filename=='$2';") 

case ${BOOK} in
"devops")
   BOOK_ID=16 ;;
esac

# TODO save as .csv and then insert into table
if [[ -z ${PAGE_ID} ]]; then
  PAGE_ID=$(curl -s \
  --request POST \
  --url https://bookstack.ops.aws.paris.cl/api/pages \
  --header "Content-Type: application/json" \
  --header "Authorization: Token ${BOOKSTACK_TOKEN_ID}:${BOOKSTACK_TOKEN_SECRET}" \
  --data '{"book_id": "'"${BOOK_ID}"'", "name": "'"${PAGE_NAME}"'", "markdown": "'"${PAGE_CONTENT}"'"}' | \
  jq -r '.id')
  sqlite3 ${DB_PATH} "insert into pages (id,
                                        filename,
                                        pagename,
                                        filepath,
                                        book_id)
                                values ($PAGE_ID,
                                        '$2',
                                        '$PAGE_NAME',
                                        '$1',
                                        $BOOK_ID);"
else
  curl -s \
  --request PUT \
  --url https://bookstack.ops.aws.paris.cl/api/pages/${PAGE_ID} \
  --header "Content-Type: application/json" \
  --header "Authorization: Token ${BOOKSTACK_TOKEN_ID}:${BOOKSTACK_TOKEN_SECRET}" \
  --data '{"book_id": "'"${BOOK_ID}"'", "name": "'"${PAGE_NAME}"'", "markdown": "'"${PAGE_CONTENT}"'"}'
fi

# TODO do a spellcheck
# TODO when running Bsup echo that its been saved and copy to clipboard the URL of the page
