DB_NAME="BEAN_STREAM_DB"
PROJECT="DEV"
CONNECTION="sandbox"


if [[ -z $1 ]] ; then
  echo '''
usage: get all | <file>
       put all [-delete] | <file>   
            ~ -delete: delete before uploading
      '''
fi

if [[ $2 == all ]] ; then
  if [[ $OPTION == get ]] ; then
    FILE=
  else
    FILE=*.yaml
  fi
else
  FILE=$2
fi

if [[ $3 == -delete && $2 == all ]] ; then
  snowsql -o log_level=DEBUG  -c ${CONNECTION} -q "REMOVE @${DB_NAME}.${PROJECT}.CODE/"
fi

if [[ $1 == get ]] ; then
  snowsql -o log_level=DEBUG  -c ${CONNECTION} -q "GET @${DB_NAME}.${PROJECT}.CODE/ file://. "
fi

if [[ $1 == put ]] ; then
  snowsql -o log_level=DEBUG  -c ${CONNECTION} -q "PUT file://${FILE} @${DB_NAME}.${PROJECT}.CODE/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE"
fi