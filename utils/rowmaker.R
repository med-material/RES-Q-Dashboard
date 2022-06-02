QI_rowmaker <- function(id, QI, m1, m2, v1id, v2id) {
  ns <- NS(id)
  
  fixedRow(
    column(
      2,
      h4(QI, align = 'center')
    ),
    column(
      1,
      h4(as.character(m1), align = 'center')
    ),
    column(
      1,
      h4(as.character(m2), align = 'center')
    ),
    column(
      4,
      align = 'center',
      #h6("+30"),
      tags$img(src = "testplot.png", width = "30%"),
    ),
    column(
      3,
      align = 'center'
      # plotlyOutput(
      #   outputId = ns(v1id)
      # )
    ),
    column(
      1,
      align = 'center',
      actionButton(ns(QI), label = NULL, icon = icon("play"))
    )
  )
}