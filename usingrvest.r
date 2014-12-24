#!/usr/bin/env Rscript

# r script that grabs job titles, firm names, and locations from indeed.com

require(rvest)

getinfo <- function(page, tags) {
  page %>%
  html_nodes(tags) %>%
  html_text()
}

jobslist <- list()
firmslist <- list()
locationlist <- list()
mylist <- list()

what <- 'it'
where <- 'nashville'

url <- "http://www.indeed.com/jobs?"
q <- "q="
l <- "&l="
url <- paste(url,q,what,l,where,sep="")

request <- html(url)
count <- request %>%
  html_nodes("#searchCount") %>%
  html_text()

count <- strsplit(count, " ")[[1]][6]
count <- as.numeric(gsub(",","",count))
searchlimit <- if(count<1001) count else 1001

i=0
while (i<searchlimit) {
  url = "http://www.indeed.com/jobs?q=it&l=nashville"
  start = "&start="
  inc = as.character(i)
  newurl = gsub(" ","",paste(url, start, inc))
  request <- html(newurl)
  firms <- getinfo(request, ".company")
  # firmslist$FIRMS <- firms
  jobs <- getinfo(request, "#resultsCol .jobtitle")
  jobs <- gsub("\n","",jobs)
  # jobslist$JOBS <- jobs
  location <- getinfo(request, ".location")
  location <- gsub("[0-9]","",location)
  location <- gsub("\\(.*\\)","",location)
  # locationlist$LOCATION <- location
  mylist$FIRMS <- firms
  mylist$JOBS <- jobs
  mylist$LOCATION <- location

  # for (firm in firms) {
  #   for (loc in location) {
  #     firm <- gsub(" ","+",firm)
  #     loc <- gsub(", ","+",loc)
  #     bingurl <- 'http://www.bing.com/searchq?='
  #     conturl <- paste(bingurl,firm,loc,sep="")
  #     req <- html(conturl)
  #     numbers <- gregexpr('[0-9]{3}[\\.-][0-9]{3}[\\.-][0-9]{4}', req)
  #     print(numbers)
  #   }
  # }

  try({
    write.table(mylist, file="/Users/macuser/Desktop/my.csv", row.names=FALSE, sep=",", append=TRUE, col.names=FALSE)
  })
  i <- i+10
}








# mydata <- read.csv('Desktop/my.csv', header=FALSE)
# colnames(mydata) <- c('FIRMS','JOBS','LOCATION')

# for (i in mydata$FIRMS) {
#   for (j in mydata$LOCATION) {

#     url <- paste('https://www.bing.com/searchq?q=',gsub(" ","+",i),gsub(" ","+",j))
#   }
# }

















