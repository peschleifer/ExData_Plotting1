sourceUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile = "exdata_data_household_power_consumption.zip"
dataFile = "./household_power_consumption.txt"

# Make sure we have the needed packages loaded
if ( !(require(dplyr) && require(lubridate)) ) {
    stop ("You need to install the dplyr & libridate packages to run this script")
}

# Download and unzip file if it does not exist
if ( !file.exists(dataFile) ) {
    download.file(sourceUrl,zipFile)
    unzip(zipFile)
}

# File heading delimited by periods, data delimited by semi-colons, ?'s represent NA
electricPowerConsumption = tbl_df(read.table(dataFile, skip=1, sep=";", 
                                             col.names=c("Date",
                                                         "Time",
                                                         "Global_active_power",
                                                         "Global_reactive_power",
                                                         "Voltage",
                                                         "Global_intensity",
                                                         "Sub_metering_1",
                                                         "Sub_metering_2",
                                                         "Sub_metering_3"),
                                             na.strings="?"))

# Convert date & time and filter to rows of interest
electricPowerConsumption <-
    electricPowerConsumption %>%
    mutate(dateTime = dmy_hms(paste(Date,Time))) %>%
    filter(as.Date(dateTime) == as.Date("2007-02-01") |
               as.Date(dateTime) == as.Date("2007-02-02") ) %>%
    # Don't need original date and time columns
    select( -(Date:Time) )

# Open the graphics device
png( filename="plot3.png", width=480, height=480 )

# Generate the plot
with( electricPowerConsumption, {
      plot( dateTime,
            Sub_metering_1,
            type = "l",
            xlab = "",
            ylab = "Energy sub metering" )
      # Add the red line for sub-metering 2
      points( dateTime,
              Sub_metering_2,
              type = "l",
              col = "red" )
      # Add the blue line for sub-metering 3
      points( dateTime,
              Sub_metering_3,
              type = "l",
              col = "blue" )
      legend( "topright",
              legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
              col = c("black", "red", "blue"),
              lty = 1
              )
    }
)

# Close file
dev.off()
