QI_Imaging_UI <- function(id, database) {
  ns <- NS(id)
  column(
    6,
    fixedRow(
      column(
        2,
        h4("QI", align = 'center', title = "hovertext")
      ),
      column(
        1,
        h4("Metric 1", align = 'center')
      ),
      column(
        1,
        h4("Metric 2", align = 'center')
      ),
      column(
        4,
        h4("Visual 1", align = 'center')
      ),
      column(
        3,
        h4("Visual 2", align = 'center')
      ),
      column(
        1,
        h4("More", align = 'center')
      )
    ),
    QI_rowmaker(id, "IMG.MODE", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "SITE.O", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "IMG.ND", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "IMG.OH", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "DTI", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "CT.S", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "CT.HF", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "IMG.CRTD", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "CRTD.70", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "CRTD.50", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "ICH.V", 50, 60, "V2.png", "p2")
  )
}

QI_Imaging <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}