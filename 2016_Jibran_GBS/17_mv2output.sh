baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857
outDir=/output/genomic/plant/Actinidia/GBS_PS1_1.68.5/2016_CAGRF12857

cd $baseDir/01_fastqc
mkdir -p $outDir/01_fastqc
mv *.html $outDir/01_fastqc/
ln -s $outDir/01_fastqc/* .

oldName=MiseqTestRun.stats.txt
mkdir $outDir/02_Demultiplex

for subdir in P1L5 P1L6 P2L7 P2L8 P3L2
do
  cd $baseDir/02_Demultiplex/$subdir
  newName=$subdir'.Demultiplex.ReadCount.txt'
  mv $oldName $outDir/02_Demultiplex/$newName
  ln -s $outDir/02_Demultiplex/$newName $oldName
done




