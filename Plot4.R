## Download and read Data

# Assign names
zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFILE <- "QuizData.zip"
dataPath <- "QuizData"

# Check if already downloaded and download
if (!file.exists(zipFILE)) {
  download.file(url = zipURL, destfile = zipFILE, method = "curl")
}

# Check if already existing file and unzip
if (!file.exists(dataPath)) {
  unzip(zipFILE)
}

# Check if already in environment and load data in R

if (exists("SCC_PM25") == FALSE) {
  SCC_PM25 <- read_rds("summarySCC_PM25.rds")
}
if (exists("SourceClass") == FALSE) {
  SourceClass <- read_rds("Source_Classification_Code.rds")
}

## Plot 4
# load dplyr
library(dplyr)

# Find SCC's for coal related emissions
CoalEmissionClasses <- SourceClass[grep("Coal", SourceClass$Short.Name), ]
Coal_SCC <- CoalEmissionClasses[,1]

# Subset Coal related PM 2.5 emissions 
Coal_PM25 <- SCC_PM25 %>% filter(SCC %in% Coal_SCC)

# Build data set with sum by years
Sum_Coal_PM25 <- Coal_PM25 %>%
  select(-c(1,2,3,5)) %>%
  aggregate(by = list(Coal_PM25$year), sum)

# Clean new data frame
Sum_Coal_PM25 <- select(Sum_Coal_PM25, -c(3))
names(Sum_Coal_PM25)[1] <- paste("year")

# Generate Plot
library(ggplot2)

baseplot4 <- ggplot(Sum_Coal_PM25, aes(year, Emissions))
baseplot4 + geom_line() + ggtitle("Coal Emissions in the US from 1999 to 2008") + 
  xlab("Years") + ylab("PM 2.5 Emissions from Coal in tons")

# Save Plot
dev.print(png, "Plot4.png", width = 480, height = 480)







