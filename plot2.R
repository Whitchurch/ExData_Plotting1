
#File path of Huge data file from which to read the data
pathtoload <- rstudioapi::getSourceEditorContext()$path
pathtoload <- gsub("plot2.R","household_power_consumption.txt",pathtoload)
con <- file(pathtoload,"r") # open a connection to the file

#File path of the subsetted newly created data file
pathtowrite <- rstudioapi::getSourceEditorContext()$path
pathtowrite <- gsub("plot2.R","subsetdata.txt",pathtowrite)

#=============Code to read line by line of the data and subset the data instead of loading the entire
#============ DataFrame into memory, this approach is used to handle large data that cannot fit on 
#============ out systems memory/RAM.

if(file.exists(pathtowrite))
{
  print("File already exits, skipping the file scan to select only dates from 2007-02-01 to 2007-02-02")
}else
{
  while(TRUE)
  { 
    
    if(!file.exists(pathtowrite))
    {
      con1 <- file(pathtowrite,"wt") # open a connection to write to.
    }
    line <- readLines(con,n= 1) # read 1 line at a time into memory; by varying n we can control how quickly we 
    #subset at the cost of accuracy. n =1 gives the best result; n = 1000 etc etc, gives quick results but with overrruns. and missing data
    
    charvec <- strsplit(line,";") # split the string based on ; seperator
    
    charvec <- unlist(charvec) # convert the list into , vector
    
    if(charvec[1] == "Date")
    {
      writeLines(line,con1,sep = "\n") # writeline into the file subsetdata.txt
    }
    else
    {
      formatDate <- dmy(charvec[1])
      formatDate <- ymd(formatDate)
      
      if(formatDate > "2007-02-02")
      {
        print("Dates of interest exceeded stopping file read")
        break
        
      }
      if(formatDate == ymd("2007-02-01") | formatDate == ymd("2007-02-02"))
      {
        writeLines(line,con1,sep = "\n") # writeline into the file subsetdata.txt
      }
      
    }
    
    if ( length(line) == 0 ) { # termintate the loop if this condition is met, this indicated end of file.
      break
    }
    
  }
  close(con1) 
  close(con) # close the connection to the file 
}
#============End of the code to subset the data
# read the processed subsetted data:-
readsubsetted <- read.csv(pathtowrite,header = TRUE,sep = ";")
dim(readsubsetted) #2880 rows and 9 columns
names(readsubsetted) # print the variable names

datetimeobject <- as.POSIXct(paste(readsubsetted$Date, readsubsetted$Time), format="%d/%m/%Y %H:%M:%S")

png("plot2.png",width = 480, height = 480)
plot(datetimeobject,readsubsetted$Global_active_power,type = "l",ylab = "Global Active Power(kilowatts)",xlab = "")
dev.off()


