# import and data column definitions --------------------------------------
source("utils/data_structures.R")

dataset <- as_tibble(read.csv("data/dataREanonymized.csv"))
dataset[dataset == ""] <- NA

#set fantasy hospital names
hospital_Names <- c("Progress Center", "Paradise Clinic", "Angelvale Clinic", "Memorial Hospital", "Rose Clinic", "General Hospital", "Mercy Center", "Hope Hospital", "Samaritan Hospital")
dataset$site_name <- as.factor(dataset$site_name)
levels(dataset$site_name) <- hospital_Names

#set fantasy country names
country_names <- c("Far far away", "Neverland", "Over the rainbow")
dataset$site_country <- as.factor(dataset$site_country)
levels(dataset$site_country) <- country_names

dataset <- dataset %>%
  mutate(patient_id = subject_id, hospital = site_id, hospital_name = site_name, hospital_country = site_country, year = discharge_year, quarter = discharge_quarter) %>%
  mutate(YQ = paste(discharge_year, discharge_quarter)) %>%
  relocate(key_cols, .before = where(is.character)) %>%
  #       relocate(c(year,quarter,YQ), .after = country)
  filter(discharge_year > 2000 & discharge_year <= as.integer(format(Sys.Date(), "%Y")))

key_cols <- c(key_cols, "patient_id", "hospital", "hospital_name", "hospital_country", "year", "quarter")

# Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this.

numVars_cols <-c(key_cols,numVars)
catVars_cols <- c(key_cols,catVars)


# aggregation -------------------------------------------------------------
agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter) %>%
  summarise( median = median(Value, na.rm = TRUE)) 
# %>%
#   pivot_longer(cols = median, names_to = "agg_function", values_to = "Value")

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year) %>%
  summarise(
    median = median(Value, na.rm = TRUE)
  ) %>%
  # pivot_longer(cols = median, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter) %>%
  summarise(
    median = median(Value, na.rm = TRUE)
  ) %>%
  # pivot_longer(cols = median, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year) %>%
  summarise(
    median = median(Value, na.rm = TRUE)
  ) %>%
  # pivot_longer(cols = median, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",hospital_name = "all") %>%
  rbind(agg_data) %>%
  mutate(subgroup=NA)


agg_data <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter, Value) %>%
  summarise (number_of_cases = n()) %>%
  mutate(percent = number_of_cases / sum(number_of_cases)) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  rbind(agg_data)

agg_data <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, Value) %>%
  summarise (number_of_cases = n()) %>%
  mutate(percent = number_of_cases / sum(number_of_cases)) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, Value) %>%
  summarise (number_of_cases = n()) %>%
  mutate(percent = number_of_cases / sum(number_of_cases)) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",hospital_name = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter, Value) %>%
  summarise (number_of_cases = n()) %>%
  mutate(percent = number_of_cases / sum(number_of_cases)) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_data)

# todo
# last4Quarter values instead of year/quarter, 
# first above threshold,  
# trend from last 4quarters, 
# trend since beginning

agg_data <- agg_data  %>% select(hospital_country,hospital_name,year,quarter, QI, subgroup,agg_function,Value)
options("scipen"=999)

# agg_data2 <- agg_data %>% ungroup() %>% expand(hospital_country, hospital_name, year, quarter,QI,agg_function)

# measures <- unique(agg_data[,c('QI','subgroup','agg_function')])
# timePlaces<-unique(agg_data[,c('hospital_country','hospital_name','year','quarter')])
# agg_allCombos<-full_join(timePlaces,measures,by=character())
# agg_data3 <- left_join(agg_allCombos,agg_data)

# condx=
# dataset %>% filter(eval(parse(text=condx)))