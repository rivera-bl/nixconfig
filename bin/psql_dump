#!/bin/sh
# tmux setenv PGPASSWORD
# TODO convert to golang with nix flakes

DB_TARGET_PASS=$(tmux showenv PGPASSWORD | cut -f2- -d=)
APP=$1
ENV=$2
POD=$3 # this assumes pods across contents are the same
DB_URl=$4
DB_USER= $5
DB_DATABASE=$6

file=${APP}-${ENV}.sql 

function main(){
  dump
  kcp
  restore
}

function dump(){
  kubectl exec -ti ${POD} -- sh -c "export PGPASSWORD=\$POSTGRES_POSTGRES_PASSWORD && \
                                                        mkdir -p /tmp/dump && \
                                                        cd /tmp/dump && \
                                                        pg_dump \
                                                          --exclude-table-data "schema.audit*" \
                                                          --exclude-table-data "public.audit*" \
                                                          --no-owner -U ${DB_USER} ${DB_DATABASE} \ -Fc > dump.sql"
}

function kcp() {
  kubectl cp ${POD} ${file}
}

function restore(){
  export PGPASSWORD=${DB_TARGET_PASS}
  pg_restore --verbose --clean --if-exists \
    -h ${DB_URL} \
    -p 5432 -U ${DB_USER} -d ${DB_DATABASE} \
    ${file} \
    | tee -a "${file}-errors.log"

  cat ${file}-errors.log
}

# TODO fix watching /tmp
function monitor(){
  tmux select-pane -R
  tmux split-window -v "kubectl exec -ti ${POD} -- bash \
    -c 'sleep 2s && watch 'ls -alh /tmp/dump/dump.sql''"
}


main
