baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
logDir=$baseDir/.log

cd  $baseDir
bsub -o $logDir/12.Scov0.7.log -e $logDir/12.Scov0.7.err -J KF312 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_HapMap/05_ExcludeBlank/KF3_3P5L_KF3_20160802_MgTaxa_chr+.hmp.txt -o 06_HapMap/06_SCov0.7/KF3P5L_PS1.68.5_chr+.Scov0.7.hmp.txt -mnSCov 0.7 -sC 1 -eC 30 -endPlugin -runfork1

## Step 13: Filter by SCov1
bsub -o $logDir/13.Scov1.log -e $logDir/13.Scov1.err -J KF313 /software/bioinformatics/tassel-3.0/run_pipeline.pl -fork1 -GBSHapMapFiltersPlugin -hmp 06_HapMap/05_ExcludeBlank/KF3_3P5L_KF3_20160802_MgTaxa_chr+.hmp.txt -o 06_HapMap/07_SCov1/KF3P5L_PS1.68.5_chr+.Scov1.hmp.txt -mnSCov 1 -sC 1 -eC 30 -endPlugin -runfork1

