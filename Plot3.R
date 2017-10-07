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

## Plot 3
# load dplyr
library(dplyr)

# Filter for Baltimore
Baltimore_PM25 <- filter(SCC_PM25, fips == "24510")

# Group by year and type, then summarise
Sum_Baltimore_PM25 <- Baltimore_PM25 %>%
  select(-c(1,2,3)) %>%
  group_by(year, type) %>%
  summarise(Emissions = sum(Emissions))

# Generate Plot: Emissions over years, seperation by type

# Load ggplot
library(ggplot2)

# Generate Plot
baseplot3 <- ggplot(Sum_Baltimore_PM25, aes(year, Emissions))
baseplot3 + geom_line(aes(col = factor(type))) + 
  ggtitle("Emissions over years by type in Baltimore") +
  xlab("Years") + ylab("PM 2.5 Emissions in tons") + 
  labs(colour = "Measurement Type")

# Save Plot
dev.print(png, "Plot3.png", width = 640, height = 480)






