#!/bin/bash
RULES_DIR=$1
find ${RULES_DIR:-sigma/rules}/ -type file -exec grep -H description {} \; |gsed 's/:/,/g' >input.csv 
./mediatable.pl
rm input.csv
