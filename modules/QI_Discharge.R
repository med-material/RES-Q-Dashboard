QI_Discharge_UI <- function(id, database) {
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
    QI_rowmaker(id, "AD", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "AH", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "ASA.STK", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "CLTZL", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "CLPDGRL", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "TCGL", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "TCLPDN", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "PRSGRL", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DPRDML", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "WRFRN", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "HPRN", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DBGTR", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "RVRXBN", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "APXBN", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "EDXBN", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "STATIN", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "COMP", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "DD", 50, 60, "V3.png", "p2"),
    QI_rowmaker(id, "MRS.D", 50, 60, "V1.png", "p2"),
    QI_rowmaker(id, "MRS.3", 50, 60, "V2.png", "p2"),
    QI_rowmaker(id, "NIHSS.D", 50, 60, "V3.png", "p2")
  )
}

QI_Discharge <- function(id, database) {
  moduleServer(
    id,
    function(input, output, session) {
    }
  )
}