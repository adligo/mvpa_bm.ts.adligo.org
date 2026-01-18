#!/bin/bash
# Use GitBash to execute this script
# Not in use from Jenkins

ROOT_DIR=`pwd`
./buildSrc/everything.sh --verbose --ssl --root-dir $ROOT_DIR -d mvpa_group_deps.ts.adligo.org -g mvpa_group.ts.adligo.org