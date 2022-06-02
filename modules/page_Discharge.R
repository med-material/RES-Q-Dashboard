page_Discharge <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_Discharge_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}