#!/usr/bin/env Rscript
##################
library(ChemmineR)
##################

sdfset<-read.SDFset("approved.sdf")

cid(sdfset)<-datablocktag(sdfset, tag="DRUGBANK_ID")
##
valid <- validSDF(sdfset); sdfset <- sdfset[valid]
#
apset<-sdf2ap(sdfset)
sdfset<-sdfset[-which(sapply(as(apset, "list"), length)==1)]
apset<-apset[-which(sapply(as(apset, "list"), length)==1)]
##
save(sdfset, file="DrugBank_approved_sdfset.rda", compress=T)
save(apset, file="DrugBank_approved_apset.rda", compress=T)
##
#cluster<-cmp.cluster(apset, cutoff=c(0.7)) ##,0.4,0.6,0.7,0.8))
