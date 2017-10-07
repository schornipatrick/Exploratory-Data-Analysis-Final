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

## Plot 6
# load dplyr
library(dplyr)

# Filter for Baltimore & LA County
Baltimore_LAC_PM25 <- filter(SCC_PM25, fips == "24510" | fips == "06037")

# Find SCC's for motor vehicle related emissions
VehicleEmissionClasses <- SourceClass[grep("Vehicle", SourceClass$Short.Name), ]
Vehicle_SCC <- VehicleEmissionClasses[,1]

# Subset Coal related PM 2.5 emissions 
Vehicle_PM25 <- Baltimore_LAC_PM25 %>% filter(SCC %in% Vehicle_SCC)

# Build data set with sum by years
Sum_Vehicle_PM25 <- Vehicle_PM25 %>%
  select(-c(2,3,5)) %>%
  group_by(fips, year) %>%
  summarise(Emissions = sum(Emissions))

# Replace Fips by descriptive names
Sum_Vehicle_PM25$fips <- gsub("06037", "LA County", Sum_Vehicle_PM25$fips)
Sum_Vehicle_PM25$fips <- gsub("24510", "Baltimore", Sum_Vehicle_PM25$fips)

# Generate Plot: Emissions over years, seperation by type

# Load ggplot
library(ggplot2)

# Generate Plot
baseplot6 <- ggplot(Sum_Vehicle_PM25, aes(year, Emissions))
baseplot6 + geom_line(aes(col = factor(fips))) + 
  ggtitle("Emissions by Vehicles over years in Baltimore & LA County") +
  xlab("Years") + ylab("PM 2.5 Emissions in tons") + 
  labs(colour = "Area")

# Save Plot
dev.print(png, "Plot6.png", width = 640, height = 480)






