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

what <- readline("what? ")
where <- readline("where? ")

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
while (i<searchlimit) 
{
url = "http://www.indeed.com/jobs?q=it&l=nashville"
start = "&start="
inc = as.character(i)
newurl = gsub(" ","",paste(url, start, inc))
request <- html(newurl)
jobs <- getinfo(request, "#resultsCol .jobtitle")
jobslist$JOBS <- jobs
firms <- getinfo(request, ".company")
firmslist$FIRMS <- firms
location <- getinfo(request, ".location")
locationlist$LOCATION <- location
mylist$JOBS <- jobslist$JOBS
mylist$FIRMS <- firmslist$FIRMS
mylist$LOCATION <- locationlist$LOCATION
try({
  write.table(mylist, file="/Users/macuser/Desktop/my.csv", row.names=FALSE, sep=",", append=TRUE, col.names=FALSE)
})
i <- i+10
}


