Background:
Towards New Kiwifruit Cultivars with Durable Psa Resistance is an Agmardt Project- Sue Gardiner David Chagne Luis Gea and Jibran Tahir.
John McCallum is leading the Psa marker work with the industry.

In the AGMARDT project, a diploid (Hort16AxRussell and a tetraploid (rml-022) Actinidia chinensis breeding population have been selected for the purpose of mapping and identifying the genes that control resistance or tolerance to Psa Biovar 3.

Introduction
The repository is for the genetic and phenotypic data associated with mapping Psa tolerance in Hort16A x Russell population - (Objective 1 of AgMARDT).

Total 236 F1s were genotyped. Approximately 200-220 individuals were phenotyepd in two bioassays and field.

Genoytyping was done by GBS- TASSEL 3 version on Red5 v 1.68.5 as a reference genome.
Information on the variant calling and SNPs generated is proivided in 2016_Jibran_GBS folder and the link is; 

Raw reads(trimmed)
http://storage.powerplant.pfr.co.nz/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857/ 

Vairantcalling
http://storage.powerplant.pfr.co.nz/output/genomic/plant/Actinidia/GBS_PS1_1.68.5/2016_CAGRF12857/

The indivduals were in 3 plates and done SE seq on 2 lanes/plate expcet P3; P1(96) over 2 lanes, P2(96) over 2 lanes and P3 single lane. The key file FOR PLATES is 	KF3.xlsx and uploaded;
http://storage.powerplant.pfr.co.nz/workspace/hrpjxt/SNPcallingHR/KF3.xlsx

BAM and SAM files were generated for each plate and lane seperately.
http://storage.powerplant.pfr.co.nz/workspace/hrpjxt/SNPcallingHR/
P1

P1-1.bam
P1-1.sam
P1-1.sorted.bam
P1-1.sorted.bam.bai
P1-2.bam
P1-2.sam
P1-2.sorted.bam
P1-2.sorted.bam.bai

P2
P2-1.bam
P2-1.sam
P2-1.sorted.bam
P2-1.sorted.bam.bai
P2-2.bam2
P2-2.sam24 
P2-2.sorted.bam20 
P2-2.sorted.bam.bai

P3
P3.bam
P3.sam
P3.sorted.bam
P3.sorted.bam.bai


Maps;
Maps made for each parent by using JoinMap5 with ~10,000 as input SNPs aproximately from each parent. Around 3000 SNP markers were sucessfully anchored in the linkage map.

Input genotypes files are;

Mapfile H16aPS1HY.xlsx
Russell Red5+HY.xlsx

Output Maps files are;

Hort16Arevised.map
Russellrevised.map

Files aboe are also placed in ;
http://storage.powerplant.pfr.co.nz/workspace/hrpjxt/Rqtl/Hort16A/
and
http://storage.powerplant.pfr.co.nz/workspace/hrpjxt/Rqtl/Russell/

Phenotypes (from bioassay and field) in map file order and IDs of genotypes from multiple codes(Tissue culture, Kea and Ebrida) are in 
IDs and phenotypes as in GBS.xlsx.

Multiple statistaical models were used to predict phenotypes including REML variance components analysis and Generalized linear mixed models. Details with Duncan, Luis and Jibran.

QTL mapping was done with multiple models including single QTL scan with EM algorithim, Haley-Knott method, Extension of non-parameteric, Kruskal-wallis/one-way anova and QTLs with epistatic interactions on both parents with representaitve phenotypes from data funnelled fromt the modelling above. QTL mapping was done using rQTL and MapQTL.

Input data for MapQTL is;

Phenotypeallmapqtlxlsx.txt 

Map files (output maps) and phase files are provided above.


QTL data for Hort16A and Russellw will be uploaded;




Results for Q
## May 2018

------------
