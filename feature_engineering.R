setwd('/Users/kojin/psets/counterfactual_fairness_regularizer')
library(dummies)
library(Matching)

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
df <- read.csv(file="adult_wo_spaces.csv", sep=",")
df.onehot <- read.csv(file="adult_one_hot.csv", sep=",")
match <- Match(Y=df.onehot$income,Tr=as.logical(as.integer(df$sex)-1),X=df.onehot[,!(names(df.onehot) %in% c('income','sex_Female','sex_Male'))])
male.ids <-as.numeric(rownames(data.frame(df[match$index.treated,])))-1
female.ids <- as.numeric(gsub("\\..*","",rownames(data.frame(df[match$index.control,]))))-1
write.csv(cbind(male.ids,female.ids), file = "adult_matches.csv",row.names=FALSE)
