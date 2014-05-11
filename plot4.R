# *****************************************************************************
# Global variables                                                            *
# *****************************************************************************
data_file        = "household_power_consumption.txt";
data_file_clean  = "household_power_consumption_clean.csv";

# *****************************************************************************
# Processing                                                                  *
# *****************************************************************************
#Check if the clean data exist
if(file.exists(data_file_clean)) {
  print(".: Reading clean data");
  D <- read.csv(data_file_clean);
  D$Date <- paste(D$Date, D$Time)
  D$Date <- strptime(D$Date, "%Y-%m-%d %H:%M:%S")
} else {
  
  # Check if the data data exist
  if(!file.exists(data_file)) {
    #fatal error, no data directory
    stop(paste("Fatal Error: No data file[", data_file, "] found in the 
               current working directory"));
  }
  
  #read the data
  print(".: Reading the data");
  data = read.table(file=data_file, sep=";", header=TRUE, as.is=TRUE); 
  #read
  data$Date = as.Date(data$Date, "%d/%m/%Y")
  for(colIdx in 3:9) {
    data[[colIdx]] = as.numeric(data[[colIdx]])
  }
  
  print(".: Subsetting the data to choose only first two days in Feb 2007");
  D      <- subset(data, data$Date == as.Date("2007-02-01") | 
                     data$Date == as.Date("2007-02-02"))
  D$Date <- paste(D$Date, D$Time)
  D$Date <- strptime(D$Date, "%Y-%m-%d %H:%M:%S")
  D      <- D[,!(names(D) %in% c("Time"))]
  print(".: Saving the cleanned subset to disk for future use.");
  write.csv(D, file=data_file_clean)
}

# *****************************************************************************
# Saving the plot                                                             *
# *****************************************************************************
png(filename="plot4.png", height=480, width=480)

par(mfrow=c(2,2));

#Plot 1
plot(D$Date, D$Global_active_power, type="l",
     ylab="Global Active Power", xlab="");

#Plot 2
plot(D$Date, D$Voltage, type="l",
     ylab="Voltage", xlab="datetime");

#Plot 3
# Get Data range for x and y axis
xrange <- range(D$Date) 
r1     <- range(D$Sub_metering_1) 
r2     <- range(D$Sub_metering_2) 
r3     <- range(D$Sub_metering_3) 
yrange <- range(r1, r2, r3)
p = plot(xrange, yrange, xlab="",  ylab="Energy sub metering" ) 
lines(D$Date, D$Sub_metering_1, type="l", co="Black")
lines(D$Date, D$Sub_metering_2,  type="l", co="Red")
lines(D$Date, D$Sub_metering_3,  type="l", co="Blue")
legend("topright", legend = names(D)[7:9], col=colors, pch = "_", cex = 1, lwd=2, box.lwd=0);

#plot 4
plot(D$Date, D$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
par(mfrow=c(1,1))
dev.off();

print(".: plot4.png was saved successfully!");