baseInputDir=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857

baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/02_Demultiplex

#P2 L7
prefix=P2L7
fastQ=$baseInputDir/AGRF_CAGRF12857_C9NREANXX/P2_HR_C9NREANXX_NoIndex_L007_R1.fastq.gz
workDir=$baseDir/$prefix
mkdir -p $workDir

newBarcode=$baseInputDir/P2.key.txt

module load ea-utils/1.1.2-806

for Q in 0 10 20 30
do
  subDir='Q'$Q
  logDir=$workDir/$subDir/.log
  mkdir -p $logDir
  cd $workDir/$subDir
  bsub -o $logDir/01.dex.log -e $logDir/01.dex.err -J $prefix$subDir -m wkoppb33 /software/bioinformatics/ea-utils.1.1.2-806/bin/fastq-multx -b -m 0 -q $Q -d 1 -B $newBarcode $fastQ -o R1.%.fq
done




