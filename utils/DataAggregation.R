# import and data column definitions --------------------------------------
library(tidyverse)
source("utils/data_structures.R")
dataset <- tibble::as_tibble(read.csv("data/dataREanonymized.csv"))
#convert all empty strings to NA
dataset[dataset == ""] <- NA
#convert all columns based on boolean/logical values from char to logical
to.conv <- sapply(dataset, function(x) all(x %in% c("False", "True", NA)))
dataset[,to.conv] <- sapply(dataset[,to.conv], as.logical)

#computations need to be verified with ICRC

dataset <- dataset %>% 
  mutate(
    dnt_leq_60 = ifelse(stroke_type=='ischemic' & thrombolysis == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_needle>60,0,1) ,NA),
    dnt_leq_45 = ifelse(stroke_type=='ischemic' & thrombolysis == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_needle>45,0,1) ,NA),
    dgt_leq_120= ifelse(stroke_type=='ischemic' & thrombectomy == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_groin>120,0,1), NA),
    dgt_leq_90 = ifelse(stroke_type=='ischemic' & thrombectomy == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_groin> 90,0,1) ,NA),
    rec_total_is=ifelse(stroke_type=='ischemic', ifelse(thrombolysis== T,1,0) ,NA),
    mri_first_hosp= ifelse(first_hospital==T, ifelse(imaging_done==T,1,0),NA),
    isp_dis_antiplat = ifelse(discharge_destination!='dead',ifelse(discharge_any_antiplatelet==T,1,0),NA),
    af_p_dis_anticoag = ifelse(discharge_destination!='dead',ifelse(discharge_any_anticoagulant==T,1,0),NA),
    sp_hosp_stroke_unit_ICU = ifelse(hospitalized_in=='ICU/stroke unit',1,0)
    # dysphagia_screening=ifelse(post_acute_care == 'yes' & stroke_type %in% c('ischemic','transient ischemic','intracerebral hemorrhage', 'undetermined'),NA)
    )



# "","p_dys_screen", "%in% c('GUSS','water test','other', 'ASSIST')" , 80, 85, 90, "post_acute_care == 'yes' & stroke_type %in% c('ischemic','transient ischemic','intracerebral hemorrhage', 'undetermined')",



#sf
#set fantasy hospital names
hospital_Names <- c("Progress Center", "Paradise Clinic", "Angelvale Clinic", "Memorial Hospital", "Rose Clinic", "General Hospital", "Mercy Center", "Hope Hospital", "Samaritan Hospital")
dataset$site_name <- as.factor(dataset$site_name)
levels(dataset$site_name) <- hospital_Names

#set fantasy country names
country_names <- c("Far far away", "Neverland", "Over the rainbow")
dataset$site_country <- as.factor(dataset$site_country)
levels(dataset$site_country) <- country_names

#setting some convenience names for analysis/readability, still compatible with older Code in the dashboard 
dataset <- dataset %>%
  mutate(patient_id = subject_id, hospital = site_id, hospital_name = site_name, hospital_country = site_country, year = discharge_year, quarter = discharge_quarter) %>%
  mutate(YQ = paste(year, quarter)) %>%
  relocate(all_of(key_cols), .before = where(is.character)) %>%
  #       relocate(c(year,quarter,YQ), .after = country)
  filter(discharge_year > 2000 & discharge_year <= as.integer(format(Sys.Date(), "%Y")))

key_cols <- c(key_cols, "patient_id", "hospital", "hospital_name",
              "hospital_country", "year", "quarter","YQ")

# Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this.

numVars_cols <-c(key_cols,numVars,pctCols)
catVars_cols <-c(key_cols,catVars)

# aggregation -------------------------------------------------------------
agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter, YQ) %>%
  summarise(median = median(Value, na.rm = TRUE),
            pct = mean(Value, na.rm = TRUE)*100,
            coverage_pct=sum(!(is.na(Value)))/n()) %>% 
  pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value")

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, YQ) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    pct = mean(Value, na.rm = TRUE)*100,
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    pct = mean(Value, na.rm = TRUE)*100,
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    pct = mean(Value, na.rm = TRUE)*100,
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",hospital_name = "all") %>%
  rbind(agg_data) %>%
  mutate(subgroup=NA)


agg_data <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter, YQ, Value) %>%
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

#REMOVE means for standard numerica vars and medians for the percentages
agg_data <- agg_data %>%
  filter((QI %in% pctCols & agg_function=='pct') | 
           (QI %in% numVars  & (agg_function=='median'|agg_function=='median' ))| 
           (QI %in% catVars))

# agg_data <- 
#   agg_data %>% 
#   filter



# todo
# AngelThresholds - define dnt_leq_60 etc. 
# first time above (angel/national/own) threshold 
# last4Quarter values instead of year/quarter, 
# dataset %>% .[.$YQ=="2022 Q1",]   SUM_IF

options("scipen"=999)

# show only one specific hospital - reducing the rows in the dataset for debugging. 
# agg_data<-agg_data %>% filter(hospital_name == "Progress Center")


cond_dataset<-dataset%>% 
  select(unique(aa_cols)) %>%
  pivot_longer(aa_cols, names_to="QI", values_to="Value")

# right_join with angel awards by QI 
cond_dataset <- cond_dataset %>%
  pivot_longer(-aa_cols, names_to = "QI") %>%
  right_join(angel_awards, by="QI") %>%
  group_by(nameOfAggr) 
#summarize(val )

agg_data<-agg_data %>% 
  filter(hospital_name == "Progress Center", agg_function == "percent") %>%
  mutate(YQ = paste(year, quarter)) %>%
  relocate(c(hospital_name,YQ), .after=hospital_country)

awardHandler_v <- Vectorize(awardHandler)

award_given_data<-agg_data %>% 
  merge(angel_awards,by = "QI") %>%
  mutate(award_given = awardHandler_v(Value*100, gold, platinum, diamond))

cond<-award_given_data%>%right_join(dataset,by="QI")

cond<-angel_awards%>%filter(eval(parse(text=cond)))


#%>% select(hospital_country,hospital_name,year,quarter, YQ, QI, subgroup,agg_function,nameOfAggr,Value,award_given)

# condx=
# dataset %>% filter(eval(parse(text=condx)))


#
# trend from last 4quarters, 
# trend since beginning
# abstract away through a function the above agg_data sequence
# agg_data <- add.aggNum(dataset, aggdata, groupby=c('QI, hospital_country, year, quarter, Value'))
# agg_data <- add.aggCat(dataset, aggdata, groupby=c('QI, hospital_country, year, quarter, Value'))

  

# agg_data2 <- agg_data %>% ungroup() %>% expand(hospital_country, hospital_name, year, quarter,QI,agg_function)

# measures <- unique(agg_data[,c('QI','subgroup','agg_function')])
# timePlaces<-unique(agg_data[,c('hospital_country','hospital_name','year','quarter')])
# agg_allCombos<-full_join(timePlaces,measures,by=character())
# agg_data3 <- left_join(agg_allCombos,agg_data)

# plotting a derived measure (quarterly median DNT for one hospital) ------

# agg_data %>% 
#   filter(hospital_name == "Samaritan Hospital", QI == "door_to_needle", !is.na(YQ)) %>%
#   ggplot(plot_data, aes(x=YQ,y=median,group=1)) +
#   geom_line() +
#   geom_point()
# 
# fig

