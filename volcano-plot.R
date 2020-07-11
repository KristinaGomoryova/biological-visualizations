# VOLCANO PlOT 

# libraries required
install.packages("dplyr") #by this command you'll install the plotly package. Comment it (with #) when the installation is finished
install.packages("calibrate") #by this command you'll install the plotly package. Comment it (with #) when the installation is finished

library(dplyr)
library(calibrate)

# data input
# We need columns with annotation, p values and logFC to create a static volcano plot
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

# make a basic volcano plot   
# use actual column names from your table! i.e. change "pvalue", "logFC" and "annotation" columns!
with(data, plot(logFC, -log10(pvalue), pch=20, main="Volcano plot", xlim=c(-6,8))) 

# add colored points: red if p value <0.05, orange if log2FC >1, green if both 
# feel free to change the thresholds or coloring
with(subset(data, pvalue<.05 ), points(logFC, -log10(pvalue), pch=20, col="red")) 
with(subset(data, abs(logFC)>1), points(logFC, -log10(pvalue), pch=20, col="orange")) 

with(subset(data, pvalue<.05 & abs(logFC)>1), points(logFC, -log10(pvalue), pch=20, col="green")) 

# points labeling correspoding to protein IDs 
with(subset(data, pvalue<.05 & abs(logFC)>1), textxy(logFC, -log10(pvalue), labs=annotation, cex=.4)) 

# you can save the plot directly from the viewer