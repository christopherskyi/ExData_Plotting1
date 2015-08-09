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

# Create a line plot of Global Active Power by Weekday

#############################################################################

###########################################################

# Getting the required x-axis labels is tricky, so I'm including
# some detailed notes in the code below

###########################################################

# Use the reduced dataset 
epc <-  as.data.table(read.table('Data/epc.txt', header = TRUE, sep = ";", stringsAsFactors = FALSE) )
# With stringsAsFactors = TRUE, Data and Time are factors, but set to FALSE then become chars
# > str(epc)
# Classes 'data.table' and 'data.frame':	2880 obs. of  9 variables:
# $ Date                 : chr  "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" ...
# $ Time                 : chr  "00:00:00" "00:01:00" "00:02:00" "00:03:00" ...

# as.POSIXct because I need both date and time in one variabel
epc <- transform(epc, DateTime=as.POSIXct(paste(Date, Time)))
# > str(epc)
# Classes 'data.table' and 'data.frame':	2880 obs. of  10 variables:
# $ Date                 : chr  "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" ...
# $ Time                 : chr  "00:00:00" "00:01:00" "00:02:00" "00:03:00" ...
# $ DateTime             : POSIXct, format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 0

# R magic spell: given DateTime in POSIXct format, I'll get weekdays on the x-axis

# write histo to png file, in the same folder as this script
png(file="plot2.png",width=480,height=480)
   with(epc, plot(DateTime,Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")) 
dev.off()
