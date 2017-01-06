#!/usr/bin/env bash

# check dependencies (awscli 1.11.34 or above,  etc)
#

# Initiate Multipart Upload - 1MB pieces
# aws --profile personal glacier initiate-multipart-upload --account-id 250036610033 --part-size 1048576 --vault-name PicsTest --archive-description "CouchbaseTraining.tar.gz"
# {
#     "uploadId": "UnV9Dr0m1vR1Lg64urYnvw6cmCF0X8MmO5O4MRYB7S7Ine9y90Y70NbHrAa5UclsM__4TOSdKbhZoyKr1bSSKmInGNNd",
#     "location": "/250036610033/vaults/PicsTest/multipart-uploads/UnV9Dr0m1vR1Lg64urYnvw6cmCF0X8MmO5O4MRYB7S7Ine9y90Y70NbHrAa5UclsM__4TOSdKbhZoyKr1bSSKmInGNNd"
# }
#
# Split the file into 1MB pieces
# split -b 1024k ../CouchbaseTraining.tar.gz
#
# Upload One 1MB piece
# aws --profile personal glacier upload-multipart-part --body xaa --range 'bytes 0-1048575/*' --account-id 250036610033 --vault-name PicsTest --upload-id UnV9Dr0m1vR1Lg64urYnvw6cmCF0X8MmO5O4MRYB7S7Ine9y90Y70NbHrAa5UclsM__4TOSdKbhZoyKr1bSSKmInGNNd
# {
#     "checksum": "1df0ff115d81b1263d75cbb31f1ecf60f5da4fffc843528f8667c14f2c84c814"
# }
#
# Calculate Checksum in order to check if it matches
# sha256sum xaa
# 1df0ff115d81b1263d75cbb31f1ecf60f5da4fffc843528f8667c14f2c84c814  xaa
#
# Show progress bar - change cat for function that uploads part
# pv x* | cat > gggg
#
# Abort
# aws --profile personal glacier abort-multipart-upload --account-id 250036610033 --vault-name PicsTest --upload-id UnV9Dr0m1vR1Lg64urYnvw6cmCF0X8MmO5O4MRYB7S7Ine9y90Y70NbHrAa5UclsM__4TOSdKbhZoyKr1bSSKmInGNNd


appendComma="0"

echo -n '[' > tmp
for i in $( find $PWD -type f -exec ./mapper.sh {} \; ); do

    if [ "$appendComma" -eq "1" ]
    then
        echo -n , >> tmp
    fi

    echo -n {$i} >> tmp
    appendComma="1"
done
echo -n ']' >> tmp


Status of mapping

cat tmp | jsonpp | jq 'group_by(.d)[] '

cat tmp | jsonpp | jq 'group_by(.d)[][]  | {(.d) : {(.m):(.n)}}  '

cat tmp | jsonpp | jq 'group_by(.d)[][] as $groupedByDir | {($groupedByDir.d) : {($groupedByDir.m):($groupedByDir.n)}}  '

cat tmp | jsonpp | jq 'group_by(.d)[] as $groupedByDir | {($groupedByDir[].d) : {($groupedByDir[].m):($groupedByDir[].n)}}  '

cat tmp | jsonpp | jq 'group_by(.d)[] as $groupedByDir | map($groupedByDir[].d) | unique as $uniqueKeys | $uniqueKeys[]   '




THIS IS IT !!!!

cat tmp | jsonpp | jq 'def r(a): reduce a[] as $item ({}; . + $item); def x(a): {(a): r(map({(.m):(.n)}))}; group_by(.d) | r(map(x(first.d)))'