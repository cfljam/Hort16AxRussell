baseDir=/workspace/hrachd/Actinidia/2016_CAGRF12857/20_TASSEL/06_HapMap
cd $baseDir/06_SCov0.7

outFile=KF3P5L_Ref_PS1.68.5.Scov0.7.AllChrs.txt
head -n 1 KF3P5L_PS1.68.5_chr18.Scov0.7.hmp.txt > $outFile

for file in `ls *.hmp.txt`
do
  tail -n +2 $file >> $outFile
done

cd $baseDir

mv 06_SCov0.7/$outFile KF3P5L_Ref_PS1.68.5.Scov0.7.AllChrs.hmp.txt

