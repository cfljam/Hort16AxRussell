baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857
workDir=$baseDir/20_TASSEL
mkdir $workDir

cd $workDir
mkdir 01_RawSequence 02_TagCounts
mkdir 02_TagCounts/01_IndividualTagCounts 02_TagCounts/02_MergedTagCounts
mkdir 04_TOPM
mkdir 05_TBT
mkdir 05_TBT/01_IndividualTBT 05_TBT/03_PivotMergedTaxaTBT
mkdir 06_HapMap
mkdir 06_HapMap/01_UnfilteredSNPs 06_HapMap/02_MergeDupSNPs 06_HapMap/03_MergeTaxa 06_HapMap/04_Raw #06_HapMap/05_SCov0.7 06_HapMap/06_SCov1
mkdir 06_HapMap/05_ExcludeBlank
mkdir 06_HapMap/06_SCov0.7 06_HapMap/07_SCov1

mkdir ConfigFiles
mkdir .log

cd $workDir/01_RawSequence

inputDir=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857
ln -s $inputDir/AGRF_CAGRF12857_C9NAEANXX/P3_HR_C9NAEANXX_NoIndex_L002_R1.fastq.gz C9NAEANXX_2_fastq.gz
ln -s $inputDir/AGRF_CAGRF12857_C9NREANXX/P1_HR_C9NREANXX_NoIndex_L005_R1.fastq.gz C9NREANXX_5_fastq.gz 
ln -s $inputDir/AGRF_CAGRF12857_C9NREANXX/P1_HR_C9NREANXX_NoIndex_L006_R1.fastq.gz C9NREANXX_6_fastq.gz
ln -s $inputDir/AGRF_CAGRF12857_C9NREANXX/P2_HR_C9NREANXX_NoIndex_L007_R1.fastq.gz C9NREANXX_7_fastq.gz
ln -s $inputDir/AGRF_CAGRF12857_C9NREANXX/P2_HR_C9NREANXX_NoIndex_L008_R1.fastq.gz C9NREANXX_8_fastq.gz


