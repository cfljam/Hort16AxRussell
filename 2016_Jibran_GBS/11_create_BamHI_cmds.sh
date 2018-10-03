cmdFile=`pwd`/12_BamHI.reads.sh

baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/02_Demultiplex
newBarcode=/input/genomic/plant/Actinidia/chinensis/GBS/2016_Mareike/BamHI.txt

echo "module load ea-utils/1.1.2-806" > $cmdFile
echo >> $cmdFile

for plateSubDir in P1L5 P1L6 P2L7 P2L8 P3L2
do
  inputDir=$baseDir/$plateSubDir
  workDir=$baseDir/03_BamHI/$plateSubDir
  mkdir -p $workDir/.log
  for Q in 0 10 20 30
  do
     subDir='Q'$Q
     logDir=$workDir/$subDir/.log
     mkdir -p $logDir
     echo '###'$plateSubDir' '$subDir >> $cmdFile
     echo "cd $workDir/$subDir" >> $cmdFile
     echo >> $cmdFile
     cd $inputDir/$subDir
     for fastQ in `ls *.fq`
     do
        prefix=`echo $fastQ | rev|cut -d"." -f2-|rev`
        echo "bsub -o $logDir/01.dex.log -e $logDir/01.dex.err -J $subDir fastq-multx -x -b -m 0 -q $Q -d 1 -B $newBarcode $inputDir/$subDir/$fastQ -o "$prefix'.%.fq' >> $cmdFile
        echo >> $cmdFile
     done
  done
done



