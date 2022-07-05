QILoader <- function() {
  dataset <- as_tibble(read.csv("data/QI_info.csv"))
  
  #Remove rows with empty valued cells
  dataset <- dataset[!apply(dataset, 1, function(x) any(x=="")),] 
}

df <- QILoader()

df_Bleeding <- df %>% filter(TAB == "Bleeding")


df_Imaging <- df %>% filter(TAB == "Imaging" & ATTRIBUTE_TYPE == "Quantitative")

df_Treatment <- df %>% filter(TAB == "Treatment")
df_PO <- df %>% filter(TAB == "PO")
df_Discharge <- df %>% filter(TAB == "Discharge")