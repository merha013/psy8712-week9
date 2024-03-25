# Script Settings and Resources
library(tidyverse)
library(rvest)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Data Import and Cleaning
urls <- c( # defines the four websites to pull from
  "https://www.cnbc.com/business/",
  "https://www.cnbc.com/investing/",
  "https://www.cnbc.com/tech/",
  "https://www.cnbc.com/politics/"
)

cnbc_list <- list() # Initialize an empty list to store data from each section

for(url in urls) { # Loop over each section URL
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

cnbc_tbl <- do.call(rbind, cnbc_list) # Combine data into a single data frame

# Visualization
cnbc_tbl %>%
  ggplot(aes(x=source, y = length, color = source)) + # I like adding color.
  geom_boxplot() + # allows you to compare means and standard deviations
  geom_jitter() + # adds a depiction of the real data
  labs(title = "Relationship Between Source and Headline Length",
       x = "Source",
       y = "Headline Length") +
  theme_bw() # just picking a theme that looks good

# Analysis
analysis_cnbc <- aov(length ~ source, cnbc_tbl)
(f_value_cnbc <- summary(analysis_cnbc)[[1]]$"F value")
(p_value_cnbc <- str_remove(formatC(
  summary(analysis_cnbc)[[1]]$"Pr(>F)"[1], format = 'f', digits=2), "^0"))
  # This gets rid of leading 0 and keeps only 2 digits, but it also
  # turns it into a character object instead of numeric, which isn't ideal.
df_src_cnbc <- summary(analysis_cnbc)[[1]]$"Df"[1]
df_res_cnbc <- summary(analysis_cnbc)[[1]]$"Df"[2]
significance_cnbc <- if(p_value_cnbc>0.05){"was not"}else{"was"}

# Publication
# The results of an ANOVA comparing lengths across sources was F(3, 130) = 1.06, p = .37. This test was statistically significant.

cat(sprintf("The results of an ANOVA comparing lengths across sources was F(%d, %d) = %.2f, p = %s. This test %s statistically significant.", df_src_cnbc, df_res_cnbc, f_value_cnbc, str_remove(p_value_cnbc, "^0"), significance_cnbc))
  # The value for this has changed over the multiple times I've run it
  # due to new and updated data being pulled from the website.