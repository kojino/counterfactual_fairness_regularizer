setwd('/Users/kojin/psets/counterfactual_fairness_regularizer')
library(dummies)
library(Matching)
library(data.table)

# Remove spaces from original data.
df <- read.csv(file="adult.data", header=FALSE, sep=",")
df <- as.data.frame(apply(df,2,function(x)gsub('\\s+', '',x)))
colnames(df) <- c('age','workclass','fnlwgt','education',
                  'education-num','marital-status','occupation',
                  'relationship','race','sex','capital-gain',
                  'capital-loss','hours-per-week','native-country','income')
write.csv(df, file = "adult_wo_spaces.csv",row.names=FALSE)


# One-hot encode data.
df <- read.csv(file="adult_wo_spaces.csv", sep=",")
df <- dummy.data.frame(df, names=c('workclass','education','marital.status','occupation','relationship','race','sex','native.country'), sep="_")
df$income <- df$income == '>50K'
write.csv(df, file = "adult_one_hot.csv",row.names=FALSE)


# Matching
df <- read.csv(file="data/adult_wo_spaces.csv", sep=",")
df.onehot <- read.csv(file="data/adult_one_hot.csv", sep=",")
match.full <- Match(Y=df.onehot$income,Tr=as.logical(as.integer(df$sex)-1),X=df.onehot[,!(names(df.onehot) %in% c('income','sex_Female','sex_Male'))],ties=FALSE)
male.ids <-as.numeric(rownames(data.frame(df[match$index.treated,])))-1
female.ids <- as.numeric(gsub("\\..*","",rownames(data.frame(df[match$index.control,]))))-1
write.csv(cbind(male.ids,female.ids), file = "adult_matches.csv",row.names=FALSE)

match.nondesc <- Match(Y=df.onehot$income,Tr=as.logical(as.integer(df$sex)-1),X=df.onehot[,names(df.onehot) %like% "race|age|native.country" & !names(df.onehot) %like% "managerial"],ties=FALSE)
male.ids <-as.numeric(rownames(data.frame(df[match.nondesc$index.treated,])))-1
female.ids <- as.numeric(gsub("\\..*","",rownames(data.frame(df[match.nondesc$index.control,]))))-1
write.csv(cbind(male.ids,female.ids), file = "adult_matches_nondesc.csv",row.names=FALSE)
grepl( "race" , names( df ) )

df.onehot[,names(df.onehot) %like% "race|age|native.country" & !names(df.onehot) %like% "managerial"]
length(male.ids)

ncol(df.onehot[,!(names(df.onehot) %in% c('income','sex_Female','sex_Male'))])
nrow(df.onehot[,!(names(df.onehot) %in% c('income','sex_Female','sex_Male'))])
ncol(df.onehot[,names(df.onehot) %like% "race|age|native.country" & !names(df.onehot) %like% "managerial"])
nrow(df.onehot[,names(df.onehot) %like% "race|age|native.country" & !names(df.onehot) %like% "managerial"])
match.nondesc$index.treated
match.nondesc$index.control
as.logical(as.integer(df$sex)-1)
