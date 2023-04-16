# load libraries/packages

library(dplyr)
library(rvest)
library(readxl)
library(gdata)
library(httr)

# import short versions of data sets provided by datafest
firms <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen.csv", # name of file
  n_max = 10000)

firms_hist <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen_hist.csv", # name of file
  n_max = 10000)


firms_inaktiv <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen_inaktiv.csv", # name of file
  n_max = 10000)


pers <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/personen.csv", # name of file
  n_max = 10000)


pers_hist <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/personen_hist.csv", # name of file
  n_max = 10000)


rel_firm_firm <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/relationen_firma_firma.csv", 
  n_max = 10000)


rel_firm_firm_hist <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/relationen_firma_firma_hist.csv",
  n_max = 10000)

rel_pers_firm <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/relationen_person_firma.csv", 
  n_max = 10000)

rel_pers_firm_hist <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/relationen_person_firma_hist.csv",
  n_max = 10000)

# create reference: postal codes to "Landkreise"
postal_codes <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/georef-germany-postleitzahl.csv")

filtered_postal_codes <- postal_codes %>%
  filter(`Land name` == "Bayern" | `Land name` == "Baden-Württemberg") %>%
  rename("plz" = "Postleitzahl / Post code") %>%
  rename("kreis_name" = "Kreis name") %>%
  rename("state" = "Land name")

filtered_postal_codes_bawu <- filtered_postal_codes %>% 
  filter(`state` == "Baden-Württemberg")

merged_df <- merge(firms, filtered_postal_codes, by = "plz")

merged_df_bawu <- merged_df %>% 
  filter(`state` == "Baden-Württemberg")


# scraping data on employment from Federal Employment Agency





# Set the URL of the webpage to scrape
url_states <- "https://statistik.arbeitsagentur.de/SiteGlobals/Forms/Suche/Einzelheftsuche_Formular.html?nn=15024&r_f=bl_Baden-Wuerttemberg+bl_Bayern&topic_f=gemeldete-arbeitsstellen"

url <- "https://statistik.arbeitsagentur.de"

# Create a new directory to store the downloaded Excel files
dir.create("my_excel_files")

# Scrape the webpage
page <- read_html(url)

# Find all links on the page
links <- page %>% html_nodes("a") %>% html_attr("href")

# Filter the links to keep only those that point to Excel files
excel_links <- grep("xlsx\\.xlsx", links, value = TRUE)

for (link in excel_links) {
  file_name <- gsub(".*/", "", link)
  full_link <- paste0(url, link) # add the full URL to the link
  download.file(full_link, paste("my_excel_files/", file_name, sep = ""), mode = "wb")
}





## IGNORE BELOW FOR NOW
# merge datasets on firms from firms, firms_hist and merged_data_firms
merged_data_firms_1 <- merge(x = firms, y = firms_hist, by = "firm_id", all = TRUE)
merged_data_firms_2 <- merge(x = merged_data_firms_1, y = firms_inaktiv, by = "firm_id", all = TRUE)


incomplete_firms <- merged_data_firms_2[is.na(merged_data_firms), "firm_id"]
