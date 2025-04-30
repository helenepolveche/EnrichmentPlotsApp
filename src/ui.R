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
                      fileInput("file", label = tagList("Charger un fichier CSV / TSV", 
                                tags$i(class = "fas fa-info-circle", style = "color: #428bca; margin-left: 5px; cursor: help;", 
                                         title = "Le fichier, issu d'une analyse GSEA, doit contenir au minimum des colonnes nommées 'SIZE', 'NES', 'ES', et 'FDR q-val'")), 
                                accept = c(".csv", ".tsv")),
                      selectInput("y_var", "NES / ES", choices = NULL),
                      sliderInput("size_range", "Taille des points (SIZE)", min = 0, max = 100, value = c(0, 100)),
                      numericInput("fdr_thresh", "Seuil FDR q-val", value = 0.05, min = 0, max = 1, step = 0.01) #,
                      #actionButton("update", "Mettre à jour")
                    )
             ),
             
             column(9,  # 9/12 = 75%
                    DTOutput("table"),
                    actionButton("clear_selection", "Retirer les sélections"),
                    tagList(
                      downloadButton("download_png", "PNG", style = "margin-right: 10px;", 
                                     title = "'Portable Network Graphics' est un format d'image matricielle qui utilise une compression sans perte, idéal pour des graphiques nets avec transparence."),
                      downloadButton("download_svg", "SVG", 
                                     title = "'Scalable Vector Graphics' est un format d'image vectorielle qui permet un redimensionnement sans perte de qualité, parfait pour les présentations et publications")
                      ),
                    plotOutput("dotplot")
             )
           )
  ),
  
  tabPanel("Aide",
           fluidPage(
             h3("À propos de cette application"),
             p("Cette application permet de visualiser les données GSEA sous forme de dotplots."),
             p("Pour tout problème rencontré: contacher Hélène Polvèche ( hpolveche[AT]istem.fr )"),
             h3("Fichier d'entrée type :")
           )
  )

)