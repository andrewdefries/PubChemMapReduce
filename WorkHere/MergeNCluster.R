#!/usr/bin/env Rscript
###################
library(ChemmineR)
library(parallel)
###################
ncores<-system("nproc")
sdfset_files<-list.files(pattern="Compound*")
apset_files<-list.files(pattern="Compound*")
#######################
MergeWork<-function(b){
#######################
load(apset_files[b])
apset_a<-apset
rm(apset)
load("DrugBank_approved_apset.rda")
apset_b<-apset
rm(apset)
##
splitVal<-500
apset_increment<-seq(1,length(apset_a),splitVal)
##
for (i in apset_increment){
apset<-c(apset_a[i:i+1], apset_b)
##
#naebors<-108
#nnm <- nearestNeighbors(apset,numNbrs=naebors)
###############
cluster<-cmp.cluster(apset, cutoff=c(0.7))
##
if (match(cluster$ids,cid(apset))==1){
#nnm$names
save(cluster, file=paste("group_", i, "_", gsub("_apset.rda", "_cluster_w_approved.rda", apset_files[b]), sep=""), compress=T)
}else{}
##
}
##########################
}
b<-1:length(sdfset_files)
mclapply(b, MergeWork, mc.cores=ncores)

