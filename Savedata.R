library("parquetize")
library(arrow)
# import lib
library(haven)
library(microbenchmark)
library(dplyr)
library(readr)
library(readstata13)
library(tictoc)
library(data.table)
directory <-"/Users/hhs/Dropbox/Data/Raw/T19_G8_SAS Data"

# List all sas7bdat files in the directory
file_list <- list.files(directory, pattern = "\\.sas7bdat$", full.names = TRUE)

# Initialize an empty list to store data frames
data_list <- list()

# Loop through each file and read the data
for (file in file_list) {
  data <- read_sas(file)  # Read the SAS file
  data_list[[file]] <- data  # Store the data frame in the list
}

# Combine all data frames into one
combined_data <- bind_rows(data_list)

# Save rdata
save(combined_data,file="Temp/timss_8_2019.Rdata")
# Save csv file
write.csv(combined_data, "Temp/timss_8_2019.csv", row.names = FALSE)
# Save Stata file
write_dta(combined_data,"Temp/timss_8_2019.dta")
# Save Parquet file 
write_parquet(combined_data, 'Temp/timss_8_2019.parquet')
# Save json file
# Convert the data frame to JSON
json_output <- toJSON(combined_data, pretty = TRUE)
# Save the JSON output to a file
write(json_output, file = "data.json")
# feather
write_feather(combined_data, 'Temp/timss_8_2019.feather')
# RDS 
saveRDS(combined_data, file = "Temp/timss_8_2019.rds")
