baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log


cd $baseDir/06_HapMap/04_Raw

for file in `ls *.hmp.txt`
do
  bsub -o $logDir/${file/hmp.txt/ExcludeBlank.log} -e $logDir/${file/hmp.txt/ExcludeBlank.err} -J $file /software/bioinformatics/tassel-5.2.28/run_pipeline.pl -Xmx32g -fork1 -h $file -fork2 -excludeTaxa Blank -input1 -export $baseDir/06_HapMap/05_ExcludeBlank/$file  
done

