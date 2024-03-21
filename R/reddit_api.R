# Script Settings and Resources
library(tidyverse)
library(httr)
library(jsonlite)
library(RedditExtractoR)
library(rvest)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning
rstats_page <- read_html("https://www.reddit.com/r/rstats/")
rstats_elements <- html_elements(reddit_page, ".newsList a") # figure out how to get good xpath
rstats_links <- html_attr(reddit_elements, "href")
rstats_text <- html_text(reddit_elements)


rstats_tbl <- tibble(
  link_title = rstats_text,
  link_url = rstats_links
)

View(rstats_tbl)

# posts <- contains the post title text of at least a months worth of posts on 

# upvotes <- the number of upvotes each thread has received

# comments <- the number of comments each post has received
  
  
# Visualization
## Display an appropriate tidyverse visualization of the relationship between upvotes and comments
  
  
# Analysis
## calculate and display the correlation between upvotes and comments, as well as the p-value associate diwth that relationship
cor()
cor.test()


# Publication