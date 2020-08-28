library(plyr)
library(dplyr)
library(factoextra)

normFunc <- function(x){(x-mean(x, na.rm = T))/sd(x, na.rm = T)}
set.seed(123)

setwd("~/OneDrive/Portfolio/Clustering_Ball_Players")

##########################
# Set up Data
cols=c('krate', 'bbrate','barrels','solids'
       ,'flares','topped','under','weak'
)

df<-read.csv('input/data_v6.csv',stringsAsFactors = FALSE)
df<-df[df$incl==1,]
player_names<-df$name
mdf<-df[,which((names(df) %in% cols)==TRUE)]
clust<-sapply(mdf,normFunc)
clust<-data.frame(clust)
rownames(clust)<-player_names
head(clust, n=3)

hopkins<-get_clust_tendency(clust, n = nrow(clust)-1, graph = FALSE)
hopkins$hopkins_stat
hopkins$plot
##########################
# Dendrograms
library(NbClust)
hd<-NbClust(data = clust, distance = "euclidean"
             , min.nc = 2, max.nc = 30, method = 'complete'
             , index = "all")
hddf<-cbind(hd$Best.partition, mdf)
colnames(hddf)[1]<-"cluster"
rownames(hddf)<-player_names
head(hddf, n=3)
sumy_hddf<-ddply(hddf,.(cluster),summarize,
                 count=length(cluster)
                 ,krate=mean(krate)
                 ,bbrate=mean(bbrate)
                 ,barrels=mean(barrels)
                 ,solids=mean(solids)
                 ,flares=mean(flares)
                 ,under=mean(under)
                 ,topped=mean(topped)
                 ,weak=mean(weak)
)
write.csv(sumy_hddf,"output/HCClusters.csv",row.names=FALSE)
write.csv(hddf, "output/HCResults.csv",row.names = TRUE)
print(hd$Best.nc)

library(ggdendrogram)
dend<- clust %>% dist(method = "euclidean") %>% 
  hclust( method="complete" )%>%as.dendrogram
dend<-dend %>%
  set("branches_k_color", value = c("steel blue", "darkorchid3","orange"), k = 3) %>%
  set("leaves_pch", 19)  %>% 
  set("nodes_cex", 0) %>%
  set("labels",c())
gg<-as.ggdend(dend)
ggplot(gg, horiz=TRUE)
## dendrogram manually saved

## Not Run
corc<-get_dist(clust, method = "pearson")
corc_p<-pamk(data=corc, krange=2:30, criterion = "asw", usepam=TRUE
             ,scaling = FALSE, diss=inherits(corc, "dist"))
corc_p$pamobject$silinfo$avg.width

##########################
library(cluster)
head(clust, n=3)
# NbClust
kms<-NbClust(data = clust, distance = "euclidean"
            , min.nc = 2, max.nc = 30, method = 'kmeans'
            , index = "all")
kmdf<-cbind(mdf, kms$Best.partition)
colnames(kmdf)[9]<-"cluster"
rownames(kmdf)<-player_names
head(kmdf, n=3)
sumy_kmdf<-ddply(kmdf,.(cluster),summarize,
                 count=length(cluster)
                 ,krate=mean(krate)
                 ,bbrate=mean(bbrate)
                 ,barrels=mean(barrels)
                 ,solids=mean(solids)
                 ,flares=mean(flares)
                 ,under=mean(under)
                 ,topped=mean(topped)
                 ,weak=mean(weak)
)
write.csv(sumy_kmdf,"output/KmeansClusters.csv",row.names=FALSE)
write.csv(kmdf, "output/KmeansResults.csv",row.names = TRUE)
print(kms$Best.nc)

km.res <- kmeans(clust, 2, nstart=25)
p<-fviz_cluster(km.res, clust,repel=FALSE,geom="point", shape = 19, alpha = 0.4)+
  scale_color_manual(values=c("steel blue","orange"),
                     labels=c("Power-Hitters","Table-Setters"))+
  scale_fill_manual(values=c("steel blue","orange"),
                    labels=c("Power-Hitters","Table-Setters"))+
  labs(title="K-Means Clusters")+
  theme_bw()+
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = 'bottom'
  )
p
ggsave("figs/kmeans_.png", p, width = 4, height = 4)
##########################
library(fpc)
# K-Mediods
head(clust, n=3)
cd_mink<-dist(clust, method = "minkowski", p = 0.34)
pammink<-pamk(data=cd_mink, krange=2:30, criterion = "asw", usepam=TRUE
            ,scaling = FALSE, diss=inherits(cd_mink, "dist"))
#pammink$pamobject$silinfo$avg.width

pam_c<-cbind(mdf, pammink$pamobject$clustering)
colnames(pam_c)[9]<-"cluster"
rownames(pam_c)<-player_names
head(pam_c, n=3)
sumy_pam<-ddply(pam_c,.(cluster),summarize,
                 count=length(cluster)
                 ,krate=median(krate)
                 ,bbrate=median(bbrate)
                 ,barrels=median(barrels)
                 ,solids=median(solids)
                 ,flares=median(flares)
                 ,under=median(under)
                 ,topped=median(topped)
                 ,weak=median(weak)
)
write.csv(sumy_pam,"output/KmediodsClusters.csv",row.names=FALSE)
write.csv(pam_c, "output/KmediodsResults.csv",row.names = TRUE)
write.csv(pammink$crit, "output/Kmediods_sil.csv", row.names=TRUE)

pm.res <- pam(x=cd_mink, k=2, diss=inherits(cd_mink, "dist"))
pm.res$data<-cd_mink
p<-fviz_cluster(pm.res, repel=FALSE,geom="point", shape = 19, alpha = 0.4)+
  scale_color_manual(values=c("steel blue","orange"),
                     labels=c("Power-Hitters","Table-Setters"))+
  scale_fill_manual(values=c("steel blue","orange"),
                    labels=c("Power-Hitters","Table-Setters"))+
  labs(title="K-Mediods Clusters")+
  theme_bw()+
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = 'bottom'
  )
p
ggsave("figs/kmediods_.png", p, width = 4, height = 4)
##########################
library(mclust)
# Gaussian
head(clust, n=3)
BIC<-Mclust(clust, G=1:10)
summary(BIC)
p<-fviz_mclust(BIC, "BIC", palette = "jco")
ggsave("figs/BIC_method.png", p, width = 7, height = 5)

p<-fviz_cluster(BIC, repel=FALSE, geom="point"
               ,shape = 19, alpha = 0.3, ellipse=TRUE, ellipse.type="euclid")+
  scale_color_manual(values=c("darkorchid3","steel blue","orange"),
                     labels=c("Platoon","Power-Hitters","Table-Setters"))+
  scale_fill_manual(values=c("darkorchid3","steel blue","orange"),
                    labels=c("Platoon","Power-Hitters","Table-Setters"))+
  labs(title="GMM Clusters")+
  theme_bw()+
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = 'bottom'
  )
p
ggsave("figs/gmm_.png", p, width = 4, height = 4)


gmm<-cbind(BIC$classification,mdf)
colnames(gmm)[1]<-"cluster"
rownames(gmm)<-player_names
sumy_bic<-ddply(gmm,.(cluster),summarize,
                count=length(cluster)
                ,krate=mean(krate)
                ,bbrate=mean(bbrate)
                ,barrels=mean(barrels)
                ,solids=mean(solids)
                ,flares=mean(flares)
                ,under=mean(under)
                ,topped=mean(topped)
                ,weak=mean(weak)
)
write.csv(sumy_bic,"output/GMMClusters.csv",row.names=FALSE)
prob_class<-data.frame(BIC$z)
colnames(prob_class)<-c("Table-Setters","Power-Hitters","Platoon")
write.csv(prob_class, "output/GMMResults.csv",row.names = TRUE)

##########################
# More plots?
library(FactoMineR)
res.pca<-PCA(clust, scale.unit = FALSE, ncp = 3, graph = FALSE)
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
var <- get_pca_var(res.pca)
p<-fviz_pca_var(res.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))+
    labs(color="Variable Importance", title="Biplot")+
    theme_bw()+
  theme(
    axis.text=element_text(color='black',size=14),
    axis.ticks.x = element_blank(),
    axis.title = element_text(color='black',size=14),
    plot.background = element_rect(fill = "transparent", colour = NA),
    legend.position = 'bottom',
    plot.title = element_text(hjust = 0.5, size=16),
    legend.title = element_text(size=15,color='black'),
    legend.text = element_text(size=10,color='black'),
    legend.background = element_rect(fill = "transparent"),
  )
p
ggsave("figs/biplot_.png", p, width = 10, height = 7)

ind <- get_pca_ind(res.pca)
pcadf<-ind$coord
pcadf<-cbind(BIC$classification,pcadf)
colnames(pcadf)[1]<-"cluster"
pcadf<-data.frame(pcadf)
colnames(pcadf)<-c("cluster","Dim1","Dim2","Dim3")
library(plot3D)
scatter3D(x=pcadf$Dim1, y=pcadf$Dim2, z=pcadf$Dim3, bty = "g", colvar=pcadf$cluster,
          colkey =F,
          col = c("orange","steel blue","darkorchid3"),
          pch = 18, ticktype = "detailed", xlab="Dim1(37.6%)",ylab="Dim2(18.4%)"
          ,zlab="Dim3(16.7%)")+
          labs(title="3D Visualization")
library(rgl)
plot3d(pcadf$Dim1, pcadf$Dim2, pcadf$Dim3, type="p", size=5, lit=FALSE, box=FALSE
       ,col=c("orange","steel blue","darkorchid3"),
       ,xlab="Dim1(37.6%)",ylab="Dim2(18.4%)",zlab="Dim3(16.7%)")