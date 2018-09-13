PLATE=3P5L
PREFIX=KF3
PROJECT=$PREFIX'_'$PLATE
BASEFOLDER=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
CONFIGDIR=$BASEFOLDER/ConfigFiles
logDir=$BASEFOLDER/.log
KEYFILE=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857/KF3_KeaPlantID.txt
genome=/workspace/2/CommonWorkspace/genome_analysis/plant/Actinidia/GBS/2016_PS1/PS1.1.68/PS1_1.68.5.clean.fa
CMDDIR=`pwd`
PIPELINE=$CMDDIR/'05_'$PREFIX'_Pipeline.sh'
SERVER=aklppb34

echo '## Variables' > $PIPELINE
echo "baseDir=$BASEFOLDER" >> $PIPELINE
echo 'logDir=$baseDir/.log' >> $PIPELINE
echo "genome=$genome" >> $PIPELINE
echo 'cd $baseDir' >> $PIPELINE
echo >> $PIPELINE


######## TASSEL Options
ENZYME="BamHI"
MINCOUNT="3" # Minimum number tag count for tag to be included in the cnt file
MAXGOODREADS="800000000"

### Date
DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD

cd $CONFIGDIR

########
#	FastqToTagCount: Generate the XML Files to run this process
########
INPUTFOLDER="$BASEFOLDER/01_RawSequence/"
OUTPUTFOLDER="$BASEFOLDER/02_TagCounts/01_IndividualTagCounts"
Fq2TagCountFile="$CONFIGDIR"/01_"$PROJECT"_"$DATE"_FqToTagCount.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $Fq2TagCountFile
  echo ' <TasselPipeline>' >> $Fq2TagCountFile
  echo '    <fork1>' >> $Fq2TagCountFile
  echo '        <FastqToTagCountPlugin>' >> $Fq2TagCountFile
  echo '            <i>'$INPUTFOLDER'</i>' >> $Fq2TagCountFile
  echo '            <o>'$OUTPUTFOLDER'</o>' >> $Fq2TagCountFile
  echo '            <k>'$KEYFILE'</k>' >> $Fq2TagCountFile
  echo '            <e>'$ENZYME'</e>' >> $Fq2TagCountFile
  echo '            <s>'$MAXGOODREADS'</s>' >> $Fq2TagCountFile
  echo '            <c>'$MINCOUNT'</c>' >> $Fq2TagCountFile
  echo '        </FastqToTagCountPlugin>' >> $Fq2TagCountFile
  echo '    </fork1>' >> $Fq2TagCountFile
  echo '    <runfork1/>' >> $Fq2TagCountFile
  echo '</TasselPipeline>' >> $Fq2TagCountFile


## step 1: FqToTagCount
echo "##Step 1: FqToTagCount" >> $PIPELINE
echo "bsub -m $SERVER -R 'rusage[mem=100000]' -o "'$logDir/01.log -e $logDir/01.err -J '$PREFIX'01 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile '$Fq2TagCountFile >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE


########
# MergeTagCount: Generate the XML Files to run this process
########
INPUTFOLDER="$BASEFOLDER/02_TagCounts/01_IndividualTagCounts" # Where the input sequence files reside
OUTPUTFOLDER="$BASEFOLDER/02_TagCounts/02_MergedTagCounts" # Where output of script should go
OUTPUTFILE=$PROJECT"_mergedtagcounts" # Base name of Output tag counts file.
MgTagCountFile="$CONFIGDIR"/02_"$PROJECT"_"$DATE"_MgTagCount.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $MgTagCountFile
  echo ' <TasselPipeline>' >> $MgTagCountFile
  echo '    <fork1>' >> $MgTagCountFile
  echo '        <MergeMultipleTagCountPlugin>' >> $MgTagCountFile
  echo '            <i>'$INPUTFOLDER'</i>' >> $MgTagCountFile
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_'$DATE'.cnt</o>' >> $MgTagCountFile
  echo '            <c>'$MINCOUNT'</c>' >> $MgTagCountFile
  echo '        </MergeMultipleTagCountPlugin>' >> $MgTagCountFile
  echo '    </fork1>' >> $MgTagCountFile
  echo '    <runfork1/>' >> $MgTagCountFile
  echo '</TasselPipeline>' >> $MgTagCountFile


## step 2: MgTagCount
echo "##Step 2: Merge TagCount" >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/02.log -e $logDir/02.err -J '$PREFIX'02 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile '$MgTagCountFile >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE


########
# TagCount2Fq: Generate the XML Files to run this process
########
INPUTFOLDER="$BASEFOLDER/02_TagCounts/02_MergedTagCounts" # Where the input sequence files reside
OUTPUTFOLDER="$BASEFOLDER/02_TagCounts/02_MergedTagCounts" # Where output of script should go
INPUTFILE=$PROJECT"_mergedtagcounts" # Base name of Input tag counts files. FIXME (outputfile from run_seqtotbthdf5.sh)
INPUTNAME=$INPUTFOLDER"/"$INPUTFILE"_"$DATE".cnt"
FASTQFILE=$OUTPUTFOLDER'/'$PROJECT'_'$DATE'.fq'
TagCnt2FqFile="$CONFIGDIR"/03_"$PROJECT"_"$DATE"_TagCnt2Fq.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $TagCnt2FqFile
  echo ' <TasselPipeline>' >> $TagCnt2FqFile
  echo '    <fork1>' >> $TagCnt2FqFile
  echo '        <TagCountToFastqPlugin>' >> $TagCnt2FqFile
  echo '            <i>'$INPUTNAME'</i>' >> $TagCnt2FqFile
  echo '            <o>'$FASTQFILE'</o>' >> $TagCnt2FqFile
  echo '            <c>'$MINCOUNT'</c>' >> $TagCnt2FqFile
  echo '        </TagCountToFastqPlugin>' >> $TagCnt2FqFile
  echo '    </fork1>' >> $TagCnt2FqFile
  echo '    <runfork1/>' >> $TagCnt2FqFile
  echo '</TasselPipeline>' >> $TagCnt2FqFile


## step 3: TagCnt2Fq
echo "##Step 3: TagCount to Fastq" >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/03.log -e $logDir/03.err -J '$PREFIX'03 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile '$TagCnt2FqFile >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE



######
# Step 4: Bowtie2 alignment
######
echo "## Step 4: Map to ref genome" >> $PIPELINE
echo "FASTQFILE=$FASTQFILE" >> $PIPELINE
samFile=${FASTQFILE/.fq/.sam}
echo "samFile=$samFile" >> $PIPELINE
echo "#bsub -w 'done (???)' -o "'$logDir/04.bowtie.log -e $logDir/04.bowtie.err -J '$PREFIX'04BT -n 20 /software/bioinformatics/bowtie2-2.2.5/bowtie2 --very-sensitive --threads 20 -x $genome -U $FASTQFILE -S $samFile' >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE




########
# SamConverter: Generate the XML Files to run this process
########
INPUTNAME="$BASEFOLDER"/02_TagCounts/02_MergedTagCounts/"$PROJECT"_"$DATE".sam
OUTPUTFOLDER="$BASEFOLDER/04_TOPM" # Where output of script should go
OUTFILE="$PROJECT"_"$DATE".topm
SamConvFile="$CONFIGDIR"/04_"$PROJECT"_"$DATE"_SamConv.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $SamConvFile
  echo ' <TasselPipeline>' >> $SamConvFile
  echo '    <fork1>' >> $SamConvFile
  echo '        <SAMConverterPlugin>' >> $SamConvFile
  echo '            <i>'$INPUTNAME'</i>' >> $SamConvFile
  echo '            <o>'$OUTPUTFOLDER'/'$OUTFILE'</o>' >> $SamConvFile
  echo '        </SAMConverterPlugin>' >> $SamConvFile
  echo '    </fork1>' >> $SamConvFile
  echo '    <runfork1/>' >> $SamConvFile
  echo '</TasselPipeline>' >> $SamConvFile


## step 5: Covert Sam
echo "##Step 5: Sam Converter" >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/05.log -e $logDir/05.err -J '$PREFIX'05 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile '$SamConvFile >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE



########
# SeqToTBTHDF5: Generate the XML Files for the Node to run this process
########
INPUTFOLDER="$BASEFOLDER/01_RawSequence" # Where the input sequence files reside
OUTPUTFOLDER="$BASEFOLDER/05_TBT/01_IndividualTBT" # Where output of script should go
OUTPUTFILE="$PROJECT"_TBT # Base name of Output HDF5 file.
TAGCOUNTFILE="$BASEFOLDER"/02_TagCounts/02_MergedTagCounts/"$PROJECT"_mergedtagcounts_"$DATE".cnt
UPPERBOUND="200000000"
tbtConfigFile="$CONFIGDIR"/05_"$PROJECT"_"$DATE"_SeqToTBT_H5.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $tbtConfigFile
  echo ' <TasselPipeline>' >> $tbtConfigFile
  echo '    <fork1>' >> $tbtConfigFile
  echo '        <SeqToTBTHDF5Plugin>' >> $tbtConfigFile
  echo '            <i>'$INPUTFOLDER'/</i>' >> $tbtConfigFile
  echo '            <k>'$KEYFILE'</k>' >> $tbtConfigFile
  echo '            <e>'$ENZYME'</e>' >> $tbtConfigFile
  echo '            <o>'$OUTPUTFOLDER'/'$OUTPUTFILE'_'$DATE'.h5</o>' >> $tbtConfigFile
  echo '            <s>'$UPPERBOUND'</s>' >> $tbtConfigFile
  echo '            <L>FAKELOG_DELETEME.txt</L>' >> $tbtConfigFile
  echo '            <t>'$TAGCOUNTFILE'</t>' >> $tbtConfigFile
  echo '        </SeqToTBTHDF5Plugin>' >> $tbtConfigFile
  echo '    </fork1>' >> $tbtConfigFile
  echo '    <runfork1/>' >> $tbtConfigFile
  echo '</TasselPipeline>' >> $tbtConfigFile



## step 6: SeqToTBT
echo "##Step 6: Seq To TBT (Tag-By-Taxa)" >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/06.log -e $logDir/06.err -J '$PREFIX'06 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx100g -configFile '$tbtConfigFile >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE



########
# Pivot: Generate the XML Files for each node to run this process
########
INPUTFOLDER="$BASEFOLDER/05_TBT/01_IndividualTBT"
INPUTNAME=$INPUTFOLDER"/"$PROJECT"_TBT_"$DATE".h5"
OUTPUTFOLDER="$BASEFOLDER/05_TBT/03_PivotMergedTaxaTBT"
OUTPUTFILE=$PROJECT"_mergeTBTHDF5_mergedtaxa_pivot_"$DATE".h5"   ### Shall we remove 'mergeTBTHDF5_mergedtaxa_' to shortern filename??
H5FILE=$OUTPUTFILE

pivotConfigFile="$CONFIGDIR"/05_"$PROJECT"_"$DATE"_Pivot.xml

  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $pivotConfigFile
  echo ' <TasselPipeline>' >> $pivotConfigFile
  echo '    <fork1>' >> $pivotConfigFile
  echo '        <ModifyTBTHDF5Plugin>' >> $pivotConfigFile
  echo '            <o>'$INPUTNAME'</o>' >> $pivotConfigFile
  echo '            <p>'$OUTPUTFOLDER'/'$OUTPUTFILE'</p>' >> $pivotConfigFile
#  echo '            <c></c>' >> $pivotConfigFile
  echo '            <L>FAKELOG_DELETEME.txt</L>' >> $pivotConfigFile
  echo '        </ModifyTBTHDF5Plugin>' >> $pivotConfigFile
  echo '    </fork1>' >> $pivotConfigFile
  echo '    <runfork1/>' >> $pivotConfigFile
  echo '</TasselPipeline>' >> $pivotConfigFile


#### Step 7: ModifyTBTHDF5Plugin
echo "##Step 7: Pivot/Modify TBT HD5" >> $PIPELINE
echo '#cd $baseDir' >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/07.frmCmdLine.log -e $logDir/07.frmCmdLine.err -J '$PREFIX'07 /software/bioinformatics/tassel-5.0/run_pipeline.pl -Xmx50g -fork1 -ModifyTBTHDF5Plugin -o 05_TBT/01_IndividualTBT/'$PROJECT'_TBT_'$DATE'.h5 -p 05_TBT/03_PivotMergedTaxaTBT/'$OUTPUTFILE' -endPlugin -runfork1' >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE



########
# TagsToSNPs: Generate the XML Files for each chromosome to run this process
########
STARTCHRM="1" # Chromosome to start with
ENDCHRM="30" # Chromosome to end with
MNF="-2.0" # Minimum value of F (inbreeding coeffficient). Default: -2.0, no filter
MNMAF="0.001" # Minimum minor allele frequency. Defaults to 0.01 SNPS that pass either the specified mnMAF or mnMAC (see next) will be output.
MNMAC="3" # Minimum minor allele count. Defaults to 10. SNPS that pass either the specified mnMAF or mnMAC (see previous) will be output.
MNLCOV="0.1" # Minimum locus coverage, the proportion of taxa with at least 1 tag at a locus. Default 0.1
INCLRARE="" # not implemented in this script -- placeholder
INCLGAPS="" # not implemented in this script -- placeholder
MAXSITES=8000000 # Maximum number of sites (SNPs) output per chromosome
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program

INPUTFOLDER="$BASEFOLDER/05_TBT/03_PivotMergedTaxaTBT"
INPUTNAME=$INPUTFOLDER"/"$H5FILE

TOPM="$BASEFOLDER/04_TOPM/"$PROJECT"_"$DATE".topm"
OUTPUTFOLDER="$BASEFOLDER/06_HapMap/01_UnfilteredSNPs" # Where output of script should go

tag2snpConfDir=$CONFIGDIR/06_"$PROJECT"_"$DATE"
`mkdir $tag2snpConfDir`

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  configFile=$tag2snpConfDir/$PROJECT"_chr"$CHRM".xml"
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $configFile
  echo '<TasselPipeline>' >> $configFile
  echo '    <fork1>' >> $configFile
  echo '        <TagsToSNPByAlignmentPlugin>' >> $configFile
  echo '            <i>'$INPUTNAME'</i>' >> $configFile
  echo '            <o>'$OUTPUTFOLDER'</o>' >> $configFile
  echo '            <m>'$TOPM'</m>' >> $configFile
 # echo '            <mnF>'$MNF'</mnF>' >> $configFile
  echo '            <mnMAF>'$MNMAF'</mnMAF>' >> $configFile
  echo '            <mnMAC>'$MNMAC'</mnMAC>' >> $configFile
  echo '            <mnLCov>'$MNLCOV'</mnLCov>' >> $configFile
  echo '            <mxSites>'$MAXSITES'</mxSites>' >> $configFile
  echo '            <s>'$CHRM'</s>' >> $configFile
  echo '            <e>'$CHRM'</e>' >> $configFile
 # echo '            <p>'$PEDIGREE_FILE'</p>' >> $configFile
  echo '        </TagsToSNPByAlignmentPlugin>' >> $configFile
  echo '    </fork1>' >> $configFile
  echo '    <runfork1/>' >> $configFile
  echo '</TasselPipeline>' >> $configFile
  CHRM=$((CHRM+1))
done


#### Create submit commands
Step8cmds=$CMDDIR/08_callSNPs.sh
cd $tag2snpConfDir
echo "##Step 8a: Create CallSNPs shell scripts" >> $PIPELINE
echo "cd $tag2snpConfDir" > $Step8cmds
echo "logDir=$logDir" >> $Step8cmds
echo >> $Step8cmds

for file in `ls *.xml`
do
#   #  echo $file
   logF='08_'$file'.log'
   errF='08_'$file'.err'
   echo "bsub -w 'done (???)' -R 'rusage[mem=50000]' -o "'$logDir/'$logF' -e $logDir/'$errF" -J $file /software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -configFile $file" >> $Step8cmds
   echo >> $Step8cmds
done


echo "## Step 8b: Call SNPs. THIS MAY TAKE A LONG TIME TO RUN." >> $PIPELINE
echo "#sh 08_callSNPs.sh >> 08_JobsSubmitted" >> $PIPELINE
echo >> $PIPELINE



#### Step 9: MergeDuplicateSNPs: WAIT UNTIL ALL CALL_SNPs JOBS FINISHED!!
echo "## Step 9: MergeDuplicateSNPs. WAIT UNTIL ALL CALL_SNPs JOBS FINISHED!!" >> $PIPELINE
echo '#cd $baseDir' >> $PIPELINE
echo "#bsub -m $SERVER -o "'$logDir/09.log -e $logDir/09.err -J '$PREFIX'09 /software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeDuplicateSNPsPlugin -hmp 06_HapMap/01_UnfilteredSNPs/03_PivotMergedTaxaTBT.c+.hmp.txt -o 06_HapMap/02_MergeDupSNPs/'$PROJECT'_'$PREFIX'_'$DATE'_chr+.hmp.txt.gz -misMat 0.01 -callHets -s 1 -e 30 -endPlugin -runfork1' >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE



## Step 10: Merge Identical taxa. WAIT UNTIL THE ABOVE MergeDuplicateSNPs JOB FINISH
echo "## Step 10: Merge Identical taxa" >> $PIPELINE
echo "#cd $baseDir" >> $PIPELINE
echo "#bsub -m $SERVER -w 'done (???)' -o "'$logDir/10.log -e $logDir/09.err -J '$PREFIX'10 /software/bioinformatics/tassel-3.0/run_pipeline.pl -Xmx50g -fork1 -MergeIdenticalTaxaPlugin -hmp 06_HapMap/02_MergeDupSNPs/'$PROJECT'_'$PREFIX'_'$DATE'_chr+.hmp.txt.gz -o 06_HapMap/03_MergeTaxa/'$PROJECT'_'$PREFIX'_'$DATE'_MgTaxa_chr+.hmp.txt -sC 1 -eC 30 -endPlugin -runfork1'  >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE


## Step 10.b: Rename
echo  "## Step 10.b: Rename"  >> $PIPELINE
echo "#cd $baseDir" >> $PIPELINE 
echo "#mv FAKELOG_DELETEME.txt "$PREFIX'_Reads_By_Taxa.txt' >> $PIPELINE
echo >> $PIPELINE
echo >> $PIPELINE


## Step 11: Copy and Rename Samples
echo "## Step 11: Copy and rename samples" >> $PIPELINE
echo >> $PIPELINE



## Step 12: Overall summary of SNP sites detected on chrs
echo "## Step 12: Overall summary" >> $PIPELINE
echo >> $PIPELINE



## Step 13: Separate samples by Family
echo "## Step 13: Separate samples by family" >> $PIPELINE
echo >> $PIPELINE


## Step 14: Filter SCov0.7
echo "## Step 14: For each family, do SCvo0.7" >> $PIPELINE
echo >> $PIPELINE


## Step 15: Summary by family
echo "## Step 15: For each family, summarize count of SNP sites on each scaffold (Raw and SCov0.7)" >> $PIPELINE
echo >> $PIPELINE






##################### IGNORE ###################
########
# MergeDuplicateSNPs: Generate the XML Files for each chromosome to run this process
########
STARTCHRM="1" # Chromosome to start with
ENDCHRM="30" # Chromosome to end with
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program

INPUTFOLDER="$BASEFOLDER/06_HapMap/01_UnfilteredSNPs"
INPUTBASENAME="03_PivotMergedTaxaTBT.c" # Base name of input files. This precedes $CHRM.hmp.txt.gz

OUTPUTFOLDER="$BASEFOLDER/06_HapMap/02_MergeDupSNPs"

mrgSNPsConfDir=$CONFIGDIR/06_"$PROJECT"_"$DATE"_MergeSNP
`mkdir $mrgSNPsConfDir`

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))

MISMAT="0.01" # Minimum Minor Allele Frequency
CALLHETS="" # Hard coded on (call hets as opposed to set to missing)
KPUNMERGEDUPS="" # Not implemented in this script -- placeholder


while [ $CHRM -lt $CHRME ]; do
  configFile=$mrgSNPsConfDir/$PROJECT"_Mgr_chr"$CHRM".xml"
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > $configFile
  echo '<TasselPipeline>' >> $configFile
  echo '    <fork1>' >> $configFile
  echo '        <MergeDuplicateSNPsPlugin>' >> $configFile
  echo '            <hmp>'$INPUTFOLDER'/'$INPUTBASENAME''$CHRM'.hmp.txt</hmp>' >> $configFile
  echo '            <o>'$OUTPUTFOLDER'/'$PROJECT'_'$DATE'_chr'$CHRM'.hmp.txt.gz</o>' >> $configFile
  echo '            <misMat>'$MISMAT'</misMat>' >> $configFile
  echo '            <callHets/>' >> $configFile
  echo '            <s>'$CHRM'</s>' >> $configFile
  echo '            <e>'$CHRM'</e>' >> $configFile
#  echo '            <p>'$PEDIGREE_FILE'</p>' >> $configFile
  echo '        </MergeDuplicateSNPsPlugin>' >> $configFile
  echo '    </fork1>' >> $configFile
  echo '    <runfork1/>' >> $configFile
  echo '</TasselPipeline>' >> $configFile
  CHRM=$((CHRM+1))
done





