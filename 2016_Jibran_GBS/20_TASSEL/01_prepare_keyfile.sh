inputDir=/input/genomic/plant/Actinidia/chinensis/GBS/2016_CAGRF12857
cd $inputDir

inputFile=KF3_KeaPlantID.txt

cp $inputFile KF3_KeaPlantID.txt_orig

## Remove '\r'
perl -p -i -e 's/\r//g' $inputFile


## Replace '--' by 'Blank'
perl -p -i -e 's/\t--\t/\tBlank\t/g' $inputFile

## Only allow a-z, A-Z, 0-9, \., \- or \_ and tab in the keyfile
perl -p -i -e 's/[^a-zA-Z0-9\.\-\_\t\n]//g' $inputFile

### alternatively can use:
### tr -cd '\11\12\15\40-\176' < $inputFile > clean-file
### 11: tab
### 12: linefeed
### 15: carriage return
### 40 to 176: all the 'good' keyboard characters


