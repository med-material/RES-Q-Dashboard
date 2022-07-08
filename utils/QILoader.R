QILoader <- function() {
  dataset <- as_tibble(read.csv("data/QI_info.csv"))
  
  #Remove rows with empty valued cells
  dataset <- dataset[!apply(dataset, 1, function(x) any(x=="")),] 
}