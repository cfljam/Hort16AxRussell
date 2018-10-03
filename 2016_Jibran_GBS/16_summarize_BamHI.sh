### Reads with barcode followed by Enzyme BamHI
baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/03_BamHI

for subdir in P1L5 P1L6 P2L7 P2L8 P3L2
do
  echo $subdir
  inputDir=$baseDir/$subdir
  perl /home/hrachd/mytools/summarize_WithEnzyme.pl $inputDir
done


