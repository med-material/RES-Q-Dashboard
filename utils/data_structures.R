
angel_awards <- tibble::tribble(
  ~nameOfAggr, ~gold, ~platinum, ~diamond,
  "dnt_leq_60", 50, NA, 75,
  "dnt_leq_45", NA, 0, 50,
  "dgt_leq_120", 50, NA, 75,
  "dgt_leq_90", NA, 0, 50,
  "rec_total_is", 5, 15, 25,
  "p_ct_mri_first_hosp", 80, 85, 90,
  "p_dys_screen", 80, 85, 90,
  "isp_dis_antiplat", 80, 85, 90,
  "af_p_dis_anticoag", 80, 85, 90,
  "sp_hosp_stroke_unit_ICU", NA, 0, 1
)

awardHandler <- function(currentValue, goldThresh, platThresh, diaThresh) {
  awardList <- c("Gold", "Platinum", "Diamond")
  threshList <- c(goldThresh, platThresh, diaThresh)
  award <- "Stroke Ready"

  if (!(is.na(currentValue))) {
    for (i in 1:length(threshList)) {
      if (!(is.na(threshList[i]))) {
        if (currentValue >= threshList[i]) {
          award <- awardList[i]
        }
      }
    }
  }
  return(award)
}