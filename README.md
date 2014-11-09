PubChemMapReduce 
================

The PubChem data set contains molecular 2D and 3D data for over 10 million compounds available as structure data files (SDF) containing 25,000 compounds each. These files are relatively large in size and require lots of pre-processing to perform chemical space calculation. The principles of map-reduce can be used to design a computational workflow that is robust and can scale to process the whole data set in a reasonable amount of time. 

Here a few scripts were written to break up the processing of PubChem into a map-reduce workflow using native R without requiring a Hadoop server or HDFS. These scripts do utilize parallel processing via the library parallel and foreach, and have a final combine step that has not yet been written. 

Since the PubChem data set is so large it is not amenable to standard clustering techniques. Often, the purpose of clustering is to determine nearest neighbors of compounds of interest. Therefore, in the map stage compounds were identified in PubChem with a distinct similarity cutoff to a query data set (here DrugBank). This process, at present, requires an iterative procedure of chunking the PubChem data set into n compounds (500 or 1000), pooling these with the DrugBank compounds, followed by an all-against-all clustering. 

![Workflow Overview](https://github.com/andrewdefries/PubChemMapReduce/blob/master/PubChemMapReduce.png "Workflow Overview")

Master.sh
```
# get worklist by listing contents of storage bucket for PubChem SDFs
gsutil -m ls  gs://pubchem/*.sdf > WorkList

# load WorkList to variable 
worklist=(`cat WorkList`)

# set number of cores from system
ncores=(`nproc`)

# iterate through the worklist in increments determined by the number of cores and worklist length
for m in $(seq 0 $ncores ${#worklist[@]})
do

# setup inner loop to copy multiple files to local for each core   
for (( i=0 ; i<$ncores ; i+$ncores))
do

gsutil -m cp ${worklist[$i+m]} .

let i++

done

# make rda files from SDF
./OpenSDFset.R 

# split to chunks by splitval and cluster with DrugBank, trim dissimilar
./MergeNCluster.R 

# copy generated files to buckets
gsutil -m cp group*.rda gs://pmc_reduce2drugbank/
gsutil -m cp Compound*.rda gs://pmc_rda

done

# merge compounds to proper chemical clade by combining lists and clustering once more
./Combine.R

```


This procedure has the following advantages:

1. The clustering procedure is no longer intractable by chunking the PubChem data into n segments
2. At each stage n segments are tested for similarity to the query data set, thereby focussing the analysis on compounds of direct interest
3. Iterative clustering of n segments by pooling with DrugBank enables us to anchor compounds to distinct chemical clades in the DrugBank data set
4. The result is an index of PubChem with compounds only essential to your query

