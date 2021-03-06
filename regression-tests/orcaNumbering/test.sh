#!/bin/bash

MYTMPDIR=$(mktemp -d)
trap "rm -rf $MYTMPDIR" EXIT
export BLANT_DIR=. # Remember, this script is run from the *main* repo, not the directory it resides in, so blant is ./blant
for k in 3 4 5; do
    echo "Testing ODV output matches ORCA for k=${k}"
    $BLANT_DIR/blant -mo -k $k -s NBE -n 100000 $BLANT_DIR/regression-tests/orcaNumbering/$k.el | sort -n > $MYTMPDIR/$k.odv
done

python3 regression-tests/orcaNumbering/test.py $MYTMPDIR
if [[ $? -eq 0 ]]; then
    exit 0
else
    exit 1
fi
