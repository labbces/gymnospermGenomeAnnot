# Annotating gymnosperm genomes

We will include two gymnosperms in our [SpliceScape](https://github.com/labbces/SpliceScape) analyses: *Cycas panzhihuaensis* (GCA_023213395.1_ASM2321339v1) and *Pseudotaxus chienii* (GCA_053640655.1_ASM5364065v1). Both are chromosome-scale assemblies for which no gene annotation was available.

Gymnosperm genomes present particular challenges for *ab initio* gene prediction. The two assemblies analysed here exceed 10 Gb and represent monoploid genome representations, while their corresponding nuclear genomes are larger. Large genome size in gymnosperms is predominantly associated with the accumulation of repetitive DNA, and genes can contain very long introns. For example, the *Pinus taeda* genome includes some of the longest introns reported among sequenced plant genomes. These characteristics increase the genomic distance between exons and make gene-structure inference more difficult, particularly when prediction tools are trained with broad plant models or models derived from angiosperms rather than gymnosperms.[^1]

We tested ANNEVO v2.3.2[^2] with the Magnoliopsida model and Tiberius v2.0.7[^3] with the Angiosperms model, as neither currently provides a gymnosperm-specific model.

The resulting annotations were evaluated with Another GFF Analysis Toolkit (AGAT) v1.6.1, Compleasm v0.2.8 with the lineage set to `embryophyta_odb12`, and OMAmer v2.1.2 with taxID 1437180 (Acrogymnospermae).[^4] We also compared the complete sets of proteins deduced from the predicted annotations against clustered proteins in gymnotoa-db.[^5] In this comparison, a reference protein or predicted gene was considered supported when at least 90% of its genomic mapping interval overlapped a feature from the other set on the same strand.

Because a curated gymnosperm-specific BUSCO lineage set is not currently available in the BUSCO/OrthoDB dataset collection used by Compleasm, we used `embryophyta_odb12` as the closest broad plant lineage. This lineage is suitable for comparing annotations within each genome, but its absolute completeness values should be interpreted cautiously because the reference set spans a broad evolutionary range and is not tailored to gymnosperm gene content. A gymnosperm-specific BUSCO lineage dataset, `Gymnosperm_odb10`,[^6] is available and would be valuable for a lineage-specific assessment of annotation completeness. However, this dataset was not used here because it was not recognised by the installed version of Compleasm; this may reflect a version or dataset-compatibility issue.

To provide a gymnosperm-specific complementary evaluation, we used OMArk with the taxonomic identifier set to Acrogymnospermae (taxID 1437180), which includes both *C. panzhihuaensis* and *P. chienii*. OMArk therefore provides a lineage-appropriate assessment of the predicted proteomes and mitigates the limitation of evaluating these annotations exclusively with the broad `embryophyta_odb12` BUSCO dataset.

ANNEVO was selected for the annotation of *C. panzhihuaensis* and *P. chienii*. Although both predictors used angiosperm-trained models and should therefore be interpreted cautiously, ANNEVO produced substantially fewer and longer gene models, consistent with lower fragmentation. It recovered marginally more complete embryophyte BUSCOs in *C. panzhihuaensis* and more complete BUSCOs in *P. chienii*, while producing fewer missing BUSCOs in both genomes. For both species, ANNEVO also yielded a substantially higher proportion of proteins consistent with the Acrogymnospermae lineage according to OMArk.

Mapping of gymnotoa-db reference proteins showed broadly similar recovery between predictors. However, the much larger number of Tiberius gene models did not translate into a proportional increase in genes supported by reference proteins. This pattern is consistent with fragmentation and/or unsupported additional predictions in the Tiberius annotations. Therefore, ANNEVO provides the more conservative and better-supported annotation set for downstream SpliceScape analyses.

## Gene-prediction evaluation

| Gene finder | Metric | *Cycas panzhihuaensis* | *Pseudotaxus chienii* |
|---|---|---:|---:|
| — | Assembly version | GCA_023213395.1_ASM2321339v1 | GCA_053640655.1_ASM5364065v1 |
| ANNEVO | Gene number | 48,858 | 70,160 |
| ANNEVO | Mean gene length (bp) | 14,572 | 8,866 |
| ANNEVO | Median gene length (bp) | 5,491 | 2,046 |
| ANNEVO | Compleasm — Embryophyta | S: 22.66% (459); D: 6.76% (137); F: 45.06% (913); M: 25.52% (517); N: 2,026 | S: 36.62% (742); D: 8.05% (163); F: 37.61% (762); M: 17.72% (359); N: 2,026 |
| ANNEVO | OMArk — Acrogymnospermae | S: 2,087 (52.88%); D: 1,541 (39.04%); unexpected D: 1,493 (37.83%); expected D: 48 (1.22%); M: 319 (8.08%); N: 3,947 | S: 2,308 (58.47%); D: 1,455 (36.86%); unexpected D: 1,062 (26.91%); expected D: 393 (9.96%); M: 184 (4.66%); N: 3,947 |
| ANNEVO | OMArk — total consistent with lineage | 31,785 (65.06%) | 46,983 (66.97%) |
| ANNEVO | gymnotoa-db — protein-gene overlaps (≥90%) | 91,038 | 110,385 |
| ANNEVO | gymnotoa-db — gene-protein overlaps (≥90%) | 25,171 | 30,254 |
| Tiberius | Gene number | 115,465 | 235,377 |
| Tiberius | Mean gene length (bp) | 2,724 | 1,543 |
| Tiberius | Median gene length (bp) | 489 | 468 |
| Tiberius | Compleasm — Embryophyta | S: 22.21% (450); D: 6.76% (137); F: 38.70% (784); M: 32.33% (655); N: 2,026 | S: 32.53% (659); D: 6.76% (137); F: 33.12% (671); M: 27.59% (559); N: 2,026 |
| Tiberius | OMArk — Acrogymnospermae | S: 2,167 (54.90%); D: 1,392 (35.27%); unexpected D: 1,347 (34.13%); expected D: 45 (1.14%); M: 388 (9.83%); N: 3,947 | S: 2,318 (58.73%); D: 1,391 (35.24%); unexpected D: 1,027 (26.02%); expected D: 364 (9.22%); M: 238 (6.03%); N: 3,947 |
| Tiberius | OMArk — total consistent with lineage | 45,436 (39.35%) | 83,866 (35.63%) |
| Tiberius | gymnotoa-db — protein-gene overlaps (≥90%) | 94,248 | 108,300 |
| Tiberius | gymnotoa-db — gene-protein overlaps (≥90%) | 25,121 | 32,802 |


[^1]: https://link.springer.com/article/10.1186/gb-2014-15-3-r59
[^2]: https://www.nature.com/articles/s41592-026-03036-7
[^3]: https://www.biorxiv.org/content/10.64898/2026.04.24.720536v2
[^4]: https://academic.oup.com/bioinformatics/article/37/18/2866/6206361
[^5]: https://academic.oup.com/database/article/doi/10.1093/database/baaf019/8058815
[^6]: https://academic.oup.com/hr/article/10/9/uhad165/7244670
