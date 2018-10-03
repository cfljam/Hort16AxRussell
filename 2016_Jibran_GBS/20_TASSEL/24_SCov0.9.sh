baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log

cd  $baseDir/06_HapMap

outDir=16_SCov0.9

## Filter
#mkdir $outDir

#bsub -o $logDir/16.Scov0.9.log -e $logDir/16.Scov0.9.err -J KF316 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_SCov0.7/KF3P5L_PS1.68.5_chr+.Scov0.7.hmp.txt -o $outDir/KF3P5L_PS1.68.5_chr+.Scov0.9.hmp.txt -mnSCov 0.9 -sC 1 -eC 30 -endPlugin -runfork1
#Job <50198> is submitted to default queue <normal>.


## Summary
resultDir=$baseDir/06_HapMap

perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/16_SCov0.9 > $baseDir/KF3P5L.SCov0.9.summary.txt 2>$baseDir/KF3P5L.SCov0.9.summaryByTaxa.txt

