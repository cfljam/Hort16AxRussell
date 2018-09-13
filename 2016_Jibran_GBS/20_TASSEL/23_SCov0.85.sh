baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log

cd  $baseDir/06_HapMap

outDir=15_SCov0.85

## Filter
#mkdir $outDir

#bsub -o $logDir/15.Scov0.85.log -e $logDir/15.Scov0.85.err -J KF315 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_SCov0.7/KF3P5L_PS1.68.5_chr+.Scov0.7.hmp.txt -o $outDir/KF3P5L_PS1.68.5_chr+.Scov0.85.hmp.txt -mnSCov 0.85 -sC 1 -eC 30 -endPlugin -runfork1

#Job <50197> is submitted to default queue <normal>.

## Summary
resultDir=$baseDir/06_HapMap

perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/15_SCov0.85 > $baseDir/KF3P5L.SCov0.85.summary.txt 2>$baseDir/KF3P5L.SCov0.85.summaryByTaxa.txt

