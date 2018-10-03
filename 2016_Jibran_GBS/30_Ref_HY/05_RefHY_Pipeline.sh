## Variables
baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY
logDir=$baseDir/.log
genome=/workspace/2/CommonWorkspace/genome_analysis/plant/Actinidia/GBS/Hongyang2013_GBS/Hongyang_genome/HongYang.fa
cd $baseDir

##Step 1: FqToTagCount
#bsub -m aklppb34 -o $logDir/01.log -e $logDir/01.err -J RefHY01 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/ConfigFiles/01_KF3P5L_RefHY_20160819_FqToTagCount.xml
#Job <59251> is submitted to default queue <normal>.


##Step 2: Merge TagCount
#bsub -m aklppb34 -w 'done (59251)' -o $logDir/02.log -e $logDir/02.err -J RefHY02 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/ConfigFiles/02_KF3P5L_RefHY_20160819_MgTagCount.xml
#Job <59252> is submitted to default queue <normal>.

##Step 3: TagCount to Fastq
#bsub -m aklppb34 -w 'done (59252)' -o $logDir/03.log -e $logDir/03.err -J RefHY03 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/ConfigFiles/03_KF3P5L_RefHY_20160819_TagCnt2Fq.xml
#Job <59253> is submitted to default queue <normal>.

## Step 4: Map to ref genome
FASTQFILE=/workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/02_TagCounts/02_MergedTagCounts/KF3P5L_RefHY_20160819.fq
samFile=/workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/02_TagCounts/02_MergedTagCounts/KF3P5L_RefHY_20160819.sam

## Failed from here
#genomeBT=/workspace/2/CommonWorkspace/genome_analysis/plant/Actinidia/GBS/Hongyang2013_GBS/Hongyang_genome/HongYang
#bsub -w 'done (59253)' -o $logDir/04_bowtie.log -e $logDir/04_bowtie.err -J RefHY04BT -n 20 /software/bioinformatics/bowtie2-2.2.5/bowtie2 --very-sensitive --threads 20 -x $genome -U $FASTQFILE -S $samFile
#Job <59355> is submitted to default queue <normal>.

##Step 5: Sam Converter
#bsub -m aklppb34 -w 'done (59355)' -o $logDir/05.log -e $logDir/05.err -J RefHY05 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/ConfigFiles/04_KF3P5L_RefHY_20160819_SamConv.xml
#Job <59356> is submitted to default queue <normal>.


##Step 6: Seq To TBT (Tag-By-Taxa)
#bsub -m aklppb34 -o $logDir/06.log -e $logDir/06.err -J RefHY06 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/ConfigFiles/05_KF3P5L_RefHY_20160819_SeqToTBT_H5.xml
#Job <59357> is submitted to default queue <normal>.


##Step 7: Pivot/Modify TBT HD5
#cd $baseDir
#bsub -m aklppb34 -w 'done (59357)' -o $logDir/07.frmCmdLine.log -e $logDir/07.frmCmdLine.err -J RefHY07 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx50g -fork1 -ModifyTBTHDF5Plugin -o 05_TBT/01_IndividualTBT/KF3P5L_RefHY_TBT_20160819.h5 -p 05_TBT/03_PivotMergedTaxaTBT/KF3P5L_RefHY_mergeTBTHDF5_mergedtaxa_pivot_20160819.h5 -endPlugin -runfork1
#Job <59358> is submitted to default queue <normal>.


##Step 8a: Create CallSNPs shell scripts
## Step 8b: Call SNPs. THIS MAY TAKE A LONG TIME TO RUN.
#sh 08_callSNPs.sh >> 08_JobsSubmitted


## Step 9: MergeDuplicateSNPs. WAIT UNTIL ALL CALL_SNPs JOBS FINISHED!!
cd $baseDir
#bsub -m aklppb34 -o $logDir/09.log -e $logDir/09.err -J RefHY09 
#/software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeDuplicateSNPsPlugin -hmp 06_HapMap/01_UnfilteredSNPs/03_PivotMergedTaxaTBT.c+.hmp.txt -o 06_HapMap/02_MergeDupSNPs/KF3P5L_RefHY_RefHY_20160819_chr+.hmp.txt -misMat 0.01 -callHets -s 1 -e 30 -endPlugin -runfork1

### Replace 'Russell1' and 'Russell2' by 'Russell'
### Replace 'Hort16A1' and 'Hort16A2' by 'Hort16A'
#cd $baseDir/06_HapMap/02_MergeDupSNPs
#for file in `ls *.hmp.txt`
#do
#  perl -p -i -e 's/Hort16A1/Hort16A/g; s/Hort16A2/Hort16A/g; s/Russell1/Russell/g; s/Russell2/Russell/g;' $file
#done


## Step 10: Merge Identical taxa
#cd $baseDir 
#bsub -m aklppb34 -w 'done (???)' -o $logDir/10.log -e $logDir/09.err -J RefHY10 
#/software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeIdenticalTaxaPlugin -hmp 06_HapMap/02_MergeDupSNPs/KF3P5L_RefHY_RefHY_20160819_chr+.hmp.txt -o 06_HapMap/03_MergeTaxa/KF3P5L_RefHY_RefHY_20160819_MgTaxa_chr+.hmp.txt -sC 1 -eC 30 -endPlugin -runfork1


## Step 10.b: Rename
#cd $baseDir 
#mv FAKELOG_DELETEME.txt RefHY_Reads_By_Taxa.txt


## Step 11: Copy and rename samples
#cd /workspace/hrachd/Actinidia/2016_CAGRF12857/30_TASSEL_RefHY/06_HapMap
#cp 03_MergeTaxa/*.hmp.txt 04_Raw/
#cd 04_Raw
#for file in `ls *.hmp.txt`
#do
#   perl -p -i -e 's/\t(\S+?):\S+/\t$1/g' $file 
#done


## Step 12: Exclude Blank
#cd $baseDir/06_HapMap/04_Raw/
#for file in `ls *.hmp.txt`
#do
#  /software/bioinformatics/tassel-5.2.28/run_pipeline.pl -Xmx32g -fork1 -h $file -fork2 -excludeTaxa Blank -input1 -export $baseDir/06_HapMap/05_ExcludeBlank/$file
#done

## Step 13: SCov 0.7
cd $baseDir/06_HapMap
#/software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 05_ExcludeBlank/KF3P5L_RefHY_RefHY_20160819_MgTaxa_chr+.hmp.txt -o 06_SCov0.7/KF3P5L_RefHY_RefHY_chr+.Scov0.7.hmp.txt -mnSCov 0.7 -sC 1 -eC 30 -endPlugin -runfork1


## Step 14. SCov 1
#/software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 05_ExcludeBlank/KF3P5L_RefHY_RefHY_20160819_MgTaxa_chr+.hmp.txt -o 07_SCov1/KF3P5L_RefHY_RefHY_chr+.Scov1.hmp.txt -mnSCov 1 -sC 1 -eC 30 -endPlugin -runfork1

## Step 15: Overall summary
#resultDir=$baseDir/06_HapMap

#perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/05_ExcludeBlank > $baseDir/KF3P5L_RefHY.raw.summary.txt 2>$baseDir/KF3P5L_RefHY.raw.summaryByTaxa.txt

#perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/06_SCov0.7 > $baseDir/KF3P5L_RefHY.Scov0.7.summary.txt 2>$baseDir/KF3P5L_RefHY.Scov0.7.summaryByTaxa.txt

#perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/07_SCov1 > $baseDir/KF3P5L_RefHY.Scov1.summary.txt 2>$baseDir/KF3P5L_RefHY.Scov1.summaryByTaxa.txt


## STep 16. Merge SCov0.7 to one file
#cd $baseDir/06_HapMap/06_SCov0.7
#outFile=$baseDir/KF3P5L_RefHY.Scov0.7.AllChrs.hmp.txt
#head -n 1 KF3P5L_RefHY_RefHY_chr28.Scov0.7.hmp.txt > $outFile

#for file in `ls *.hmp.txt`
#do
#  tail -n +2 $file >> $outFile
#done


## Step 17: mv to /output
cd $baseDir
outDir=/output/genomic/plant/Actinidia/GBS_PS1_1.68.5/2016_CAGRF12857/30_TASSEL_RefHY
mkdir $outDir

mv KF3P5L_RefHY.* $outDir/
ln -s $outDir/* .

cd 06_HapMap/05_ExcludeBlank
mkdir $outDir/01_raw
mv *.txt $outDir/01_raw/
ln -s $outDir/01_raw/* .

cd $baseDir/06_HapMap/07_SCov1
mkdir $outDir/03_SCov1
mv *.txt $outDir/03_SCov1/
ln -s $outDir/03_SCov1/* .


