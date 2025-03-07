source("global.R") # configurations

server <- function(input, output, session) {
  
  data <- reactive({
    req(input$file)
    df <- read.csv(input$file$datapath, sep="\t", header=TRUE)
    updateSelectInput(session, "y_var", choices = c("ES", "NES"), selected = "NES")
    updateSliderInput(session, "size_range", min = 0, max = max(df$SIZE, na.rm = TRUE), value = c(0, max(df$SIZE, na.rm = TRUE)))
    return(df)
  })
  
  filtered_data <- reactive({
    req(data())
    df <- data() %>%
      filter(FDR.q.val <= input$fdr_thresh)
    return(df)
  })
  
  observe({
    df <- filtered_data()
    max_size <- ifelse(nrow(df) > 0, max(df$SIZE, na.rm = TRUE), 100)
    updateSliderInput(session, "size_range", min = 0, max = max_size)
  })
  
  final_data <- reactive({
    req(filtered_data())
    
    df <- data() %>%
      filter(FDR.q.val <= input$fdr_thresh, SIZE >= input$size_range[1], SIZE <= input$size_range[2]) %>% 
      mutate( NES = round(NES, 3)) %>% 
      mutate( ES = round(ES, 3)) %>% 
      select(NAME, SIZE, ES, NES, NOM.p.val, FDR.q.val)
    #rownames(df) <- NULL
    
    return(df)
  })
  
  output$table <- renderDT({
    datatable(final_data(), options = list(pageLength = 10, autoWidth = TRUE, #rownames = FALSE,
                                           language = list(emptyTable = "Il n'y a pas de Pathways avec ces seuils"),
                                           columnDefs = list(list(targets = '_all', 
                                                                  className = 'dt-left', width = '10%'))),
              style = "bootstrap") %>%
      formatStyle(columns = colnames(final_data()), fontSize = '10px')
  })
  
  selected_data <- reactive({
    req(final_data())
    selected_rows <- input$table_rows_selected
    if (length(selected_rows) > 0) {
      return(final_data()[selected_rows, ])
    } else {
      return(final_data())
    }
  })
  
  observeEvent(input$clear_selection, {
    # clean rows
    DT::dataTableProxy("table") %>% DT::selectRows(NULL)
  })
  
  plot_reactive <- reactive({
    req(selected_data(), input$y_var)
    df_plot <- selected_data() %>%
      arrange(desc(.data[[input$y_var]])) %>%
      mutate(NAME = factor(NAME, levels = NAME),
             !!sym(input$y_var) := as.numeric(.data[[input$y_var]]))
    
    ggplot(df_plot, aes(x = NAME, y = .data[[input$y_var]], size = SIZE, color = FDR.q.val)) +
      geom_point(alpha = 0.7) +
      scale_color_gradient(low = "blue", high = "red") +
      theme_minimal() +
      coord_flip() +
      scale_y_continuous() +
      labs(title = "  ", x = " ", y = input$y_var)
  })
  
  output$dotplot <- renderPlot({
    plot_reactive()
  })
  
  output$download_png <- downloadHandler(
    filename = function() { "dotplot.png" },
    content = function(file) {
      ggsave(file, plot = plot_reactive(), device = "png", dpi = 300, width = 10, height = 7)
    }
  )
  
  output$download_svg <- downloadHandler(
    filename = function() { "dotplot.svg" },
    content = function(file) {
      ggsave(file, plot = plot_reactive(), device = "svg", dpi = 300, width = 10, height = 7)
    }
  )
}

