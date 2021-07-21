library(tidyverse)
library(janitor)

max_Resp_allowed <- 1

fnams <- list.files("CSV Data", "data", full.names = TRUE) # needed for reading data
subjs <- list.files("CSV Data", "data") # needed for identifying subject numbers

data <- NULL
for (p in 1:length(fnams)) { 
  
  pData <- read_csv(fnams[p], col_types = cols(Gender = col_character()), col_names = TRUE) # read the data from csv
  pData <- pData %>% 
    mutate(subj = as.numeric(substr(subjs[p],6,str_length(subjs[p])-4))) %>% 
    select(subj,everything())
  
  data <- rbind(data, pData) # combine data array with existing data
  
}

# tidy the data and split into different sets
data <- data %>% 
  clean_names() %>% 
  mutate(subj = as.numeric(subj),
         exp = 3) %>% 
  select(exp, subj, everything()) %>% 
  rename(RT = response_time,
         num_additional_Rs = num_mistakes,
         dist_to_T = distance_from_target)

# mark main and awareness phases
phaseNums = c(rep(1,288),rep(2,32))

data %>% 
  group_by(subj) %>% 
  mutate(phase = phaseNums) %>% 
  select(exp, subj, age, gender, block, everything()) %>% 
  write_csv("data_tidy_CCVR05.csv")


