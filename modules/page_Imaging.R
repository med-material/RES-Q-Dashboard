page_Imaging <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_Imaging_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}