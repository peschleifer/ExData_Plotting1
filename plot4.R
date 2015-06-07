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
png( filename="plot4.png", width=480, height=480 )

# Specify 2x2 plots, row-wise
par( mfrow = c(2,2) )

# Generate the plots
with( electricPowerConsumption, {
    
    plot( dateTime,
          Global_active_power,
          type = "l",
          xlab = "",
          ylab = "Global Active Power (kilowatts)"
    )

    plot( dateTime,
          Voltage,
          type = "l",
          xlab = "datetime",
          ylab = "Voltage"
    )

    plot( dateTime,
          Sub_metering_1,
          type = "l",
          xlab = "",
          ylab = "Energy sub metering" )
    points( dateTime,
            Sub_metering_2,
            type = "l",
            col = "red" )
    points( dateTime,
            Sub_metering_3,
            type = "l",
            col = "blue" )
    legend( "topright",
            legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
            col = c("black", "red", "blue"),
            lty = 1,
            bty = "n"
    )

    plot( dateTime,
          Global_reactive_power,
          type = "l",
          xlab = "datetime",
          ylab = "Global_reactive_power"
    )
}
)

# Close file
dev.off()
