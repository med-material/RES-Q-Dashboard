dataHandlerQI <- function (data, QI_Fetch, hospital, country, aggType) {
  latest <- max(data$YQ)
  scope <- sort(unique(data$YQ), decreasing = TRUE)
  scope <- head(scope,4)
  scope <- data.frame(YQ = scope)
  
  #Hospital score
  hosp_data_scope <- data %>% 
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_name == hospital) %>%
    group_by(YQ) %>%
    summarize(
      Value = 
        if (!!aggType == "mean") {
          mean(Value, na.rm = T)
        }
      
      else if (!!aggType == "median") {
        median(Value, na.rm = T)
      }
    )
  hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
  
  
  #Country Score
  country_data_scope <- data %>%
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_country == country) %>%
    group_by(YQ) %>%
    summarize(
      Value = 
        if (!!aggType == "mean") {
          mean(Value, na.rm = T)
        }
      
      else if (!!aggType == "median") {
        median(Value, na.rm = T)
      }
    )
  country_data_agg <- merge(country_data_scope, scope, all.y = T)
  hosp_data_agg$CValue <- country_data_agg$Value
  return(hosp_data_agg)
}
db <- dataLoader()
metrics <- dataHandlerQI(db, "age", "uggeebfixudwdhb", "vrprkigsxydwgni", "mean")