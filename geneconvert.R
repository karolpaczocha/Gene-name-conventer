#import the biomaRt library and data.table
library(biomaRt)
library(data.table)

#importing all gene data sets

ensembl <- useEnsembl(biomart = "genes")


#selecting the data set for ensembl

datasets <- listDatasets(ensembl)
head(datasets)

#search for human (in this case)

searchDatasets(mart = ensembl, pattern = "hsapiens")

# update the data set sinc enone is selcted after we find the one we need

ensembl <- useDataset(dataset = "hsapiens_gene_ensembl", mart = ensembl)

# to finalise setting up just and having the rigth data set in the future

ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")

#setting up the querry
#searching the filters
filters = listFilters(ensembl)

#serching the attributes
attributess <- listAttributes(ensembl)
searchatts <- searchAttributes(mart = ensembl, pattern = "gene_id")
searchfilt <- searchFilters(mart = ensembl, pattern = "gene")

#finding out more information on specific tables
filterType("affy_hugene_1_0_st_v1", ensembl)

# writing the querry
mart <- useEnsembl(dataset = "hsapiens_gene_ensembl", biomart = "ensembl")
#set the querry to produce a new table tored as a variable
outputgenes <- select(mart, keys= affy2string, columns = c('affy_hugene_1_0_st_v1', "ensembl_gene_id", "external_gene_name"), keytype = "affy_hugene_1_0_st_v1" )

#datatype conversion logic can depend on what you wish your data set to look like in this case i only wnat to map the ~gid~ column probe ids to the names
affy2 <- read.csv("C:\\Users\\paczkar\\Desktop\\ML\\GeneExpr.csv")
affy2gid = affy2$gid
affy2arr = array(c(affy2gid))
affy2string = as.character(affy2arr)

#write the output to a new csv file
write.csv(outputgenes, "C:\\Users\\paczkar\\Desktop\\ML\\GeneExprNames.csv", row.names=FALSE)
