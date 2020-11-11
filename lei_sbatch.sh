#!/bin/bash
#SBATCH --job-name=lei
#SBATCH -c 16
#SBATCH -t 0-08:00


module load elixir
module load git
cd /home/cplummer8/lowendinsight
MIX_ENV=dev mix lei.bulk_analyze test/scan_list_large
