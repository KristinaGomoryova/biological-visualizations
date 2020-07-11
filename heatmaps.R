#################################################### STATIC OR INTERACTIVE HEATMAPS ##################################################
# for interactive graphics use plotly package
# library(plotly)

# data input
# table: first column contains gene names; all next columns contain counts in particular conditions (e.g. for individual patients)

# save from excel as tab delimited file (.txt), copy to appropriate folder!
# if you have chr instead of num, use read.delim2
data <- read.delim("RNAseq4col_upd.txt", stringsAsFactors = FALSE)

# check if you have appropriate structure, if gene names are "chr" and reads are "num"
# if not, read data again and use read.delim2 as stated above
str(data)

# transforming dataframe to numeric matrix
# assuming first column is gene names (IDs), other columns are reads from patients
# matrix requires numeric values only, therefore we exclude the first column
mat <- as.matrix(data[,2:ncol(data)])

# check if the column names are ok
colnames(mat)

# we assign the gene names to particular rows
rownames(mat) <- data[,1]

# heatmap plotting
heatmap(mat)

# for interactive graphics use plotly
# to change the color scale, change zmin and/or zmax parameters
p <- plot_ly(x=colnames(mat), y=rownames(mat),z = mat, type = "heatmap", zauto = FALSE, zmin = 000, zmax = 100)
p

# for saving use the Plots panel -> Export (in case you used static heatmap (heatmap command))
# save plot as HTML file - in case you used plot_ly
htmlwidgets::saveWidget(as.widget(p), "plot_name.html") 