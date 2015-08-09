# to avoid bugs when using both plyr and dplyr you should load plyr before dplyr. 
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

#############################################################################

# Create a histogram of the freq of Global Active Power

#############################################################################

# Use the reduced dataset 
epc <-  as.data.table(read.table('Data/epc.txt', header = TRUE, sep = ";", stringsAsFactors = TRUE) )

# create more readable variable names
epc.var.names <- colnames(epc)
epc.var.names[3] <- "Global Active Power (kilowatts)"
epc.var.names[4] <- "Global Reactive Power (kilowatts)"
setnames(epc,colnames(epc),epc.var.names)

# convert the data values from a Factor to a Date class
epc$Date <- as.Date(epc$Date)

# get all the weekdays
epc.weekdays <- weekdays(epc$Date)

# add weekdays to data set
epc <- mutate(epc, Weekday = epc.weekdays)

# this call includes 'epc$' in the x-axis label
# hist(epc$`Global Active Power (kilowatts)`, col = "red")
with(epc, hist(`Global Active Power (kilowatts)`, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red"))

# write histo to png file, in the same folder as this script
png(file="plot1.png",width=480,height=480)
  with(epc, hist(`Global Active Power (kilowatts)`, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red"))
dev.off()
