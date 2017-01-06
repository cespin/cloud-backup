#!/usr/bin/env bash

echo \"d\":\"$(dirname $1)\",\"n\":\"$(basename $1)\",\"m\":\"$(md5 -q $1)\"
