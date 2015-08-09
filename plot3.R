library(lubridate)
library(dplyr)
library(data.table)

#############################################################################

# How to use this script:
#   
# 1st) Create a folder called 'Data' in the same folder as this R script.
# 2nd) place the riginal data set, household_power_consumption.txt, in 'Data'
# 3rd) run the script -- but note: we're creating and saving a much smaller
# data set, and we'll be working with that

#############################################################################

# Ouch! household_power_consumption.txt a 2,000,000+ row dataset.
# However, we only need rows where the date is "2007-02-01" or "2007-02-02"
# Unfortunately, read.table() isn't designed to extract specific rows based on the value of a variable,
# so we're forced to read in the whole thing:
epc_full <-  as.data.table(read.table('Data/household_power_consumption.txt', header = TRUE, sep = ";", stringsAsFactors = TRUE) )

#############################################################################

# Reduce epc_full to a data set containing rows where date = 2007-02-01" or "2007-02-02"

#############################################################################

# convert the date column into a Date class
epc_full$Date <- as.Date(epc_full$Date, format = "%d/%m/%Y")

# Reduce epc_full! Extract only dates 2007-02-01 and 2007-02-02
epc <- filter(epc_full,Date == "2007-02-01" | Date == "2007-02-02")

# Get this big dataset out of memory
rm(epc_full)

# Export this reduced set 
write.table(epc, 'Data/epc.txt',row.name=FALSE, sep=';')

# Use the reduced dataset 
epc <-  as.data.table(read.table('Data/epc.txt', header = TRUE, sep = ";", stringsAsFactors = FALSE) )

# as.POSIXct because I need both date and time in one variabel
epc <- transform(epc, DateTime=as.POSIXct(paste(Date, Time)))

#############################################################

# Now plot 3 variables as a function of time (DateTime):

# Sub_metering_1
# Sub_metering_2
# Sub_metering_3

# Use paramters:
# type = "l" for line
# lty = 1 for solid line

#############################################################
  
# write this graph to png file, in the same folder as this script
png(file="plot3.png",width=480,height=480)
# NOTE: add x & y labels when I first plot data
with(epc, plot(DateTime,Sub_metering_1, type="n")) 
  with(epc, plot(DateTime,Sub_metering_1, xlab="", ylab="Energy sub metering", type="l", lty = 1)) 
  with(epc, points(DateTime,Sub_metering_2, type="l", lty = 1, col = "red"))
  with(epc, points(DateTime,Sub_metering_3, type="l", lty = 1, col = "blue"))
  with(epc, 
      legend("topright",
              c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
              lty=c(1,1,1),
              col=c("black","red","blue"))
)
dev.off()
