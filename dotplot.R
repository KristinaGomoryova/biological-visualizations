######################################### DOT PLOTS ############################################
# based on https://davemcg.github.io/post/lets-plot-scrna-dotplots/

# unique preys
markers <- data$prey %>% unique()

# dendrogram
mat <- data %>% 
  filter(prey %in% markers) %>% 
  select(bait, prey, rel) %>%  
  pivot_wider(names_from = bait, values_from = rel) %>% 
  data.frame() 

row.names(mat) <- mat$prey  
mat <- mat[,-1] 
clust <- hclust(dist(mat %>% as.matrix(), method = 'canberra'), method = 'ward.D') # hclust with distance matrix
# for clustering used default option for ProHITS Dotplot

ddgram <- as.dendrogram(clust) # create dendrogram
ggtree_plot <- ggtree::ggtree(ddgram)
ggtree_plot

# plot the dotplot
p <- data %>%
  mutate(PreyF = factor(prey, levels = clust$labels[clust$order])) %>% 
  filter(rel > 0) %>% 
  ggplot(aes(bait, PreyF))+
  geom_point(aes(fill = logFC, color = adjp_scale_fact, size = rel, stroke = border_thickness) , shape = 21 ) +  
  scale_fill_continuous(type = 'viridis') +
  scale_color_manual(values = c("#132B43", "#56B1F7", '#bbdffb'),
                     name = 'Significance',
                     labels = c('adj.pvalue <= 0.01', 'adj.pvalue > 0.01 & <=0.05', 'adj.pvalue > 0.05'))+
  scale_size_continuous(name = 'Relative abundance in %') + 
  scale_x_discrete(name="Baits") +
  scale_y_discrete(name="Preys") +
  coord_fixed(ratio = 0.95) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

plot_grid(ggtree_plot, NULL,p, nrow = 1, rel_widths = c(0.5,-0.05, 1), align = 'h')
