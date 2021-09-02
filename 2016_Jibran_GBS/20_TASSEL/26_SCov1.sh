baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log

cd  $baseDir/06_HapMap

outDir=18_SCov1

## Filter
#mkdir $outDir

#bsub -o $logDir/18.Scov1.log -e $logDir/18.Scov1.err -J KF318 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_SCov0.7/KF3P5L_PS1.68.5_chr+.Scov0.7.hmp.txt -o $outDir/KF3P5L_PS1.68.5_chr+.Scov1.hmp.txt -mnSCov 1 -sC 1 -eC 30 -endPlugin -runfork1
#Job <50200> is submitted to default queue <normal>.


## Summary
resultDir=$baseDir/06_HapMap

perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/18_SCov1 > $baseDir/FilterTry2.SCov1.summary.txt 2>$baseDir/FilterTry2.SCov1.summaryByTaxa.txt

