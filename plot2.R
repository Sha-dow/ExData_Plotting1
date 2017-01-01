# Set variables
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "./household_power_consumption.txt"
destination <- "consumptiondata.zip"
imagefile <- "plot2.png"

# Check if file exists. If not, download it
if (!file.exists(file)) {
    download.file(url, destfile = destination)
    unzip(destination)
    file.remove(destination)
}

# Read data
cons <- read.table(file, 
                   sep=";", header=TRUE, stringsAsFactors=FALSE, na.strings="?", 
                   colClasses=c("character","character","double","double","double","double","double","double","numeric"))

# Convert dates to correct format
cons$Date <- as.Date(cons$Date, "%d/%m/%Y")

# Create datetime field
cons$DateTime <- as.POSIXct(strptime(paste(cons$Date, cons$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S"))

# filter correct timeframe
plotdata <- with(cons, cons[(Date >= "2007-02-01" & Date <= "2007-02-02"), ])

# draw plot
png(file = imagefile, width = 480, height = 480, units = "px")

with(plotdata, 
     plot(plotdata$DateTime, plotdata$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))

dev.off()
