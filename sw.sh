conn=$1
op=$2
file=$3
delete=$4


if [[ -z $op ]] ; then
  echo '''
usage: <connection> get all
       <connection> get <file>
       <connection> put all [-delete]
                ~ -delete: delete before uploading
       <connection> put <file>     
      '''
fi

if [[ $file == all ]] ; then
  if [[ $OPTION == get ]] ; then
    FILE=
  else
    FILE=*.yaml
  fi
else
  FILE=$file
fi

if [[ $delete == -delete && $file == all ]] ; then
  snowsql -o log_level=DEBUG  -c ${conn} -q "REMOVE @CODE/"
fi

if [[ $op == get ]] ; then
  snowsql -o log_level=DEBUG  -c ${conn} -q "GET @CODE/ file://. "
fi

if [[ $op == put ]] ; then
  snowsql -o log_level=DEBUG  -c ${conn} -q "PUT file://${FILE} @CODE/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE"
fi