library("ggplot2") #Plotting functions
library ("adegenet") #Does most of the PCA, DAPC, and plotting functions

setwd("location_of_input_files") #set working directory to where all input files are

#####Input genepop file###############
genepop <- "name_of_input_file"
genepop_read <- read.genepop(genepop, ncode=3)

step <- tab(genepop_read, NA.method="mean")
pca1 <- dudi.pca(step, scannf = FALSE, scale = FALSE, nf=4)
temp <- as.integer(pop(genepop_read))

######plot PCA######
colors <- c("#a63603", "#e6550d", "#fd8d3c", "#fdbe85", "#756bb1", "#cbc9e2")

genepop_read$pop <- revalue(genepop_read$pop, c("0931" = "NPBS", "1111"="HAY1N", "0923"="RFSE", "0BAB"="NPBE", "0293"="W1", "0299"="W2"))
####################################
s.class(pca1$li,pop(genepop_read),col=(colors), pch = 20,xax=1,yax=2, axesel=FALSE, clabel = FALSE, cstar=0, cpoint = 3, grid=FALSE)
legend("right", legend = levels(pop(genepop_read)), col=colors, pch = 19, cex = 0.8)
add.scatter.eig(pca1$eig[1:50],3,1,2, ratio=.2)