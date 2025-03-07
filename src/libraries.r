## Rshiny App  to generate dotplot
install.packages(c("shiny", "shinythemes", "DT", "ggplot2", "bslib"))
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("clusterProfiler", "org.Hs.eg.db", "enrichplot", "DOSE"))

