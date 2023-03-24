#!/bin/bash
set -e

time docker build -t ce-bpatg:4.2.2 .

time docker-compose run --rm ce-bpatg Rscript run_project.R
