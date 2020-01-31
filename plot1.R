
#File path of Huge data file from which to read the data
pathtoload <- rstudioapi::getSourceEditorContext()$path
pathtoload <- gsub("plot1.R","household_power_consumption.txt",pathtoload)
con <- file(pathtoload,"r") # open a connection to the file

#File path of the subsetted newly created data file
pathtowrite <- rstudioapi::getSourceEditorContext()$path
pathtowrite <- gsub("plot1.R","subsetdata.txt",pathtowrite)


#line <- readLines(con,n=2) # read 30 lines at a time into memory

#con1 <- file(pathtowrite,"w") # open a connection to write to.

#writeLines(line,con1,sep = "\n")
#writeLines(line,con1,sep = "\n")
#writeLines(line,con1,sep = "\n")
#writeLines(line,con1,sep = "\n")

#close(con1)
#close(con)



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
      writeLines(line,con1,sep = "\n")
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
        writeLines(line,con1,sep = "\n")
      }
      
    }
    
    if ( length(line) == 0 ) { # termintate the loop if this condition is met, this indicated end of file.
      break
    }
    
  }
  close(con1) 
  close(con) # close the connection to the file 
}


