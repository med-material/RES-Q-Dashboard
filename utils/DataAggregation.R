# import and data column definitions --------------------------------------
source("utils/data_structures.R")

dataset <- as_tibble(read.csv("data/dataREanonymized.csv"))
dataset[dataset == ""] <- NA
hospital_Names <- c("Progress Center", "Paradise Clinic", "Angelvale Clinic", "Memorial Hospital", "Rose Clinic", "General Hospital", "Mercy Center", "Hope Hospital", "Samaritan Hospital")
country_names <- c("Far far away", "Neverland", "Over the rainbow")

dataset$site_country <- as.factor(dataset$site_country)
dataset$site_name <- as.factor(dataset$site_name)
levels(dataset$site_country) <- country_names
levels(dataset$site_name) <- hospital_Names

key_cols <- c("site_country", "site_name", "site_id", "discharge_year", "discharge_quarter", "YQ", "subject_id")
dataset <- dataset %>%
  mutate(patient_id = subject_id, hospital = site_id, hospital_name = site_name, hospital_country = site_country, year = discharge_year, quarter = discharge_quarter) %>%
  mutate(YQ = paste(discharge_year, discharge_quarter)) %>%
  relocate(key_cols, .before = where(is.character)) %>%
  #       relocate(c(year,quarter,YQ), .after = country)
  filter(discharge_year > 2000 & discharge_year <= as.integer(format(Sys.Date(), "%Y")))

all_quarters <- c("Q1", "Q2", "Q3", "Q4")
all_years <- 2017:2022

key_cols <- c(key_cols, "patient_id", "hospital", "hospital_name", "hospital_country", "year", "quarter")
# Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this.
numVars_cols <- c(
  key_cols, "age", "nihss_score", "door_to_needle", "door_to_groin",
  "door_to_imaging", "onset_to_door", "discharge_nihss_score", "glucose", "cholesterol", "sys_blood_pressure", "prestroke_mrs",
  "dis_blood_pressure", "perfusion_core", "hypoperfusion_core", "bleeding_volume_value"
)

catVars<- c("gender", "hospital_stroke", "hospitalized_in",
  "department_type", "stroke_type", "thrombectomy", "thrombolysis", "no_thrombolysis_reason", "imaging_done", "imaging_type",
  "dysphagia_screening_done", "dysphagia_screening_type", "before_onset_antidiabetics", "before_onset_antihypertensives", "before_onset_asa",
  "before_onset_cilostazol", "before_onset_clopidrogel", "before_onset_ticagrelor", "before_onset_ticlopidine", "before_onset_prasugrel",
  "before_onset_dipyridamol", "before_onset_warfarin", "before_onset_dabigatran", "before_onset_rivaroxaban", "before_onset_apixaban",
  "before_onset_edoxaban", "before_onset_statin", "risk_hypertension", "risk_diabetes", "risk_hyperlipidemia", "risk_atrial_fibrilation",
  "risk_congestive_heart_failure", "risk_smoker", "risk_previous_ischemic_stroke", "risk_previous_hemorrhagic_stroke", "risk_coronary_artery_disease_or_myocardial_infarction",
  "risk_hiv", "hemicraniectomy", "discharge_antidiabetics", "discharge_antihypertensives", "discharge_asa", "discharge_cilostazol",
  "discharge_clopidrogel", "discharge_ticagrelor", "discharge_ticlopidine", "discharge_prasugrel", "discharge_dipyridamol",
  "discharge_warfarin", "discharge_dabigatran", "discharge_rivaroxaban", "discharge_apixaban", "discharge_edoxaban",
  "discharge_statin", "discharge_any_anticoagulant", "discharge_any_antiplatelet", "afib_flutter", "carotid_stenosis_level",
  "discharge_destination", "bleeding_reason_hypertension", "bleeding_reason_aneurysm", "bleeding_reason_malformation",
  "bleeding_reason_anticoagulant", "bleeding_reason_angiopathy", "bleeding_reason_other", "bleeding_source", "covid_test",
  "physiotherapy_start_within_3days", "occup_physiotherapy_received", "stroke_mimics_diagnosis", "tici_score", "prenotification",
  "etiology_large_artery", "etiology_cardioembolism", "etiology_other", "etiology_cryptogenic_stroke", "etiology_small_vessel",
  "glucose_level", "insulin_administration", "first_arrival_hosp", "first_hospital", "hunt_hess_score", "discharge_mrs", "ich_score",
  "three_m_mrs"
)
catVars_cols <- c(key_cols,catVars)

KPIs <- c("door_to_needle", "door_to_groin", "onset_to_door", "door_to_imaging", "prestroke_mrs", "discharge_mrs", "three_m_mrs", "door_to_door", "dysphagia_screening_done", "thrombolysis", "thrombectomy")
riskFactors <- c("risk_hypertensions", "risk_diabetes", "risk_hyperlipidemia", "risk_smoker", "risk_previous_ischemic_stroke", "risk_previous_hemorrhagic_stroke", "risk_atrial_fibrilation", "risk_coronary_artery_disease_or_myocardial_infarction", "risk_congestive_heart_failure", "risk_hiv")



# aggregation -------------------------------------------------------------


agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year, quarter) %>%
  summarise(mean = mean(Value, na.rm = TRUE), median = median(Value, na.rm = TRUE), number_of_cases = n()) %>%
  pivot_longer(cols = mean:number_of_cases, names_to = "agg_function", values_to = "Value")

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, hospital_name, year) %>%
  summarise(
    mean = mean(Value, na.rm = TRUE),
    median = median(Value, na.rm = TRUE),
    number_of_cases = n()
  ) %>%
  pivot_longer(cols = mean:number_of_cases, names_to = "agg_function", values_to = "Value") %>%
  mutate(quarter = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year, quarter) %>%
  summarise(
    mean = mean(Value, na.rm = TRUE),
    median = median(Value, na.rm = TRUE),
    number_of_cases = n()
  ) %>%
  pivot_longer(cols = mean:number_of_cases, names_to = "agg_function", values_to = "Value") %>%
  mutate(hospital_name = "all") %>%
  rbind(agg_data)

agg_data <- dataset[, numVars_cols] %>%
  pivot_longer(-key_cols, names_to = "QI", values_to = "Value") %>%
  group_by(QI, hospital_country, year) %>%
  summarise(
    mean = mean(Value, na.rm = TRUE),
    median = median(Value, na.rm = TRUE),
    number_of_cases = n()
  ) %>%
  pivot_longer(cols = mean:number_of_cases, names_to = "agg_function", values_to = "Value") %>%
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

options("scipen"=999)
agg_data <- agg_data %>% expand("site_country", "site_name", "site_id", "discharge_year", "discharge_quarter", "YQ")

# condx=
# dataset %>% filter(eval(parse(text=condx)))
