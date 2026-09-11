#!/usr/bin/env bash
set -euo pipefail

MIN_OVERLAP=0.90
OVERLAP_LABEL="${MIN_OVERLAP#0.}pct"

run_comparison() {
    local GENE_PREDICTION="$1"
    local BED_PREDICTION="$2"
    local PROTEIN_MAPPING="$3"
    local BED_MAPPING="$4"
    local LABEL="$5"
    local OUT_COMP="protein_gene_overlaps_${OVERLAP_LABEL}_${LABEL}.bed"

    # Reference-protein mappings:
    # BED columns: chr, start, end, reference_protein_ID, score, strand, miniprot_ID
    if [[ ! -s "$BED_MAPPING" ]]; then
        awk 'BEGIN {FS=OFS="\t"}
        $3 == "mRNA" {
            match($9, /ID=([^;]+)/, id)
            match($9, /Target=([^ ;]+)/, target)

            if (id[1] != "" && target[1] != "")
                print $1, $4-1, $5, target[1], ".", $7, id[1]
        }' "$PROTEIN_MAPPING" > "$BED_MAPPING"
    else
        echo "Using existing mapping BED: $BED_MAPPING"
    fi

    # Predicted genes
    if [[ ! -s "$BED_PREDICTION" ]]; then
        awk 'BEGIN {FS=OFS="\t"}
        $3 == "gene" {
            match($9, /ID=([^;]+)/, id)

            if (id[1] != "")
                print $1, $4-1, $5, id[1], ".", $7
        }' "$GENE_PREDICTION" > "$BED_PREDICTION"
    else
        echo "Using existing prediction BED: $BED_PREDICTION"
    fi
    awk 'BEGIN {FS=OFS="\t"}
    $3 == "gene" {
        match($9, /ID=([^;]+)/, id)

        if (id[1] != "")
            print $1, $4-1, $5, id[1], ".", $7
    }' "$GENE_PREDICTION" > "$BED_PREDICTION"

    # A conserved protein is counted if at least MIN_OVERLAP of its mapping
    # overlaps a predicted gene on the same strand.
    bedtools intersect \
        -a "$BED_MAPPING" \
        -b "$BED_PREDICTION" \
        -s -f "$MIN_OVERLAP" -wa -wb \
        > "$OUT_COMP"

    N_CONSERVED=$(cut -f4 "$OUT_COMP" | sort -u | wc -l)

    # A predicted gene is counted if at least MIN_OVERLAP of its length
    # overlaps a mapped conserved reference protein on the same strand.
    local OUT_REVERSE="gene_protein_overlaps_${OVERLAP_LABEL}_${LABEL}.bed"

    bedtools intersect \
        -a "$BED_PREDICTION" \
        -b "$BED_MAPPING" \
        -s -f "$MIN_OVERLAP" -wa -wb \
        > "$OUT_REVERSE"

    N_PREDICTED_SUPPORTED=$(cut -f4 "$OUT_REVERSE" | sort -u | wc -l)

    echo "Output (reference proteins represented): $OUT_COMP"
    echo "Conserved reference proteins represented: $N_CONSERVED"
    echo "Output (predicted genes supported): $OUT_REVERSE"
    echo "Predicted genes supported by reference proteins: $N_PREDICTED_SUPPORTED"

}

run_comparison \
    "annotations_qc/ANNEVO/GCA_023213395.1_ASM2321339v1_genomic/cleanGFF/GCA_023213395.1_ASM2321339v1_genomic.AGAT.clean.gff3" \
    "annotations_qc/ANNEVO/GCA_023213395.1_ASM2321339v1_genomic/cleanGFF/GCA_023213395.1_ASM2321339v1_genomic.AGAT.clean.bed" \
    "GCA_023213395.1_ASM2321339v1_genomic.Acrogymnospermae-consensus.gff3" \
    "GCA_023213395.1_ASM2321339v1_genomic.Acrogymnospermae-consensus.bed" \
    "GCA_023213395.1_ASM2321339v1_genomic.ANNEVO"

run_comparison \
    "annotations_qc/TiberiusAbinitio/GCA_023213395.1_ASM2321339v1_genomic.TiberiusAbinitio/cleanGFF/GCA_023213395.1_ASM2321339v1_genomic.TiberiusAbinitio.AGAT.clean.gff3" \
    "annotations_qc/TiberiusAbinitio/GCA_023213395.1_ASM2321339v1_genomic.TiberiusAbinitio/cleanGFF/GCA_023213395.1_ASM2321339v1_genomic.TiberiusAbinitio.AGAT.clean.bed" \
    "GCA_023213395.1_ASM2321339v1_genomic.Acrogymnospermae-consensus.gff3" \
    "GCA_023213395.1_ASM2321339v1_genomic.Acrogymnospermae-consensus.bed" \
    "GCA_023213395.1_ASM2321339v1_genomic.Tiberius"

run_comparison \
    "annotations_qc/ANNEVO/GCA_053640655.1_ASM5364065v1_genomic/cleanGFF/GCA_053640655.1_ASM5364065v1_genomic.AGAT.clean.gff3" \
    "annotations_qc/ANNEVO/GCA_053640655.1_ASM5364065v1_genomic/cleanGFF/GCA_053640655.1_ASM5364065v1_genomic.AGAT.clean.bed" \
    "GCA_053640655.1_ASM5364065v1_genomic.Acrogymnospermae-consensus.gff3" \
    "GCA_053640655.1_ASM5364065v1_genomic.Acrogymnospermae-consensus.bed" \
    "GCA_053640655.1_ASM5364065v1_genomic.ANNEVO"

run_comparison \
    "annotations_qc/TiberiusAbinitio/GCA_053640655.1_ASM5364065v1_genomic.TiberiusAbinitio/cleanGFF/GCA_053640655.1_ASM5364065v1_genomic.TiberiusAbinitio.AGAT.clean.gff3" \
    "annotations_qc/TiberiusAbinitio/GCA_053640655.1_ASM5364065v1_genomic.TiberiusAbinitio/cleanGFF/GCA_053640655.1_ASM5364065v1_genomic.TiberiusAbinitio.AGAT.clean.bed" \
    "GCA_053640655.1_ASM5364065v1_genomic.Acrogymnospermae-consensus.gff3" \
    "GCA_053640655.1_ASM5364065v1_genomic.Acrogymnospermae-consensus.bed" \
    "GCA_053640655.1_ASM5364065v1_genomic.Tiberius"
