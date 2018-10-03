baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
## Step 12: Overall summary
resultDir=$baseDir/06_HapMap

perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/06_SCov0.7 > $baseDir/KF3P5L.SCov0.7.summary.txt 2>$baseDir/KF3P5L.SCov0.7.summaryByTaxa.txt

perl /home/hrachd/mytools/tassel_hmp_summary.pl $resultDir/07_SCov1 > $baseDir/KF3P5L.SCov1.summary.txt 2>$baseDir/KF3P5L.SCov1.summaryByTaxa.txt


