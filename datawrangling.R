dataset <- as_tibble(read.csv("data/dataREanonymized.csv"))
#out <- skimr::skim(dataset)

#df <- dataset %>% pivot_longer(-c(discharge_year, discharge_quarter, site_namemt), names_to= "vars", values_to = "vals")


numVars_cols <- c("site_country", "site_name", "discharge_year", "discharge_quarter", "age", "nihss_score", "door_to_needle", "door_to_groin",
                  "door_to_imaging", "onset_to_door", "discharge_mrs", "discharge_nihss_score", "three_m_mrs", "glucose", "cholesterol", "sys_blood_pressure",
                  "dis_blood_pressure", "perfusion_core", "hypoperfusion_core", "prestroke_mrs", "bleeding_volume_value", "ich_score", "hunt_hess_score")

catVars_cols <- c("site_country", "site_name", "discharge_year", "discharge_quarter", "gender", "hospital_stroke", "hospitalized_in", 
                  "department_type", "stroke_type", "thrombectomy", "thrombolysis", "no_thrombolysis_reason", "imaging_done", "imaging_type",
                  "dysphagia_screening_done", "before_onset_antidiabetics", "before_onset_antihypertensives", "before_onset_asa",
                  "before_onset_cilostazol","before_onset_clopidrogel","before_onset_ticagrelor","before_onset_ticlopidine","before_onset_prasugrel",
                  "before_onset_dipyridamol","before_onset_warfarin","before_onset_dabigatran","before_onset_rivaroxaban","before_onset_apixaban",
                  "before_onset_edoxaban","before_onset_statin", "risk_hypertension","risk_diabetes", "risk_hyperlipidemia", "risk_atrial_fibrilation", 
                  "risk_congestive_heart_failure", "risk_smoker", "risk_previous_ischemic_stroke", "risk_previous_hemorrhagic_stroke", "risk_coronary_artery_disease_or_myocardial_infarction", 
                  "risk_hiv", "hemicraniectomy", "discharge_antidiabetics", "discharge_antihypertensives", "discharge_asa", "discharge_cilostazol", 
                  "discharge_clopidrogel", "discharge_ticagrelor", "discharge_ticlopidine", "discharge_prasugrel", "discharge_dipyridamol", 
                  "discharge_warfarin", "discharge_dabigatran", "discharge_rivaroxaban", "discharge_apixaban", "discharge_edoxaban", 
                  "discharge_statin", "discharge_any_anticoagulant", "discharge_any_antiplatelet", "afib_flutter", "carotid_stenosis_level", 
                  "discharge_destination", "bleeding_reason_hypertension", "bleeding_reason_aneurysm", "bleeding_reason_malformation", 
                  "bleeding_reason_anticoagulant", "bleeding_reason_angiopathy", "bleeding_reason_other", "bleeding_source", "covid_test", 
                  "physiotherapy_start_within_3days", "occup_physiotherapy_received", "stroke_mimics_diagnosis", "tici_score", "prenotification", 
                  "etiology_large_artery", "etiology_cardioembolism", "etiology_other", "etiology_cryptogenic_stroke", "etiology_small_vessel", 
                  "glucose_level", "insulin_administration", "first_arrival_hosp", "first_hospital"
                  )
numVars <- dataset %>% select(numVars_cols)

catVars <- dataset %>% select(catVars_cols)

numVars_untidy <- numVars %>% pivot_longer(-c(site_country, site_name, discharge_year, discharge_quarter), names_to = "QI", values_to = "Value")

catVars_untidy <- catVars %>% pivot_longer(-c(site_country, site_name, discharge_year, discharge_quarter), names_to = "QI", values_to = "Value")



