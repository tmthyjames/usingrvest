# r script that grabs job titles, firm names, and locations from indeed.com

require(rvest)

jobslist <- list()
firmslist <- list()
locationlist <- list()
mylist <- list()

url <- "http://www.indeed.com/jobs?q=it&l=nashville"
request <- html(url)
count <- request %>%
  html_nodes("#searchCount") %>%
  html_text()

count <- strsplit(count, " ")[[1]][6]
count <- as.numeric(gsub(",","",count))
searchlimit <- if(count<1001) count else 1001

i=0
while (i<30) 
{
url = "http://www.indeed.com/jobs?q=it&l=nashville"
start = "&start="
inc = as.character(i)
newurl = gsub(" ","",paste(url, start, inc))
request <- html(newurl)
jobs <- request %>%
  html_nodes("#resultsCol .jobtitle") %>%
  html_text()
  jobslist$JOBS <- jobs
firms <- request %>%
  html_nodes(".company") %>%
  html_text()
  firmslist$FIRMS <- firms
location <- request %>%
  html_nodes(".location") %>%
  html_text()
  locationlist$LOCATION <- location
mylist$JOBS <- jobslist$JOBS
mylist$FIRMS <- firmslist$FIRMS
mylist$LOCATION <- locationlist$LOCATION
write.table(mylist, file="my.csv", row.names=FALSE, sep=",", append=TRUE, col.names=FALSE)
i <- i+10
}

