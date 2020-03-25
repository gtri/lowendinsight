#!/bin/bash
#SBATCH --job-name=lowendinsight
#SBATCH -c 24

module load elixir
module load git
cd /home/cplummer8/lowendinsight
mix lei.bulk_analyze test/scan_list_large
