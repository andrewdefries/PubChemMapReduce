#!/usr/bin/env Rscript
###################
library(ChemmineR)
library(parallel)
###################
ncores<-system("nproc")
###################
files<-list.files(pattern="*.sdf", recursive=F)
########
SplitSDFset<-function(a){
#load sdf
sdfset<-read.SDFset(files[a]) #if no cat
#bind names
cid(sdfset)<-datablocktag(sdfset, tag="PUBCHEM_COMPOUND_CID")
#clean sdf
valid <- validSDF(sdfset); sdfset <- sdfset[valid]
#
apset<-sdf2ap(sdfset)
sdfset<-sdfset[-which(sapply(as(apset, "list"), length)==1)]
#subset apset too
apset<-apset[-which(sapply(as(apset, "list"), length)==1)]
####
save(sdfset,file=gsub(".sdf", "_sdfset.rda", files[a]), compress=T)
save(apset,file=gsub(".sdf", "_apset.rda", files[a]), compress=T)
##################
}
a<-1:length(files)
mclapply(a,SplitSDFset, mc.cores=ncores)
##################


