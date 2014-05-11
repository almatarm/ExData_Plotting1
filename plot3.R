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
png(filename="plot3.png", height=480, width=480)
# Get Data range for x and y axis
xrange <- range(D$Date) 
r1     <- range(D$Sub_metering_1) 
r2     <- range(D$Sub_metering_2) 
r3     <- range(D$Sub_metering_3) 
yrange <- range(r1, r2, r3)

colors <- c("Black", "Red", "Blue")
plot(xrange, yrange, xlab="",  ylab="Energy sub metering" ) 
lines(D$Date, D$Sub_metering_1, type="l", col=colors[1])
lines(D$Date, D$Sub_metering_2, type="l", col=colors[2])
lines(D$Date, D$Sub_metering_3, type="l", col=colors[3])
legend("topright", legend = names(D)[7:9], col=colors, pch = "_", cex = 1, lwd=2);

dev.off();

print(".: plot3.png was saved successfully!");