#@@@ Read and Clean data
rm(list = ls())
data_dir <- 'D:/Data/Kaggle_WNV/'

# read
# data.train <- read.csv(paste(data_dir,'train.csv',sep=''))
# data.test <- read.csv(paste(data_dir,'test.csv',sep='')) 
# data.spray <- read.csv(paste(data_dir,'spray.csv',sep=''))
# data.weather <- read.csv(paste(data_dir,'weather.csv',sep=''))
# data.subsample <- read.csv(paste(data_dir,'sampleSubmission.csv',sep=''))
# dsD <- paste(data.spray$Date,data.spray$Time)
# data.spray$Date <- as.POSIXct(dsD,format = '%Y-%m-%d %H:%M:%S',tz = 'UTC')
# data.spray$Date[grepl('PM',data.spray$Time)] <- data.spray$Date[grepl('PM',data.spray$Time)] + 12*60*60
# data.spray$Time <- NULL
# data.test$Date <- as.Date(data.test$Date)
# data.train$Date <- as.Date(data.train$Date)
# save(data.train,data.test,data.spray,data.weather,file = paste(data_dir,'data.Rda',sep=''))
# load(paste(data_dir,'mapdata_copyright_openstreetmap_contributors.rds',sep=''))

#Load dataset
load(file.path(data_dir,'data.Rda'))

# Get labels
labels = data.train$WnvPresent

# Not using codesum for this benchmark
data.weather$CodeSum <- NULL

# Split station 1 and 2 and join horizontally
weather_stn1 <- data.weather[data.weather$Station == 1,]
weather_stn2 <- data.weather[data.weather$Station == 2,]
weather_stn1$Station <- NULL
weather_stn2$Station <- NULL
weather <- merge(weather_stn1,weather_stn2,by = 'Date')

# replace some missing values and T with -1
for (i in 1:ncol(weather)){
  if (is.factor(weather[,i]))
    weather[,i] <- as.character(weather[,i])
}
weather[weather == 'M'] <- -20
weather[weather == '-'] <- -20
weather[weather == 'T'] <- -20
weather[weather == ' T'] <- -20
weather[weather == '  T'] <- -20
for (i in 1:ncol(weather)){
  if (is.character(weather[,i]))
    weather[,i] <- as.numeric(levels(weather[,i]))[weather[,i]]
}
data.weather$Date <- as.Date(data.weather$Date)

# Functions to extract month and day from dataset
# You can also use parse_dates of Pandas.
data.train$month <- month(data.train$Date)
data.train$day <- day(data.train$Date)
data.test$month <- month(data.test$Date)
data.test$day <- day(data.test$Date)

# Add integer latitude/longitude columns
data.train$Lat_int <- as.integer(data.train$Latitude)
data.train$Long_int <- as.integer(data.train$Longitude)
data.test$Lat_int <- as.integer(data.test$Latitude)
data.test$Long_int <- as.integer(data.test$Longitude)


# drop address columns
data.train$Address <- NULL
data.train$AddressNumberAndStreet <- NULL
data.train$WnvPresent <- NULL
data.train$NumMosquitos <- NULL
data.test$Id <- NULL
data.test$Address <- NULL
data.test$AddressNumberAndStreet <- NULL


# Merge with weather data
train <- merge(data.train,data.weather,by = 'Date')
test <- merge(data.test,data.weather,by = 'Date')
train$Date <- NULL
test$Date <- NULL


# Convert categorical data to numbers
train$Species <- as.numeric(train$Species)
train$Street <- as.numeric(train$Street)
train$Trap <- as.numeric(train$Trap)
test$Species <- as.numeric(test$Species)
test$Street <- as.numeric(test$Street)
test$Trap <- as.numeric(test$Trap)

# # drop columns with -1s
# train = train.ix[:,(train != -1).any(axis=0)]
# test = test.ix[:,(test != -1).any(axis=0)]
# 
# # Random Forest Classifier 
# clf = ensemble.RandomForestClassifier(n_jobs=-1, n_estimators=1000, min_samples_split=1)
# clf.fit(train, labels)
# 
# # create predictions and submission file
# predictions = clf.predict_proba(test)[:,1]
# sample['WnvPresent'] = predictions
# sample.to_csv('beat_the_benchmark.csv', index=False)