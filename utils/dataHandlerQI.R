source("utils/dataLoader.R", local = T)

dataHandlerQI <- function (data, dataType, QI_Fetch, hospital, country, aggType) {
  
  #Find latest quarter of hospital of interest
  starting <- data %>% filter(site_name == hospital)
  latest <- max(starting$YQ)
  
  #Define scope of the data
  scope <- sort(unique(starting$YQ), decreasing = TRUE)
  scope <- head(scope,4)
  scope <- data.frame(YQ = scope)
  
  #Hospital score
  hosp_data_scope <- data %>% 
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_name == hospital) %>%
    group_by(YQ) 
  
  #Country Score
  country_data_scope <- data %>%
    filter(QI == QI_Fetch & YQ >= scope$YQ[4] & site_country == country) %>%
    group_by(YQ)
  
  if (dataType == "Quantitative") {
  
    hosp_data_scope <- hosp_data_scope %>%
      summarize(.groups = 'drop',
        Hospital = 
          if (!!aggType == "mean") {
            mean(Value, na.rm = T)
          }
        
        else if (!!aggType == "median") {
          median(Value, na.rm = T)
        }
        
        
        
      )
    
    country_data_scope <- country_data_scope %>%
      summarize(.groups = 'drop',
        Country = 
          if (!!aggType == "mean") {
            mean(Value, na.rm = T)
          }
        
        else if (!!aggType == "median") {
          median(Value, na.rm = T)
        }
      )
    
    #Collecting both Country & Hospital data under the same variable
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    hosp_data_agg$Country <- country_data_agg$Country
    
    #Test missing data flag
    hosp_data_agg$Hospital[2] <- NA
    
    #Flagging data
    hosp_data_agg$Flag <- as.factor(ifelse(is.na(hosp_data_agg$Hospital), "Missing", "Good"))
    
    #Filling missing data with rolling mean of data
    hosp_data_agg <- hosp_data_agg %>% mutate(Hospital = ifelse(is.na(Hospital), mean(Hospital, na.rm=T), Hospital))
    hosp_data_agg <- hosp_data_agg %>% mutate(Country = ifelse(is.na(Country), mean(Country, na.rm=T), Country))
    return(hosp_data_agg)
  }
  
  else if (dataType == "Categorical_binary") {
    
    hosp_data_scope <- hosp_data_scope  %>% 
      rename(Category = Value) %>% mutate(Scope = "Hospital") %>% select(c(YQ, QI, Category, Scope))
    
    country_data_scope <- country_data_scope  %>%
      rename(Category = Value) %>% mutate(Scope = "Country") %>% select(c(YQ, QI, Category, Scope))
    
    
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    hosp_data_agg <- rbind(hosp_data_agg, country_data_agg)
    
    
    hosp_data_agg$Category <- as.logical(hosp_data_agg$Category)
    
    if (aggType == "%") {
      hosp_data_agg <- hosp_data_agg %>% group_by(YQ, QI, Scope) %>% 
        summarise(.groups = 'drop',
          denom = n(),
          Category = sum(Category, na.rm = T)
        )
      
      hosp_data_agg <- hosp_data_agg %>% mutate(Category = 100*Category/denom) %>% select(-denom)
      hosp_data_agg <- hosp_data_agg %>% pivot_wider(names_from = Scope, values_from = Category)
    }
    
    else if (aggType == "count") {
      hosp_data_agg <- hosp_data_agg %>% group_by(YQ, QI, Scope) %>% summarise(.groups = 'drop', Category = sum(Category, na.rm = T))
      hosp_data_agg <- hosp_data_agg %>% pivot_wider(names_from = Scope, values_from = Category)
    }
    hosp_data_agg$Flag <- as.factor(ifelse(is.na(hosp_data_agg$Hospital), "Missing", "Good"))
    return(hosp_data_agg)
  }
  
  else {
    hosp_data_scope <- hosp_data_scope  %>% 
      rename(Category = Value) %>% mutate(Scope = "Hospital") %>% select(c(YQ, QI, Category, Scope))
    
    country_data_scope <- country_data_scope  %>%
      rename(Category = Value) %>% mutate(Scope = "Country") %>% select(c(YQ, QI, Category, Scope))
    
    hosp_data_agg <- merge(hosp_data_scope, scope, all.y = T)
    country_data_agg <- merge(country_data_scope, scope, all.y = T)
    
    hosp_data_agg <- rbind(hosp_data_agg, country_data_agg)
    
    #hosp_data_agg <- hosp_data_agg %>% pivot_longer(-c(YQ, Category), names_to = "Scope", values_to = "Count")
    return(hosp_data_agg)
    
  }
}

#Testing
# db <- dataLoader()
# numVars <- db$numVars
# catVars <- db$catVars
# 
# metrics <- dataHandlerQI(catVars, "Categorical", "discharge_mrs", "uggeebfixudwdhb", "vrprkigsxydwgni", "cat")
# metrics <- metrics %>% filter(YQ == max(metrics$YQ))
# 
# if (all(!is.na(metrics$Category))) {
#   plot <- ggplot(metrics, aes(x = Scope, fill = Category)) +
#     geom_bar(position ="fill", width = 0.4) + coord_flip() +
#                                 theme(axis.ticks.x = element_blank(),
#                                       axis.text.x = element_blank(),
#                                       axis.title.x = element_blank(),
#                                       axis.ticks.y = element_blank(),
#                                       legend.position = "none",
#                                       axis.title.y = element_blank(),
#                                       panel.grid.major = element_blank(),
#                                       panel.grid.minor = element_blank(),
#                                       panel.background = element_blank())
#   
#   ggplotly(plot)
# }
# metrics2 <- dataHandlerQI(numVars, "Quantitative", "door_to_imaging", "uggeebfixudwdhb", "vrprkigsxydwgni", "median")
# metrics2$Hospital <- round(metrics2$Hospital,1)
# 
# metrics3 <- dataHandlerQI(catVars, "Categorical_binary", "discharge_antidiabetics", "uggeebfixudwdhb", "vrprkigsxydwgni", "%")
# plot2 <- ggplot(metrics3, aes(x = YQ)) + geom_point(aes(y = Hospital, group = 1)) + geom_line(aes(y = Hospital, group = 1)) +
#   geom_point(aes(y = Country, group = 1)) + geom_line(aes(y = Country, group = 1)) +
#   theme(axis.ticks.x = element_blank(),
#       axis.text.x = element_blank(),
#       axis.title.x = element_blank(),
#       axis.ticks.y = element_blank(),
#       axis.text.y = element_blank(),
#       axis.title.y = element_blank(),
#       panel.grid.major = element_blank(),
#       panel.grid.minor = element_blank(),
#       panel.background = element_blank())
# 
# ggplotly(plot2)


#ggplot(metrics, aes(x = Value, fill = group)) + 
#  geom_bar()