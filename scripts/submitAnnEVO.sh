#!/bin/bash
#SBATCH --job-name=annevo
#SBATCH --partition=long
#SBATCH --mem=500G
#SBATCH --error=annevo.err
#SBATCH --output=annevo.out
#SBATCH --cpus-per-task=45
#SBATCH --gres=gpu:1


set -eo pipefail
eval "$(mamba shell hook --shell bash)"

mamba activate ANNEVO_env
python3 ../ANNEVO/annotation.py -g /home/dmpachon/AnnEVO/GenomeSpliceScape_annotation/GCA_053640655.1_ASM5364065v1_genomic.fna -m /home/dmpachon/AnnEVO/ANNEVO/saved_model/ANNEVO_Magnoliopsida.pt -l Magnoliopsida -o /home/dmpachon/AnnEVO/GenomeSpliceScape_annotation/GCA_053640655.1_ASM5364065v1_genomic.gff3 --batch_size 32 -t 45 --show_log

