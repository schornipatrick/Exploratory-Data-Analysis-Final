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

## PLOT1
# load dplyr
library(dplyr)

# Build data frame with sums for each year
Sum_PM25 <- SCC_PM25 %>%
  select(-c(1,2,3,5)) %>%
  aggregate(by = list(SCC_PM25$year), sum) %>%
  
# Clean new data frame
Sum_PM25 <- select(Sum_PM25, -c(3))
names(Sum_PM25)[1] <- paste("year")

# Plot emmission over years
with(Sum_PM25, plot(year, Emissions, 
                    main = "Emissions from 1999 to 2008", ylab = "Emissions PM2.5 in tons", 
                    xlab = "Years", type = "l"))

# Save plot
dev.print(png, 'Plot1.png', width = 480, height = 480)




