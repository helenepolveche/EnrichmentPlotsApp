source("global.R") # configurations

ui <- navbarPage(
  title = div(img(src="istem-logo-fr_innoverMe.png", 
                  height = "30px", 
                  style = "margin-right:10px;"
  ), 
  "Visualisation des Résultats d'Enrichissement"),
  
  theme = theme_custom,
  header = navbar_style,
  
  
  tabPanel("DotPlot",
           fluidRow(
             column(3,  # 3/12 = 25%
                    wellPanel(
                      fileInput("file", "Charger un fichier CSV / TSV", accept = c(".csv", ".tsv")),
                      selectInput("y_var", "NES / ES", choices = NULL),
                      sliderInput("size_range", "Taille des points (SIZE)", min = 0, max = 100, value = c(0, 100)),
                      numericInput("fdr_thresh", "Seuil FDR q-val", value = 0.05, min = 0, max = 1, step = 0.01) #,
                      #actionButton("update", "Mettre à jour")
                    )
             ),
             
             column(9,  # 9/12 = 75%
                    DTOutput("table"),
                    actionButton("clear_selection", "Retirer les sélections"),
                    downloadButton("download_png", "PNG"),
                    downloadButton("download_svg", "SVG"),
                    plotOutput("dotplot")
             )
           )
  ),
  
  tabPanel("À propos",
           fluidPage(
             h2("À propos de cette application"),
             p("Cette application permet de visualiser les données GSEA sous forme de dotplots.")
           )
  )
)
