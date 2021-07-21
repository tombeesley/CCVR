library(tidyverse)
library(janitor)

# read in Experiment 1A
fnams <- list.files("CCVR03_A_raw_data/Output data", "data", full.names = TRUE) # needed for reading data
subjs <- list.files("CCVR03_A_raw_data/Output data", "data") # needed for identifying subject numbers
data1a <- NULL

for (subj in 1:length(fnams)) { 
  
  pData <- read_csv(fnams[subj], col_types = cols(Gender = col_character())) # read the data from csv
  pData <- 
    pData %>% 
    mutate(subj = substr(subjs[subj],6,str_length(subjs[subj])-4),
           sub_exp = "1A")
  
  data1a <- rbind(data1a, pData) # combine data array with existing data
  
}

# read in Experiment 1B
fnams <- list.files("CCVR03_B_raw_data/Output data", "data", full.names = TRUE) # needed for reading data
subjs <- list.files("CCVR03_B_raw_data/Output data", "data") # needed for identifying subject numbers
data1b <- NULL

for (subj in 1:length(fnams)) { 
  
  pData <- read_csv(fnams[subj], col_types = cols(Gender = col_character())) # read the data from csv
  pData <- 
    pData %>% 
    mutate(subj = substr(subjs[subj],6,str_length(subjs[subj])-4),
           sub_exp = "1B")
  
  data1b <- rbind(data1b, pData) # combine data array with existing data
  
}

data1b <- 
  data1b %>% 
  clean_names() %>% 
  select(-awareness_type, -c(camera_distance_from_target:fc_response))

# clean data frame
data <- 
  data1a %>% 
  clean_names() %>% 
  bind_rows(data1b) %>% # add in the 1B data
  rename(RT = response_time,
         num_additional_Rs = num_mistakes,
         dist_to_T = distance_from_target) %>%
  mutate(subj = as.numeric(subj)) %>% 
  mutate(subj = if_else(sub_exp == "1A", 
                        true = subj + 100, 
                        false = subj + 200)) #give Ps unique IDs across the two experiments
 

# add phase numbers
phaseNums = c(rep(1,480),rep(2,32))
data %>% 
  group_by(subj) %>% 
  mutate(phase = phaseNums[1:n()]) %>% # note: subj 113 (raw 13 1A) doesn't have 512 trials
  select(sub_exp, subj, age, gender, phase, everything(), -session) %>% 
  write_csv("data_tidy_CCVR03.csv")






