library(googlesheets4)
library(gsheet)
structureData<- gsheet2tbl('https://docs.google.com/spreadsheets/d/1MrhG4S0lIzMI6-J7iiURH5LDJ0fAl3RoqFwqMTxXiCY/edit#gid=1936144053',sheet=3)
structureData <- structureData %>% 
  filter(isStudProj=="x") %>%
  mutate(across('conditionForAggr', str_replace, 'total cohort', '')) %>%
  mutate(across('conditionForAggr', str_replace, ']', ')')) %>%
  mutate(across('conditionForAggr', str_replace, 'in \\[', '%in% c('))

all_quarters <- c("Q1", "Q2", "Q3", "Q4")
all_years <- 2017:2022

# KPI variables -----------------------------------------------------------
KPIs <- c(
  "discharge_mrs",
  "door_to_groin",
  "door_to_imaging",
  "door_to_needle",
  "dysphagia_screening_done",
  "onset_to_door",
  "prestroke_mrs",
  "three_m_mrs",
  "thrombectomy",
  "thrombolysis"
)

# key columns -------------------------------------------------------------
key_cols <- c("site_country", 
              "site_name", "site_id", 
              "discharge_year", 
              "discharge_quarter", 
              "YQ", 
              "subject_id")


# categorical variables -----------------------------------------------------------------

catVars <- c(
  "afib_flutter",
  "before_onset_antidiabetics",
  "before_onset_antihypertensives",
  "before_onset_apixaban",
  "before_onset_asa",
  "before_onset_cilostazol",
  "before_onset_clopidrogel",
  "before_onset_dabigatran",
  "before_onset_dipyridamol",
  "before_onset_edoxaban",
  "before_onset_prasugrel",
  "before_onset_rivaroxaban",
  "before_onset_statin",
  "before_onset_ticagrelor",
  "before_onset_ticlopidine",
  "before_onset_warfarin",
  "bleeding_reason_aneurysm",
  "bleeding_reason_angiopathy",
  "bleeding_reason_anticoagulant",
  "bleeding_reason_hypertension",
  "bleeding_reason_malformation",
  "bleeding_reason_other",
  "bleeding_source",
  "carotid_stenosis_level",
  "covid_test",
  "department_type",
  "discharge_antidiabetics",
  "discharge_antihypertensives",
  "discharge_any_anticoagulant",
  "discharge_any_antiplatelet",
  "discharge_apixaban",
  "discharge_asa",
  "discharge_cilostazol",
  "discharge_clopidrogel",
  "discharge_dabigatran",
  "discharge_destination",
  "discharge_dipyridamol",
  "discharge_edoxaban",
  "discharge_mrs",
  "discharge_prasugrel",
  "discharge_rivaroxaban",
  "discharge_statin",
  "discharge_ticagrelor",
  "discharge_ticlopidine",
  "discharge_warfarin",
  "dysphagia_screening_done",
  "dysphagia_screening_type",
  "etiology_cardioembolism",
  "etiology_cryptogenic_stroke",
  "etiology_large_artery",
  "etiology_other",
  "etiology_small_vessel",
  "first_arrival_hosp",
  "first_hospital",
  "gender",
  "glucose_level",
  "hemicraniectomy",
  "hospital_stroke",
  "hospitalized_in",
  "hunt_hess_score",
  "ich_score",
  "imaging_done",
  "imaging_type",
  "insulin_administration",
  "no_thrombolysis_reason",
  "occup_physiotherapy_received",
  "physiotherapy_start_within_3days",
  "prenotification",
  "risk_atrial_fibrilation",
  "risk_congestive_heart_failure",
  "risk_coronary_artery_disease_or_myocardial_infarction",
  "risk_diabetes",
  "risk_hiv",
  "risk_hyperlipidemia",
  "risk_hypertension",
  "risk_previous_hemorrhagic_stroke",
  "risk_previous_ischemic_stroke",
  "risk_smoker",
  "stroke_mimics_diagnosis",
  "stroke_type",
  "three_m_mrs",
  "thrombectomy",
  "thrombolysis",
  "tici_score"
)


# numerical variables -----------------------------------------------------

numVars <- c('age',
 'bleeding_volume_value',
 'cholesterol',
 'dis_blood_pressure',
 'discharge_nihss_score',
 'door_to_groin',
 'door_to_imaging',
 'door_to_needle',
 'glucose',
 'hypoperfusion_core',
 'nihss_score',
 'onset_to_door',
 'perfusion_core',
 'prestroke_mrs',
 'sys_blood_pressure'
)

# condition columns --------------------------------------------------------

cond_cols <- c("stroke_type=='ischemic' & thrombolysis == True & hospital_stroke != True & first_hospital == True & door_to_needle <= 60",
  "stroke_type=='ischemic' & thrombolysis == True & hospital_stroke != True & first_hospital == True & door_to_needle <= 45",
  "stroke_type=='ischemic' & thrombectomy == True & hospital_stroke != True & first_hospital == True & door_to_groin <= 120",
  "stroke_type=='ischemic' & thrombectomy == True & hospital_stroke != True & first_hospital == True & door_to_groin <= 90",
  "stroke_type=='ischemic'",
  "True",
  "post_acute_care == 'yes' & stroke_type %in% c('ischemic','transient ischemic','intracerebral hemorrhage', 'undetermined')",
  "discharge_destination!='dead'",
  "discharge_destination!='dead'",
  "True")

# risk factor variables ---------------------------------------------------
riskFactors <- c(
  "risk_atrial_fibrilation",
  "risk_congestive_heart_failure",
  "risk_coronary_artery_disease_or_myocardial_infarction",
  "risk_diabetes",
  "risk_hiv",
  "risk_hyperlipidemia",
  "risk_hypertensions",
  "risk_previous_hemorrhagic_stroke",
  "risk_previous_ischemic_stroke",
  "risk_smoker"
)
# AngelAwards variables and cutoffs -------------------------------------------------------------

angel_awards <- tibble::tribble(
  ~QI, ~nameOfAggr, ~gold, ~platinum, ~diamond, ~cond,
  "door_to_needle", "dnt_leq_60", 50, NA, 75, "stroke_type=='ischemic' & thrombolysis == True & hospital_stroke != True & first_hospital == True & door_to_needle <= 60",
  "door_to_needle","dnt_leq_45", NA, 0, 50, "stroke_type=='ischemic' & thrombolysis == True & hospital_stroke != True & first_hospital == True & door_to_needle <= 45",
  "door_to_groin","dgt_leq_120", 50, NA, 75, "stroke_type=='ischemic' & thrombectomy == True & hospital_stroke != True & first_hospital == True & door_to_groin <= 120",
  "door_to_groin","dgt_leq_90", NA, 0, 50, "stroke_type=='ischemic' & thrombectomy == True & hospital_stroke != True & first_hospital == True & door_to_groin <= 90",
  "thrombolysis","rec_total_is", 5, 15, 25, "stroke_type=='ischemic'",
  "imaging_done","p_ct_mri_first_hosp", 80, 85, 90, "True",
  "dysphagia_screening_type","p_dys_screen", 80, 85, 90, "post_acute_care == 'yes' & stroke_type %in% c('ischemic','transient ischemic','intracerebral hemorrhage', 'undetermined')",
  "discharge_any_antiplatelet","isp_dis_antiplat", 80, 85, 90, "discharge_destination!='dead'",
  "discharge_any_anticoagulant","af_p_dis_anticoag", 80, 85, 90, "discharge_destination!='dead'",
  "hospitalized_in","sp_hosp_stroke_unit_ICU", NA, 0, 1, "True")


# award handler function --------------------------------------------------

awardHandler <- function(currentValue, goldThresh, platThresh, diaThresh) {
  awardList <- c("Gold", "Platinum", "Diamond")
  threshList <- c(goldThresh, platThresh, diaThresh)
  award <- "Stroke Ready"

  if(!(is.na(currentValue)))
    for (i in 1:length(threshList)) {
      if (!(is.na(threshList[i]))) {
        if (currentValue >= threshList[i]) {
          award <- awardList[i]
        }
      }
    }
  
  return(award)
}