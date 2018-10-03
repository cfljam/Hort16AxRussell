## Variables
baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log
genome=/workspace/2/CommonWorkspace/genome_analysis/plant/Actinidia/GBS/2016_PS1/PS1.1.68/PS1_1.68.5.clean.fa
cd $baseDir

##Step 1: FqToTagCount
#bsub -m aklppb34 -R 'rusage[mem=100000]' -o $logDir/01.log -e $logDir/01.err -J KF301 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/01_KF3_3P5L_20160802_FqToTagCount.xml
### all cores on aklppb34 is being used 

bsub -R 'rusage[mem=100000]' -o $logDir/01.log -e $logDir/01.err -J KF301 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/01_KF3_3P5L_20160802_FqToTagCount.xml
Job <48371> is submitted to default queue <normal>.


##Step 2: Merge TagCount
bsub -w 'done (48371)' -o $logDir/02.log -e $logDir/02.err -J KF302 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/02_KF3_3P5L_20160802_MgTagCount.xml
Job <48372> is submitted to default queue <normal>.


##Step 3: TagCount to Fastq
bsub -w 'done (48372)' -o $logDir/03.log -e $logDir/03.err -J KF303 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/03_KF3_3P5L_20160802_TagCnt2Fq.xml
Job <48374> is submitted to default queue <normal>.


## Step 4: Map to ref genome
FASTQFILE=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/02_TagCounts/02_MergedTagCounts/KF3_3P5L_20160802.fq
samFile=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/02_TagCounts/02_MergedTagCounts/KF3_3P5L_20160802.sam
bsub -w 'done (48374)' -o $logDir/04.bowtie.log -e $logDir/04.bowtie.err -J KF304BT -n 20 /software/bioinformatics/bowtie2-2.2.5/bowtie2 --very-sensitive --threads 20 -x $genome -U $FASTQFILE -S $samFile
Job <48375> is submitted to default queue <normal>.

##Step 5: Sam Converter
bsub -w 'done (48375)' -o $logDir/05.log -e $logDir/05.err -J KF305 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/04_KF3_3P5L_20160802_SamConv.xml
Job <48376> is submitted to default queue <normal>.

##Step 6: Seq To TBT (Tag-By-Taxa)
bsub -w 'done (48376)' -o $logDir/06.log -e $logDir/06.err -J KF306 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/ConfigFiles/05_KF3_3P5L_20160802_SeqToTBT_H5.xml
Job <48377> is submitted to default queue <normal>.


##Step 7: Pivot/Modify TBT HD5
cd $baseDir
bsub -w 'done (48377)' -o $logDir/07.frmCmdLine.log -e $logDir/07.frmCmdLine.err -J KF307 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx50g -fork1 -ModifyTBTHDF5Plugin -o 05_TBT/01_IndividualTBT/KF3_3P5L_TBT_20160802.h5 -p 05_TBT/03_PivotMergedTaxaTBT/KF3_3P5L_mergeTBTHDF5_mergedtaxa_pivot_20160802.h5 -endPlugin -runfork1

Job <48378> is submitted to default queue <normal>.


##Step 8a: Create CallSNPs shell scripts
## Step 8b: Call SNPs. THIS MAY TAKE A LONG TIME TO RUN.
sh 08_callSNPs.sh >> 08_JobsSubmitted



## Step 9: MergeDuplicateSNPs. WAIT UNTIL ALL CALL_SNPs JOBS FINISHED!!
cd $baseDir
bsub -o $logDir/09.log -e $logDir/09.err -J KF309 /software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeDuplicateSNPsPlugin -hmp 06_HapMap/01_UnfilteredSNPs/03_PivotMergedTaxaTBT.c+.hmp.txt -o 06_HapMap/02_MergeDupSNPs/KF3_3P5L_KF3_20160802_chr+.hmp.txt -misMat 0.01 -callHets -s 1 -e 30 -endPlugin -runfork1
Job <48463> is submitted to default queue <normal>.


## Step 10: Merge Identical taxa
cd $baseDir
## There are Hort16A1 and Hort16A2: Use Hort16A instead
## There are Russell1 and Russell2: Use Russell instead
##   perl -p -i -e 's/Hort16A1/Hort16A/g; s/Hort16A2/Hort16A/g; s/Russell1/Russell/g; s/Russell2/Russell/g;' $file


bsub -o $logDir/10.log -e $logDir/09.err -J KF310 /software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeIdenticalTaxaPlugin -hmp 06_HapMap/03_tmp/KF3_3P5L_KF3_20160802_chr+.hmp.txt -o 06_HapMap/03_MergeTaxa/KF3_3P5L_KF3_20160802_MgTaxa_chr+.hmp.txt -sC 1 -eC 30 -endPlugin -runfork1
Job <48465> is submitted to default queue <normal>.


## Filter by SCov0.7 and SCov 1 (or: sh filter.sh)
cd  $baseDir
bsub -o $logDir/12.Scov0.7.log -e $logDir/12.Scov0.7.err -J KF312 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_HapMap/05_ExcludeBlank/KF3_3P5L_KF3_20160802_MgTaxa_chr+.hmp.txt -o 06_HapMap/06_SCov0.7/KF3P5L_PS1.68.5_chr+.Scov0.7.hmp.txt -mnSCov 0.7 -sC 1 -eC 30 -endPlugin -runfork1

bsub -o $logDir/13.Scov1.log -e $logDir/13.Scov1.err -J KF313 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_HapMap/05_ExcludeBlank/KF3_3P5L_KF3_20160802_MgTaxa_chr+.hmp.txt -o 06_HapMap/07_SCov1/KF3P5L_PS1.68.5_chr+.Scov1.hmp.txt -mnSCov 1 -sC 1 -eC 30 -endPlugin -runfork1

Job <48670> is submitted to default queue <normal>.
Job <48671> is submitted to default queue <normal>.

