page_Treatment <- function(id, df) {
  fluidPage(
    fixedRow(
      QI_Treatment_UI(id = id, database = df),
      visualization_Layout(id = id, database = df)
      
    )
  )
}