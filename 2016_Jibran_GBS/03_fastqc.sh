baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857
mkdir -p $baseDir
cd $baseDir

fastqc=01_fastqc
mkdir $fastqc

logDir=$fastqc/.log
mkdir $logDir

inputDir1=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857/AGRF_CAGRF12857_C9NREANXX
bsub -n 6 -o $logDir/01_P1P2.log -e $logDir/01_P1P2.err -J P1P2 /software/bioinformatics/FastQC-0.11.2/fastqc -t 6 -o $fastqc $inputDir1/*.gz

inputDir2=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857/AGRF_CAGRF12857_C9NAEANXX
bsub -n 6 -o $logDir/01_P3.log -e $logDir/01_P3.err -J P3 /software/bioinformatics/FastQC-0.11.2/fastqc -t 6 -o $fastqc $inputDir2/P3_HR_C9NAEANXX_NoIndex_L002_R1.fastq.gz

Job <34770> is submitted to default queue <normal>.
Job <34771> is submitted to default queue <normal>.


