ncores=(`nproc`)

rm group*.rda
rm Compound*

rm Compound*.sdf
rm RunLog
rm *.Rout

gsutil -m ls  gs://pubchem/*.sdf > WorkList
worklist=(`cat WorkList`)

for m in $(seq 0 $ncores ${#worklist[@]})
do

for (( i=0 ; i<$ncores ; i+$ncores))
do
#echo "gsutil -m cp ${worklist[$i+$m]} ."
gsutil -m cp ${worklist[$i+m]} .
let i++
done
echo "Run OpenSDF.R script"
./OpenSDFset.R 
echo "Run MergeNCluster.R script"
./MergeNCluster.R 
echo "increment $m"

gsutil -m cp group_*.rda gs://pmc_reduce2drugbank/
gsutil -m cp Compound*.rda gs://pmc_rda

rm group*.rda
rm Compound*

cat *.Rout >> RunLog

echo "Moving on"

done


