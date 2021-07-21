library(tidyverse)
library(janitor)

# read in Experiment 2
fnams <- list.files("Exp2 data/Output Data/Main_Data", "data", full.names = TRUE) # needed for reading data
subjs <- list.files("Exp2 data/Output Data/Main_Data", "data") # needed for identifying subject numbers
data <- NULL

for (p in 1:length(fnams)) { 
  
  pData <- read_csv(fnams[p], col_types = cols(Gender = col_character())) # read the data from csv
  pData <- pData %>% 
    mutate(subj = substr(subjs[p],6,str_length(subjs[p])-4))
  
  data <- rbind(data, pData) # combine data array with existing data
  
}

data <- data %>% 
  clean_names() %>% 
  mutate(subj = as.numeric(subj),
         exp = 2) %>% 
  select(exp, subj, everything()) %>% 
  rename(RT = response_time,
         num_additional_Rs = num_mistakes,
         dist_to_T = distance_from_target)

# DESIGN OF THE EXPERIMENT
# programming is mainly done in the "CreatePats.m" in the experiment code
# Set 1 - Near target repeated configurations (half pattern repeated, half random)
# Set 2 - Far target repeated configurations (half pattern repeated, half random)
# Set 3 - Near target random configurations
# Set 4 - Far target random configurations

# odd participants: proximal distractors were repeated, distal Ds randomised 
# even participants: distal distractors were repeated, proximal Ds randomised

# Blocks 1:16, 21:36, 41:56, 61:62 - Repeated configurations (sets 1 and 2)
# Blocks 17:20, 37:40, 57:60 - Random configurations (sets 3 and 4)

# NOTE: the original program stuffed up the block numbers, labelling blocks 21:36 as 20:35
# This had no consequence on the presentation of stimuli, but the block numbers are adjusted below.

# add phase numbers
phaseNums = c(rep(1,496),rep(2,32))
blockNums = c(rep(1:62, each = 8),rep(1:2,each = 16))
data %>% 
  group_by(subj) %>% 
  mutate(phase = phaseNums,
         block = blockNums,
         condition = if_else(subj %% 2 == 1, "proximal_repeated", "distal_repeated")) %>% 
  select(exp, subj, age, gender, condition, phase, block, everything()) %>% 
  write_csv("data_tidy_CCVR04.csv")






