QI_Treatment_UI <- function(id, database) {
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
    QI_rowmaker(id, "IVT.N", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "IVT.P", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "ARRN", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "OTD.IVT", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "DTN.IVT", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "MT.N", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "MT.P", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "MTIVT.P", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DTG.MT1", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "DTG.MT2", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "DIDO.MT", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "TICI.S", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "BLD.IVTMT", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "MT.COMP", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DVT.PREV", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "OTD.DIS", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "DTI.DIS", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DTG.DIS", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "DTG.DIS", 50, 60, "V1.png", "p2")
  )
}

QI_Treatment <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}