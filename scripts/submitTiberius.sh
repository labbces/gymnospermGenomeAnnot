#!/bin/bash

#SBATCH --job-name=GenomeSpliceScape_Tiberius_abinitio
#SBATCH --partition=long
#SBATCH --ntasks-per-node=2
#SBATCH --mem=400gb
####SBATCH --nodelist=n01
#SBATCH --error=GenomeSpliceScape_Tiberius_abinitio-%j.err
#SBATCH --output=GenomeSpliceScape_Tiberius_abinitio-%j.out
#SBATCH --gres=gpu:1

echo "Running on node: $SLURMD_NODENAME"

module load Utils/SRA_Toolkit/3.2.1 Dev/OpenJDK/25.0.2 Bio/SAMtools/1.23
source ~/AnnEVO/Tiberius_venv/bin/activate


NXF_SINGULARITY_CACHEDIR=/home/dmpachon/AnnEVO/Tiberius/singularity/
SINGULARITY_CACHEDIR=/home/dmpachon/AnnEVO/Tiberius/singularity
export NXF_SINGULARITY_CACHEDIR SINGULARITY_CACHEDIR

#GENOME=../GenomeSpliceScape_annotation/eval_annotations/GenomeFasta/GCA_023213395.1_ASM2321339v1_genomic.fasta
GENOME=../GenomeSpliceScape_annotation/eval_annotations/GenomeFasta/GCA_053640655.1_ASM5364065v1_genomic.fasta
#GFF3=GCA_023213395.1_ASM2321339v1_genomic.gff3
GFF3=GCA_053640655.1_ASM5364065v1_genomic.gff3
python ../Tiberius/tiberius.py --singularity --genome $GENOME --model_cfg angiosperms --out $GFF3 

squeue -j $SLURM_JOBID
