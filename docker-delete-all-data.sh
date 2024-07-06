#!/bin/bash
set -e

time docker build -t ce-bpatg:4.4.0 .

time docker-compose run --rm ce-bpatg Rscript delete-all-data.R
