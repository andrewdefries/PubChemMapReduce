
gsutil -m ls gs://pubchem/*.sdf > Worklist
############################
filecontent=(`cat WorkList_*`)
for t in "${filecontent[@]}"
####
do
####

gsutil -m cp $t .
gsutil -m cp $[$t+1] .
gsutil -m cp $[$t+2] .
gsutil -m cp $[$t+3] .
gsutil -m cp $[$t+4] .
gsutil -m cp $[$t+5] .
gsutil -m cp $[$t+6] .
gsutil -m cp $[$t+7] .
gsutil -m cp $[$t+8] .
gsutil -m cp $[$t+9] .
gsutil -m cp $[$t+10] .
gsutil -m cp $[$t+11] .
gsutil -m cp $[$t+12] .
gsutil -m cp $[$t+13] .
gsutil -m cp $[$t+14] .
gsutil -m cp $[$t+15] .
gsutil -m cp $[$t+16] .

filecontent=$[$t + 17]


###
echo "#################################"
echo "#################################"
echo "Doing some Chemmining of $t to $[$t+16]"
echo "#################################"
echo "#################################"

#R CMD BATCH DrugBank/PrepareDrugBank.R
R CMD BATCH OpenSDFset
R CMD BATCH MergeNCluster.R

echo "#################################"
echo "#################################"
echo "Doing some copying of $t to $[$t+16]"
echo "#################################"

gsutil -m cp group*.rda gs://pmc_reduce2drugbank/

rm group*.rda
rm Compound*

echo "Moving on"

done


