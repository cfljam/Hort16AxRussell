baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL
workDir=$baseDir/06_HapMap
outDir=/output/genomic/plant/Actinidia/GBS_PS1_1.68.5/2016_CAGRF12857/20_TASSEL
mkdir $outDir

cd $baseDir

## Configure files
tar -czvf KF_3Plates_5Lanes.ConfigFiles.tgz ConfigFiles
mv KF_3Plates_5Lanes.ConfigFiles.tgz $outDir/

## Summary
mv KF3* $outDir/
ln -s $outDir/*.txt .

## Result
cd $workDir
mv KF3P5L_Ref_PS1.68.5.Scov0.7.AllChrs.hmp.txt $outDir/
ln -s $outDir/KF3P5L_Ref_PS1.68.5.Scov0.7.AllChrs.hmp.txt .

tar -czvf KF3P5L_Ref_PS1.68.5.Raw.tgz 05_ExcludeBlank
tar -czvf KF3P5L_Ref_PS1.68.5.SCov0.7.tgz 06_SCov0.7

mv *.tgz $outDir/
ln -s $outDir/KF3P5L_Ref_PS1.*.tgz .

mv 07_SCov1 $outDir/
ln -s $outDir/07_SCov1 .





