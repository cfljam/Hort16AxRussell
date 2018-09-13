##Demultiplexing based on Barcode
baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/02_Demultiplex

for subdir in P1L5 P1L6 P2L7 P2L8 P3L2
do
  echo $subdir
  inputDir=$baseDir/$subdir
  perl /home/hrachd/mytools/summarize_demultiplex.pl $inputDir
done



