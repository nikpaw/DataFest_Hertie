# import short versions of data sets
firms <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen.csv" # name of file 
  ,n_max = 10000)

firms_hist <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen_hist.csv" # name of file 
  ,n_max = 10000)


firms_inaktiv <- readr::read_csv2(
  file = "~/GitHub/DataFest_2023/Data/firmen_inaktiv.csv" # name of file 
  ,n_max = 10000)

#Cheque the different status for the datasets
unique(firms$wz_code_text) 
unique(firms_hist$wz_code_text)
unique(firms_inaktiv$wz_code_text)


#Unique Firms analysis
# Load the necessary library
library(dplyr)

# Assuming the three datasets are named "firms", "firms_inaktiv", and "firms_hist"
# Create a vector of all the unique Wz Code Text across the three datasets
all_firm_wz_code_text <- unique(c(firms$wz_code_text, firms_inaktiv$wz_code_text, firms_hist$wz_code_text))

# Create a new data frame to store the results
joint <- data.frame(firm_id = all_firm_wz_code_text)

# Add a column for each dataset indicating if the firm_id appears in that dataset or not
joint$firms <- as.numeric(joint$wz_code_text %in% firms$wz_code_text)
joint$firms_inaktiv <- as.numeric(joint$wz_code_text %in% firms_inaktiv$wz_code_text)
joint$firms_hist <- as.numeric(joint$wz_code_text %in% firms_hist$wz_code_text)


