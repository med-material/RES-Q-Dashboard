dataLoader <- function() {
    dataset <- as_tibble(read.csv("data/dataREanonymized.csv"))
    key_cols<-c("site_country", "site_name", "site_id", "discharge_year", "discharge_quarter","YQ","subject_id")
    dataset <-  dataset %>% 
      # rename(patient_id=subject_id, hospital_id=site_id,hospital_name=site_name, hospital_country=site_country,year = discharge_year, quarter=discharge_quarter) %>%
      mutate(YQ = paste(discharge_year, discharge_quarter)) %>%
      relocate(key_cols,.before = where(is.character)) %>%
#       relocate(c(year,quarter,YQ), .after = country)
      filter(discharge_year > 2000 & discharge_year <= as.integer(format(Sys.Date(), "%Y"))) 
        
    #out <- skimr::skim(dataset)
    
    
    
    #Relevant columns from the dataset for the QI's HARDCODED. There might be a smarter way to do this. 
    numVars_cols <- c( key_cols,"age", "nihss_score", "door_to_needle", "door_to_groin",
                      "door_to_imaging", "onset_to_door", "discharge_nihss_score", "glucose", "cholesterol", "sys_blood_pressure", "prestroke_mrs",
                      "dis_blood_pressure", "perfusion_core", "hypoperfusion_core", "bleeding_volume_value")
    
    catVars_cols <- c(key_cols, "gender", "hospital_stroke", "hospitalized_in",
                      "department_type", "stroke_type", "thrombectomy", "thrombolysis", "no_thrombolysis_reason", "imaging_done", "imaging_type",
                      "dysphagia_screening_done", "dysphagia_screening_type", "before_onset_antidiabetics", "before_onset_antihypertensives", "before_onset_asa",
                      "before_onset_cilostazol","before_onset_clopidrogel","before_onset_ticagrelor","before_onset_ticlopidine","before_onset_prasugrel",
                      "before_onset_dipyridamol","before_onset_warfarin","before_onset_dabigatran","before_onset_rivaroxaban","before_onset_apixaban",
                      "before_onset_edoxaban","before_onset_statin", "risk_hypertension","risk_diabetes", "risk_hyperlipidemia", "risk_atrial_fibrilation",
                      "risk_congestive_heart_failure", "risk_smoker", "risk_previous_ischemic_stroke", "risk_previous_hemorrhagic_stroke",
                      "risk_coronary_artery_disease_or_myocardial_infarction", "risk_hiv", "hemicraniectomy", "discharge_antidiabetics", "discharge_antihypertensives",
                      "discharge_asa", "discharge_cilostazol",
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
    
    #Selecting numerical data 
    numVars <- dataset %>% select(all_of(numVars_cols)) 
    catVars <-  dataset %>% select(all_of(catVars_cols))
    
    #Converting all double type data into characters so they can be pivoted under the same character data type.
    indx <- sapply(catVars, is.double)
    catVars[indx] <- lapply(catVars[indx], function(x) as.character(x))
    
    #Selecting numerical data
    catVars <- catVars %>% select(all_of(catVars_cols)) 
     
    
    #Flip to long format
    numVars <- numVars %>% pivot_longer(-key_cols, names_to = "QI", values_to = "Value")
    catVars <- catVars %>% pivot_longer(-key_cols, names_to = "QI", values_to = "Value")
    
    
    return(list("numVars" = numVars,"catVars" = catVars))
}