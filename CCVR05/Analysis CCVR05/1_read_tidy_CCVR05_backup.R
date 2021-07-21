library(tidyverse)
library(janitor)

max_Resp_allowed <- 1

fnams <- list.files("CSV Data", "data", full.names = TRUE) # needed for reading data
subjs <- list.files("CSV Data", "data") # needed for identifying subject numbers

rawData <- NULL
for (subj in 1:length(fnams)) { 
  
  pData <- read_csv(fnams[subj], col_types = cols(Gender = col_character()), col_names = TRUE) # read the data from csv
  pData <- pData %>% 
    mutate(p_num = as.numeric(substr(subjs[subj],6,str_length(subjs[subj])-4))) %>% 
    select(p_num,everything())
  
  rawData <- rbind(rawData, pData) # combine data array with existing data
  
}

# tidy the data and split into different sets
rawData <- janitor::clean_names(rawData)

rawData %>%
  filter(set>=7, !p_num == 34) %>% # p34 had awareness missing
  mutate(set = recode(set, "7"="rep_NT","8"="rep_FT","9"="new_NT","10"="new_FT")) %>% 
  write.csv("data_tidy_awareness_CCVR05.csv")


# process the main dataframe for stages 1 and 2 
rawData %>% 
  filter(set<=6) %>% 
  mutate(set = recode(set, "1" = "rep_NT","2"="rep_FT","3"="rep_NT",
                      "4"="rep_FT","5"="rand_NT","6"="rand_FT"),
         epoch = ceiling(block/2)) %>%
  select(p_num:session, epoch, everything()) %>% 
  write_csv("data_tidy_main_CCVR05.csv")


