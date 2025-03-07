source("global.R")

source("src/ui.R")

source("src/server.R")

# launch app
shinyApp(ui = ui, server = server)
