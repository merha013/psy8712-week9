# Script Settings and Resources
library(tidyverse)
library(httr)
library(jsonlite)
library(rvest)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning
urls <- c(
  "https://www.cnbc.com/business/",
  "https://www.cnbc.com/investing/",
  "https://www.cnbc.com/tech/",
  "https://www.cnbc.com/politics/"
)

# Initialize an empty list to store data from each section
cnbc_list <- list()

# Loop over each section URL
for(url in urls) {
  # Read the HTML content of the webpage
  webpage <- read_html(url)
  # Scrape headlines
  headlines <- webpage %>%
    html_nodes(".Card-title") %>%
    html_text() %>%
    trimws()
  # Calculate the number of words in each headline
  lengths <- sapply(strsplit(headlines, "\\s+"), length)
  # Extract the section name from the URL
  section <- gsub("https://www.cnbc.com/(\\w+)/", "\\1", url)
  # Create a data frame for the current section
  cnbc_data <- data.frame(
    headline = headlines,
    length = lengths,
    source = rep(section, length(headlines))
  )
  # Append the data fro the current section to the list
  cnbc_list[[length(cnbc_list) +1]] <- cnbc_data
}

# Combine data from all sections into a single data frame
cnbc_tbl <- do.call(rbind, cnbc_list)

# Visualization
cnbc_tbl %>%
  ggplot(aes(x=source, y = length, color = source)) + # I like adding color.
  geom_boxplot() + # allows you to compare means and standard deviations
  geom_jitter() + # adds a depiction of where the real data is
  labs(title = "Relationship Between Source and Headline Length",
       x = "Source",
       y = "Headline Length") +
  theme_bw()

# Analysis
analysis_cnbc <- aov(length ~ source, cnbc_tbl)
summary(analysis_cnbc)
f_cnbc <- analysis_cnbc$F.value # doesn't work. need to manually pull
p_value_cnbc <- analysis_cnbc$p.value # doesn't work. need to manually pull
df_cnbc <- analysis_cnbc$parameter # doesn't work. need to manually pull
significance_cnbc <- if(p_value_cnbc>0.05){"was not"}else{"was"}

# Publication
cat(sprintf("The results of an ANOVA comparing lengths across sources was F(%d)= %s, p = %.2f. This test %s statistically significant.", df_cnbc, f_cnbc, p_value_cnbc, significance_cnbc))
