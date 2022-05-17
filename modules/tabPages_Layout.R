tabPages <- function(tab_id, tab_df) {
  fluidPage(
    fluidRow(
        QI_Layout(id = tab_id, database = tab_df),
        visualization_Layout(id = tab_id, database = tab_df)
    )
  )
}
