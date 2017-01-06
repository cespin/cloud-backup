#!/usr/bin/env bash

APPEND_COMMA="0"
CONTENTS_TEMP_FILE=`date +%s`
FILEMAP_TEMP_FILE="$(($CONTENTS_TEMP_FILE + 1))"

SCRIPT_PATH="`dirname \"$BASH_SOURCE\"`"
SCRIPT_PATH="`( cd \"$SCRIPT_PATH\" && pwd )`"
if [ -z "$SCRIPT_PATH" ] ; then
  echo "Couldn't figure out the location of cloud-backup.sh"
  exit 1  # fail
fi

echo -n '[' > $CONTENTS_TEMP_FILE
for i in $( find $PWD -type f -exec $SCRIPT_PATH/mapper.sh {} \; ); do

    if [ "$APPEND_COMMA" -eq "1" ]
    then
        echo -n , >> $CONTENTS_TEMP_FILE
    fi

    echo -n {$i} >> $CONTENTS_TEMP_FILE
    APPEND_COMMA="1"
done
echo -n ']' >> $CONTENTS_TEMP_FILE

cat $CONTENTS_TEMP_FILE | jq -c 'def r(a): reduce a[] as $item ({}; . + $item); def x(a): {(a): r(map({(.m):(.n)}))}; group_by(.d) | {"archiveID": "","contents": r(map(x(first.d)))}' >> $FILEMAP_TEMP_FILE

