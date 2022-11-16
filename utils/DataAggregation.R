# import and data column definitions --------------------------------------
library(googlesheets4)
library(gsheet)
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
              "hospital_country", "year", "quarter")

# Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this.

numVars_cols <-c(key_cols,numVars,pctCols)
catVars_cols <-c(key_cols,catVars)

# aggregation -------------------------------------------------------------
# add quarterly hospital aggregates of numVars
agg_dataNum <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter, YQ) %>%
  summarise(median = median(Value, na.rm = TRUE),
            numOfDataPoints = sum(!is.na(Value)),
            pct = ifelse(is.nan(mean(Value, na.rm = TRUE)),NA,mean(Value, na.rm = TRUE)*100),
            coverage_pct=sum(!(is.na(Value)))/n()) 
# %>% 
  # pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value")

# add yearly hospital aggregates of numVars
agg_dataNum <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, YQ) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    numOfDataPoints = sum(!is.na(Value)),
    pct = ifelse(is.nan(mean(Value, na.rm = TRUE)),NA,mean(Value, na.rm = TRUE)*100),
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  # pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",
         YQ=NA) %>%
  rbind(agg_dataNum)

# add quarterly country aggregates of numVars
agg_dataNum <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    numOfDataPoints = sum(!is.na(Value)),
    pct = ifelse(is.nan(mean(Value, na.rm = TRUE)),NA,mean(Value, na.rm = TRUE)*100),
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  # pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_dataNum)

# add yearly country aggregates of numVars
agg_dataNum <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year) %>%
  summarise(
    median = median(Value, na.rm = TRUE),
    numOfDataPoints = sum(!is.na(Value)),
    pct = ifelse(is.nan(mean(Value, na.rm = TRUE)),NA,mean(Value, na.rm = TRUE)*100),
    coverage_pct=sum(!(is.na(Value)))/n()) %>%
  # pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",
         hospital_name = "all",
         YQ=NA) %>%
  rbind(agg_dataNum)
  

#set up the grid so we know all the data that should exist and might be missing from the aggregates
timeGrid<-as_tibble(unique(agg_dataNum[,c('year','quarter')]))
hospitalGrid<-as_tibble(unique(agg_dataNum[,c('hospital_country','hospital_name')]) )
NumMeasureGrid<-as_tibble(unique(agg_dataNum[,c('QI')]))
# NumMeasureGrid<-as_tibble(unique(agg_dataNum[,c('QI','agg_function')]))
full.grid<-  timeGrid %>% 
  merge(hospitalGrid) %>% 
  merge(NumMeasureGrid) %>% 
  mutate(YQ=ifelse(quarter=="all",NA,paste(year, quarter)))

# creating full grid that includes all measures reported and those missing with NA
agg_dataNum<-left_join(full.grid,agg_dataNum)

#merge in the angel awards thresholds and mark YearAggregates
agg_dataNum<-angel_awards %>% 
  select(nameOfAggr,gold,platinum, diamond) %>% 
  rename(QI=nameOfAggr) %>% 
  right_join(agg_dataNum) %>%
  mutate(isKPI=ifelse(QI %in% pctCols,TRUE,FALSE),
         isYearAgg=ifelse(is.na(YQ),TRUE,FALSE),
         isCountryAgg=ifelse(hospital_name=="all",TRUE,FALSE)
         ) %>%
  arrange(hospital_country, hospital_name,year,quarter,QI)
  
# adding awards to aggregation data
agg_dataNum <- agg_dataNum %>% 
  filter(isKPI) %>%
  mutate(angelAwardLevel=awardHandler_v(pct, gold, platinum, diamond)) %>%
  right_join(agg_dataNum)

# adding national comparisons to aggregation data
agg_dataNum<- agg_dataNum %>% 
  filter(isCountryAgg, isKPI) %>%
  select(hospital_country, QI, year,quarter,median) %>% 
  rename("CountryMedian"=median) %>% 
  right_join(agg_dataNum) %>%
  mutate(MedianAsAsGoodOrBetterThanCountry=ifelse(median>=CountryMedian,1,0))

#remove duplicate rows
agg_dataNum <- unique(agg_dataNum) %>%
  arrange(hospital_country, hospital_name,year,quarter,QI)


agg_dataNum <- agg_dataNum %>% 
  pivot_wider(names_from = angelAwardLevel,
              names_glue = "qualifiesFor{angelAwardLevel}",
              values_from =angelAwardLevel,
              values_fn = list(angelAwardLevel = ~ 1), values_fill = list(angelAwardLevel = 0)) 


# add temporally derived data - first time above thresholds
agg_dataNum<-  agg_dataNum %>%
  arrange(hospital_country, hospital_name,year,quarter,QI) %>%
  group_by(hospital_country, hospital_name,year,quarter,QI) %>%
  mutate(CSoAboveCountry = cumsum(ifelse(is.na(MedianAsAsGoodOrBetterThanCountry), 0, MedianAsAsGoodOrBetterThanCountry)),
         CSoAboveDiamond = cumsum(qualifiesForDiamond),
         CSoAbovePlatinum = cumsum(qualifiesForPlatinum) + CSoAboveDiamond,
         CSoAboveGold = cumsum(qualifiesForGold) + CSoAbovePlatinum,
         isFirstTimeAsGoodOrBetterThanCountry = ifelse(CSoAboveCountry==1 & MedianAsAsGoodOrBetterThanCountry==1,1,0),
         isFirstTimeGold = ifelse(CSoAboveGold==1 & qualifiesForGold==1,1,0),
         isFirstTimePlatinum = ifelse(CSoAbovePlatinum==1 & qualifiesForPlatinum==1,1,0),
         isFirstTimeDiamond = ifelse(CSoAboveDiamond==1 & qualifiesForDiamond==1,1,0),
         ) 


# #remove all irrelevant combinations 
# agg_dataNum <- agg_dataNum %>%
#   filter((QI %in% pctCols & agg_function=='pct') | 
#            (QI %in% numVars  & (agg_function=='median'|agg_function=='coverage_pct'))| 
#            (QI %in% catVars))


agg_dataCat <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>% 
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter, YQ, ) %>%
  mutate(Totnumber_of_cases = sum(!is.na(Value))) %>%
  group_by(Value, add=TRUE) %>%
  summarise(percent = ifelse(sum(!is.na(Value))==0, NA, sum(!is.na(Value)) / sum(Totnumber_of_cases))) %>%
  rename(subgroup = Value) %>% View()
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value")

agg_dataCat <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, Value) %>%
  summarise (number_of_cases = sum(!is.na(Value))) %>%
  mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all",
         YQ=NA) %>%
  rbind(agg_dataCat)


agg_dataCat <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, Value) %>%
  summarise (number_of_cases = sum(!is.na(Value))) %>%
  mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all", 
         hospital_name = "all",
         YQ=NA) %>%
  rbind(agg_dataCat)

agg_dataCat <- dataset[, catVars_cols] %>%
  mutate(across(catVars, as.character)) %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter, Value) %>%
  summarise (number_of_cases = sum(!is.na(Value))) %>%
  mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
  rename(subgroup = Value) %>%
  pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_dataCat)


CatMeasureGrid<-as_tibble(unique(agg_dataCat[,c('QI','agg_function')]) )
full.gridCat<-  timeGrid %>% 
  merge(hospitalGrid) %>% 
  merge(CatMeasureGrid) %>% 
  mutate(YQ=ifelse(quarter=="all",NA,paste(year, quarter)))

agg_dataCat<-left_join(full.gridCat,agg_dataCat)
agg_dataCat <- unique(agg_dataCat)


options("scipen"=999)

# plotting a derived measure (quarterly median DNT for one hospital) ------

agg_dataNum %>%
  filter(hospital_name == "Samaritan Hospital", QI == "door_to_needle", !is.na(YQ),) %>%
  ggplot(aes(x=YQ,y=median,group=1)) +
  geom_line() +
  geom_point(aes(size=numOfDataPoints))


# todos for students
# not requested by students> last4Quarter values instead of year/quarter, 

# # show only one specific hospital - reducing the rows in the dataset for debugging. 
# agg_dataNum<-agg_dataNum %>% filter(hospital_name == "Progress Center")
# agg_dataCat<-agg_dataCat %>% filter(hospital_name == "Progress Center")

# #REMOVE means for standard numerical vars and medians for the percentages
# agg_data <- agg_data %>%
#   filter((QI %in% pctCols & agg_function=='pct') | 
#            (QI %in% numVars  & (agg_function=='median'|agg_function=='median' ))| 
#            (QI %in% catVars))


