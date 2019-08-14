#!/bin/sh

IFS=$'\n'

while true
do
  hellos=$(kubectl get hellos --template='{{ range $i := .items }}{{ printf "%s\n" $i.spec.name }}{{ end }}')

  if [ $? -ne 0 ]
  then
    echo 'Hello lookup failed.'
    exit 1
  fi

  echo '---'
  for i in $hellos
  do
    echo "Hello found: ${i}"
  done

  if [ ${LOOP:-0} -ne 1 ]
  then
    break
  fi

  sleep ${SLEEP:-5}
done
