#@@@ Read and Clean data
rm(list = ls())
data_dir <- 'D:/Data/Kaggle_WNV/'

data.train <- read.csv(paste(data_dir,'train.csv',sep=''))
data.test <- read.csv(paste(data_dir,'test.csv',sep='')) 
data.spray <- read.csv(paste(data_dir,'spray.csv',sep=''))
data.weather <- read.csv(paste(data_dir,'weather.csv',sep=''))
data.subsample <- read.csv(paste(data_dir,'sampleSubmission.csv',sep=''))
load(paste(data_dir,'mapdata_copyright_openstreetmap_contributors.rds',sep=''))
