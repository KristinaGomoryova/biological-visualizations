# Libraries required
library(plotly)
library(dplyr)
library(tidyverse)
library(lazyeval)
library(ggplot2)

data_volcano <- read.delim("data.txt", stringsAsFactors = FALSE)
str(data_volcano)

volcano_plot_interactive <- function (data, logFC, pvalue, annotation, plotname) {
  require(dplyr)
  require(lazyeval)
  require(plotly)
  logFC <- enquo(logFC)
  pvalue <- enquo(pvalue)
  annotation <- enquo(annotation)
  
  data1<- data %>%
    mutate(group = case_when(
      (abs(!!logFC) > 1 & !!pvalue > 0.05) ~ "|logFC| > 1",
      (abs(!!logFC) < 1 & !!pvalue < 0.05) ~ "pval < 0.05",
      (abs(!!logFC) > 1 & !!pvalue < 0.05) ~ "|logFC| >1 & pval < 0.05",
      TRUE ~ "NS"
    )) 
  
  gg<- ggplot(data1, aes(x=!!logFC, y=-log10(!!pvalue), color = group, text = !!annotation)) +
    geom_point()+
    theme_minimal()+
    labs(x= "log Fold Change", y = "-log10(adjusted pvalue)")
  
  ggp <- ggplotly(gg, tooltip = "text")
  
  name_file <- paste(plotname,".html", collapse = NULL)
  htmlwidgets::saveWidget(as_widget(ggp), name_file)
}

# volcano plots:
# data - logFC column - pvalue column - on hover annotation - plot name
volcano_plot_interactive(data_volcano, LIMMA_logFC, LIMMA_adj.P.Val, Gene.names, "intvolcanoplot")
