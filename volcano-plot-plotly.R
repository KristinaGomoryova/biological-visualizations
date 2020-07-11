
# libraries required  
# for interactive graphics you will need the plotly package and because of pipes also the dplyr package

install.packages("plotly") #by this command you'll install the plotly package. Comment it (with #) when the installation is finished
install.packages("dplyr") #by this command you'll install the plotly package. Comment it (with #) when the installation is finished

library(plotly) 
library(dplyr)

# data input
# We need columns with annotation, p values and logFC to create an interactive volcano plot
# prepare ideally a table containing these three columns, or later on rename particular columns with colnames() command

# if you export the data from Excel, don't forget to adjust the appropriate data types, ie not to have everything set on "general", but any words should be "text", any numbers should be "numbers"
# ideally copy the three columns and join them into one file
# save as Text (tabs delimited) file (.txt, values separated by tabulator)
# be sure your .txt file is in the same folder as the R project, otherwise you'll have to set absolute pathway
# getwd() is very handy command, you'll get the actual working directory

# be careful about the data input, if your decimal separator is ".", use read.delim, if it is ",", use read.delim2
# replace data.txt with your file

# this command reads your table into "data" variable; all text will be left as strings and not converted to factors
data <- read.delim2("data.txt", stringsAsFactors = FALSE)

# you can check whether the datadata has a correct structure; i.e. numeric columns are "num", text columns are "chr"
# if numeric columns are also chr, read again the table with read.delim command and check the structure again
head(data) 
str(data) 

==============================================================
  # make sure you change in the following scripts "logFC", "pvalue" and "annotation" to the real names of your columns!
  
  # add a grouping column, default value is "non-significant" 
  data["group"] <- "NS" 

# highliting FDR <0.05 (significance level - we use p value or adjusted pvalue) and Fold Change > 1.5 

# change the grouping for entries with significance, but not large enough fold change 
data[which(data['pvalue']< 0.05 & abs(data["logFC"]) < 1), "group"] <- "p val < 0.05" 

# change the grouping for entries with a large enough FC, but not a low enough p value 
data[which(data['pvalue']> 0.05 & abs(data["logFC"]) > 1), "group"] <- "|FC| > 1" 

# change the grouping for entries with both significance and large enough FC 
data[which(data['pvalue']< 0.05 & abs(data["logFC"]) > 1), "group"] <- "p val < 0.05 & |FC| > 1" 

# make the Plot.ly plot 
p <- plot_ly(data = data, x = data$logFC, y = -log10(data$pvalue), text = data$annotation, mode = "markers", color = data$group) %>%  
  layout(title ="Volcano Plot",
         xaxis = list(title='Log2 Fold Change'), 
         yaxis = list(title='-log10(pvalue)')) 

p 


#save plot as HTML file 
# change plot_name to the name you wish
htmlwidgets::saveWidget(as.widget(p), "plot_name.html") 
