# import and data column definitions --------------------------------------
library(googlesheets4)
library(gsheet)
library(tidyverse)
source("utils/data_structures.R")
dataset <- tibble::as_tibble(read.csv("data/dataREanonymized.csv"))

# convert all empty strings to NA
dataset[dataset == ""] <- NA
# convert all columns based on boolean/logical values from char to logical
to.conv <- sapply(dataset, function(x) all(x %in% c("False", "True", NA)))
dataset[, to.conv] <- sapply(dataset[, to.conv], as.logical)




# set fantasy hospital names
hospital_Names <- c("Progress", "Paradise", "Angelvale", "Memorial", "Rose", "General", "Mercy", "Hope", "Samaritan")
dataset$site_name <- as.factor(dataset$site_name)
levels(dataset$site_name) <- hospital_Names

# set fantasy country names
country_names <- c("Far away", "Neverland", "Over rainbow")
dataset$site_country <- as.factor(dataset$site_country)
levels(dataset$site_country) <- country_names


# setting some convenience names for analysis/readability, still compatible with older Code in the dashboard
dataset <- dataset %>%
  mutate(patient_id = subject_id, hospital = site_id, h_name = site_name, h_country = site_country, year = discharge_year, quarter = discharge_quarter) %>%
  mutate(YQ = paste(year, quarter)) %>%
  relocate(all_of(key_cols), .before = where(is.character)) %>%
  #subset for debugging
  #filter (h_name=="General", year==2018, quarter=="Q1") %>%
    #       relocate(c(year,quarter,YQ), .after = country)
  filter(discharge_year > 2000 & discharge_year <= as.integer(format(Sys.Date(), "%Y")))

key_cols <- c(
  key_cols, "patient_id", "hospital", "h_name",
  "h_country", "year", "quarter"
)

keep_cols <- c(key_cols, "door_to_needle", "gender", "stroke_type", "prenotification", "imaging_done", "thrombolysis", "hospital_stroke", "first_hospital", "dnt_missing", "dnt_leq_60", "dnt_leq_45")
ctrl_cols <- c("gender", "stroke_type", "prenotification", "imaging_done", "thrombolysis", "hospital_stroke", "first_hospital")


# computations need to be verified with ICRC

dataset <- dataset %>%
  mutate(
    dnt_missing = ifelse(stroke_type == "ischemic" & thrombolysis == T & hospital_stroke != T & first_hospital == T, ifelse(!is.na(door_to_needle), 0, 1), NA),
    dnt_leq_60 = ifelse(stroke_type == "ischemic" & thrombolysis == T & hospital_stroke != T & first_hospital == T, ifelse(door_to_needle > 60, 0, 1), NA),
    dnt_leq_45 = ifelse(stroke_type == "ischemic" & thrombolysis == T & hospital_stroke != T & first_hospital == T, ifelse(door_to_needle > 45, 0, 1), NA)
    # dgt_leq_120= ifelse(stroke_type=='ischemic' & thrombectomy == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_groin>120,0,1), NA),
    # dgt_leq_90 = ifelse(stroke_type=='ischemic' & thrombectomy == T & hospital_stroke != T & first_hospital == T,ifelse(door_to_groin> 90,0,1) ,NA),
    # rec_total_is=ifelse(stroke_type=='ischemic', ifelse(thrombolysis== T,1,0) ,NA),
    # mri_first_hosp= ifelse(first_hospital==T, ifelse(imaging_done==T,1,0),NA),
    # isp_dis_antiplat = ifelse(discharge_destination!='dead',ifelse(discharge_any_antiplatelet==T,1,0),NA),
    # af_p_dis_anticoag = ifelse(discharge_destination!='dead',ifelse(discharge_any_anticoagulant==T,1,0),NA),
    # sp_hosp_stroke_unit_ICU = ifelse(hospitalized_in=='ICU/stroke unit',1,0)
    # dysphagia_screening=ifelse(post_acute_care == 'yes' & stroke_type %in% c('ischemic','transient ischemic','intracerebral hemorrhage', 'undetermined'),NA)
  )

# simplify for students to have fewer columns to work with
numVars <- intersect(keep_cols, numVars)
catVars <- intersect(keep_cols, catVars)
pctCols <- intersect(keep_cols, pctCols)
dataset <- dataset %>% select(c(keep_cols))


# Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this.
numVars_cols <- c(key_cols, numVars)
catVars_cols <- c(key_cols, catVars)

# NA conditions for missing data
angel_conds <- angel_awards %>%
  select(QI, cond, aggCond, nameOfAggr, isAngelKPI) %>%
  unique()

agg_conds <- angel_conds %>%
  select(QI, cond, aggCond) %>%
  unique() %>%
  mutate(nameOfAggr = QI)
#? is rbind part of pipe? 
#rbind(angel_conds)

eval_vec <- Vectorize(eval.parent, vectorize.args = "expr")

# merge data with conditions and derive variables
df <- dataset[, c(numVars_cols, ctrl_cols)] %>%
  pivot_longer(-c(key_cols, ctrl_cols), names_to = "QI", values_to = "Value") %>%
  left_join(angel_conds) %>%
  mutate(
    Val2agg = ifelse(eval(parse(text = cond)),
      ifelse(isAngelKPI == FALSE,
        Value,
        ifelse(eval_vec(parse(text = paste(Value, aggCond))),
          1, 0
        )
      ),
      NA
    ),
    isMissingData = ifelse(is.na(Value) & eval(parse(text = cond)), 1, 0),
    aggFunc = ifelse(isAngelKPI, "pct", "median")
  )

# aggregation -------------------------------------------------------------
# add quarterly hospital aggregates of numVars (currently only DNT)
agg_dataNum <- df %>%
  group_by(QI, nameOfAggr, h_country, h_name, year, quarter, YQ, isAngelKPI, aggFunc) %>%
  summarise(
    Value = ifelse(first(isAngelKPI) == FALSE,
      median(Val2agg, na.rm = TRUE),
      ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
    ),
    data_Pts = sum(!is.na(Val2agg)),
    data_missing = sum(isMissingData)
  )
# %>%
#  # pivot_longer(cols = median:coverage_pct, names_to = "agg_function", values_to = "Value")
# createAggsT <- function(df, colName){
#   df %>% select(QI, nameOfAggr, colName) %>% dplyr::group_by(nameOfAggr, colName)%>% rename( gg=colName) %>% mutate(xyz=colName) %>% View()
# }


# add yearly hospital aggregates of numVars
agg_dataNum <- df %>%
  left_join(angel_conds) %>%
  group_by(QI, nameOfAggr, h_country, h_name, year, isAngelKPI, aggFunc) %>%
  summarise(
    Value = ifelse(first(isAngelKPI) == FALSE,
      median(Val2agg, na.rm = TRUE),
      ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
    ),
    data_Pts = sum(!is.na(Val2agg)),
    data_missing = sum(isMissingData)
  ) %>%
  mutate(
    quarter = "all",
    YQ = as.character(year)
  ) %>%
  rbind(agg_dataNum)

# add quarterly country aggregates of numVars
agg_dataNum <- df %>%
  left_join(angel_conds) %>%
  group_by(QI, nameOfAggr, h_country, year, quarter, isAngelKPI, aggFunc) %>%
  summarise(
    Value = ifelse(first(isAngelKPI) == FALSE,
      median(Val2agg, na.rm = TRUE),
      ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
    ),
    data_Pts = sum(!is.na(Val2agg)),
    data_missing = sum(isMissingData)
  ) %>%
  mutate(
    h_name = "all",
    YQ = paste(year, quarter)
  ) %>%
  rbind(agg_dataNum)

# add yearly country aggregates of numVars
agg_dataNum <- df %>%
  left_join(angel_conds) %>%
  group_by(QI, nameOfAggr, h_country, year, isAngelKPI, aggFunc) %>%
  summarise(
    Value = ifelse(first(isAngelKPI) == FALSE,
      median(Val2agg, na.rm = TRUE),
      ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
    ),
    data_Pts = sum(!is.na(Val2agg)),
    data_missing = sum(isMissingData)
  ) %>%
  mutate(
    quarter = "all",
    h_name = "all",
    YQ = as.character(year)
  ) %>%
  rbind(agg_dataNum)

agg_dataNum <- agg_dataNum %>%
  mutate(
    isKPI = ifelse(QI %in% KPIs, TRUE, FALSE),
    pct_missing = ifelse(data_Pts == 0, 0, round(data_missing / (data_missing + data_Pts) * 100, 1)),
    subGroupVal = NA,
    subGroup = NA
  )

# sub-analysis function --------------------------------------------------

createAggs <- function(df, colName) {
  agg_data <- df %>%
    group_by(QI, nameOfAggr, h_country, h_name, year, quarter, YQ, isAngelKPI, aggFunc, !!sym(colName)) %>%
    summarise(
      Value = ifelse(first(isAngelKPI) == FALSE,
        median(Val2agg, na.rm = TRUE),
        ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
      ),
      data_Pts = sum(!is.na(Val2agg)),
      data_missing = sum(isMissingData)
    ) %>%
    rename(subGroupVal = colName) %>%
    mutate(subGroup = colName)

  # add yearly hospital aggregates of numVars
  agg_data <- df %>%
    left_join(angel_conds) %>%
    group_by(QI, nameOfAggr, h_country, h_name, year, isAngelKPI, aggFunc, !!sym(colName)) %>%
    summarise(
      Value = ifelse(first(isAngelKPI) == FALSE,
        median(Val2agg, na.rm = TRUE),
        ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
      ),
      data_Pts = sum(!is.na(Val2agg)),
      data_missing = sum(isMissingData)
    ) %>%
    mutate(
      quarter = "all",
      YQ = as.character(year)
    ) %>%
    rename(subGroupVal = colName) %>%
    mutate(subGroup = colName) %>%
    rbind(agg_data)

  # add quarterly country aggregates of numVars
  agg_data <- df %>%
    left_join(angel_conds) %>%
    group_by(QI, nameOfAggr, h_country, year, quarter, isAngelKPI, aggFunc, !!sym(colName)) %>%
    summarise(
      Value = ifelse(first(isAngelKPI) == FALSE,
        median(Val2agg, na.rm = TRUE),
        ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
      ),
      data_Pts = sum(!is.na(Val2agg)),
      data_missing = sum(isMissingData)
    ) %>%
    mutate(
      h_name = "all",
      YQ = paste(year, quarter)
    ) %>%
    rename(subGroupVal = colName) %>%
    mutate(subGroup = colName) %>%
    rbind(agg_data)

  # add yearly country aggregates of numVars
  agg_data <- df %>%
    left_join(angel_conds) %>%
    group_by(QI, nameOfAggr, h_country, year, isAngelKPI, aggFunc, !!sym(colName)) %>%
    summarise(
      Value = ifelse(first(isAngelKPI) == FALSE,
        median(Val2agg, na.rm = TRUE),
        ifelse(is.nan(mean(Val2agg, na.rm = TRUE)),NA,round(mean(Val2agg, na.rm = TRUE) * 100, 1))
      ),
      # median = median(Value, na.rm = TRUE),
      data_Pts = sum(!is.na(Val2agg)),
      data_missing = sum(isMissingData)
    ) %>%
    mutate(
      quarter = "all",
      h_name = "all",
      YQ = as.character(year)
    ) %>%
    rename(subGroupVal = colName) %>%
    mutate(subGroup = colName) %>%
    rbind(agg_data)

  agg_data <- agg_data %>%
    mutate(
      isKPI = ifelse(QI %in% KPIs, TRUE, FALSE),
      pct_missing = ifelse(data_Pts == 0, 0, round(data_missing / (data_missing + data_Pts) * 100, 1))
    )

  return(agg_data)
}



#agg_dataNum <- rbind(agg_dataNum, createAggs(df, "first_hospital"))
agg_dataNum <- rbind(agg_dataNum, createAggs(df, "prenotification"))
agg_dataNum <- rbind(agg_dataNum, createAggs(df, "imaging_done"))

agg_dataNum$subGroupVal <- as.character(agg_dataNum$subGroupVal)

agg_dataNum <- rbind(agg_dataNum, createAggs(df, "stroke_type"))
agg_dataNum <- rbind(agg_dataNum, createAggs(df, "gender"))


# set up the grid so we know all the data that should exist and might be missing from the aggregates
timeGrid <- as_tibble(unique(agg_dataNum[, c("year", "quarter")]))
hospitalGrid <- as_tibble(unique(agg_dataNum[, c("h_country", "h_name")]))
NumMeasureGrid <- as_tibble(unique(agg_dataNum[, c("QI")]))
# NumMeasureGrid<-as_tibble(unique(agg_dataNum[,c('QI','agg_function')]))
full.grid <- timeGrid %>%
  merge(hospitalGrid) %>%
  merge(NumMeasureGrid) %>%
  mutate(YQ = ifelse(quarter == "all", as.character(year), paste(year, quarter))) %>%
  unique()

# creating full grid that includes all measures reported and those missing with NA
agg_dataNum <- left_join(full.grid, agg_dataNum)

# merge in the angel awards thresholds and mark YearAggregates
agg_dataNum <- angel_awards %>%
  filter(isAngelKPI) %>%
  select(nameOfAggr, gold, platinum, diamond) %>%
# rename(QI = nameOfAggr) %>%
  right_join(agg_dataNum) %>%
  mutate(
    isYearAgg = ifelse(quarter == "all", TRUE, FALSE),
    isCountryAgg = ifelse(h_name == "all", TRUE, FALSE)
  ) %>%
  arrange(h_country, h_name, year, quarter, QI)

# adding awards to aggregation data
agg_dataNum <- agg_dataNum %>%
  filter(isAngelKPI) %>%
  mutate(angelAwardLevel = awardHandler_v(Value, gold, platinum, diamond)) %>%
  right_join(agg_dataNum)

agg_dataNum <- agg_dataNum %>%
  pivot_wider(
    names_from = angelAwardLevel,
    names_glue = "qual4{angelAwardLevel}",
    values_from = angelAwardLevel,
    values_fn = list(angelAwardLevel = ~1), values_fill = list(angelAwardLevel = 0)
  ) %>%
  select(-c(gold, platinum, diamond))

# adding national comparisons to aggregation data
agg_dataNum <- agg_dataNum %>%
  filter(isCountryAgg == T, isKPI == T) %>%
  select(h_country, nameOfAggr, year, quarter, subGroup, subGroupVal, Value) %>%
  rename("C_Value" = Value) %>%
  right_join(agg_dataNum) %>%
  mutate(
    MedianGeg_C = ifelse(Value >= C_Value, 1, 0),
    diffFromC = Value - C_Value
  )

# remove duplicate rows
agg_dataNum <- unique(agg_dataNum) %>%
  arrange(h_country, h_name, year, quarter, QI)

# add temporally derived data - first time above thresholds
agg_dataNum <- agg_dataNum %>%
  arrange(h_country, h_name, year, quarter, QI) %>%
  group_by(h_country, h_name, year, quarter, QI) %>%
  mutate(
    # qual4Diamond = NA,
    # qual4Platinum = NA,
    # qual4Gold = NA,
    CSoAboveCountry = cumsum(ifelse(is.na(MedianGeg_C), 0, MedianGeg_C)),
    CSoAboveDiamond = cumsum(qual4Diamond),
    CSoAbovePlatinum = cumsum(qual4Platinum) + CSoAboveDiamond,
    CSoAboveGold = cumsum(qual4Gold) + CSoAbovePlatinum,
    is1stgeqC = ifelse(CSoAboveCountry == 1 & MedianGeg_C == 1, 1, 0),
    is1stGold = ifelse(CSoAboveGold == 1 & qual4Gold == 1, 1, 0),
    is1stPlat = ifelse(CSoAbovePlatinum == 1 & qual4Platinum == 1, 1, 0),
    is1stDiam = ifelse(CSoAboveDiamond == 1 & qual4Diamond == 1, 1, 0),
  )

options("scipen" = 999)

# plotting a derived measure (quarterly median DNT for one hospital) ------

# preparing data for plotting
# test
dfx <- agg_dataNum

dfx<-agg_dataNum%>%
  filter(isYearAgg == FALSE, isAngelKPI == TRUE,
         h_name == "General", nameOfAggr == "dnt_leq_45", is.na(subGroup),
         !is.na(YQ)) %>%
  ggplot(aes(x = YQ, y = Value, group = 1)) + 
  geom_line(color="steelblue") +
  geom_line(aes(y=C_Value),color="darkred") + 
  geom_point(aes(size=data_Pts,color=is1stDiam>0)) + 
  scale_colour_manual(name = '1st above D > 0', values = setNames(c('green','black'),c(T, F)))

dfx
    

# #remove all irrelevant combinations
# agg_dataNum <- agg_dataNum %>%
#   filter((QI %in% pctCols & agg_function=='pct') |
#            (QI %in% numVars  & (agg_function=='median'|agg_function=='coverage_pct'))|
#            (QI %in% catVars))


# agg_dataCat <- dataset[, catVars_cols] %>%
#   mutate(across(catVars, as.character)) %>%
#   pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
#   group_by(QI, h_country, h_name, year, quarter, YQ, ) %>%
#   mutate(Totnumber_of_cases = sum(!is.na(Value))) %>%
#   group_by(Value, add=TRUE) %>%
#   summarise(percent = ifelse(sum(!is.na(Value))==0, NA, sum(!is.na(Value)) / sum(Totnumber_of_cases))) %>%
#   rename(subgroup = Value) %>%
#   pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value")
#
# agg_dataCat <- dataset[, catVars_cols] %>%
#   mutate(across(catVars, as.character)) %>%
#   pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
#   group_by(QI, h_country, h_name, year, Value) %>%
#   summarise (number_of_cases = sum(!is.na(Value))) %>%
#   mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
#   rename(subgroup = Value) %>%
#   pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
#   mutate(quarter = "all",
#          YQ=NA) %>%
#   rbind(agg_dataCat)
#
#
# agg_dataCat <- dataset[, catVars_cols] %>%
#   mutate(across(catVars, as.character)) %>%
#   pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
#   group_by(QI, h_country, h_name, year, Value) %>%
#   summarise (number_of_cases = sum(!is.na(Value))) %>%
#   mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
#   rename(subgroup = Value) %>%
#   pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
#   mutate(quarter = "all",
#          h_name = "all",
#          YQ=NA) %>%
#   rbind(agg_dataCat)
#
# agg_dataCat <- dataset[, catVars_cols] %>%
#   mutate(across(catVars, as.character)) %>%
#   pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
#   group_by(QI, h_country, year, quarter, Value) %>%
#   summarise (number_of_cases = sum(!is.na(Value))) %>%
#   mutate(percent = ifelse(sum(number_of_cases)==0, NA, number_of_cases / sum(number_of_cases))) %>%
#   rename(subgroup = Value) %>%
#   pivot_longer(cols = number_of_cases:percent, names_to = "agg_function", values_to = "Value") %>%
#   mutate(h_name = "all") %>%
#   rbind(agg_dataCat)
#
#
# CatMeasureGrid<-as_tibble(unique(agg_dataCat[,c('QI','agg_function')]) )
# full.gridCat<-  timeGrid %>%
#   merge(hospitalGrid) %>%
#   merge(CatMeasureGrid) %>%
#   mutate(YQ=ifelse(quarter=="all",NA,paste(year, quarter)))
#
# agg_dataCat<-left_join(full.gridCat,agg_dataCat)
# agg_dataCat <- unique(agg_dataCat)




# todos for students
# not requested by students> last4Quarter values instead of year/quarter,

# # show only one specific hospital - reducing the rows in the dataset for debugging.
# agg_dataNum<-agg_dataNum %>% filter(h_name == "Progress Center")
# agg_dataCat<-agg_dataCat %>% filter(h_name == "Progress Center")

# #REMOVE means for standard numerical vars and medians for the percentages
# agg_data <- agg_data %>%
#   filter((QI %in% pctCols & agg_function=='pct') |
#            (QI %in% numVars  & (agg_function=='median'|agg_function=='median' ))|
#            (QI %in% catVars))
