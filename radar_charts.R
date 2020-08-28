library(ggradar)
km_<-read.csv("output/KmeansClusters.csv")
colnames(km_)<-c("cluster","count",'K%','BB%','Barrel%','Solid%'
                 ,'Flares%','Under%','Topped%','Weak%')
km_c1<-km_$count[km_$cluster==1]
km_c2<-km_$count[km_$cluster==2]
km_$count<-NULL
km_$cluster<-c("Table-Setters","Power-Hitters")
# plot with default options:
pk<-ggradar(plot.data = km_
            ,values.radar = c("0%", "20%", "40%")
            ,label.gridline.max = TRUE
            ,group.point.size = 2
            ,group.line.width = 1
            ,group.colours = c("steel blue","orange")
            ,grid.min = 0
            ,grid.mid = 0.2
            ,grid.max = 0.4
            ,grid.label.size = 4.5
            ,gridline.mid.colour = "grey"
            ,axis.label.size = 3.3
            ,background.circle.transparency = 0
)+
  labs(title="K-Means")+
  theme(plot.title = element_text(hjust = 0.5,size=12, margin=margin(0,0,-8,0)),
        plot.background = element_rect(fill = "transparent", colour = NA),
        legend.direction = "vertical",
        legend.position = "bottom",
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-40,-25,-25,-25),
        legend.text = element_text(size=10),
        legend.background = element_rect(fill="transparent"),
        legend.key = element_rect(size = 5),
        legend.key.size = unit(-1.5, "cm")
  )
pk
ggsave("figs/kmeans_radar.png", pk, width = 4, height = 4)
## K-mediods
kmed<-read.csv("output/KmediodsClusters.csv")
colnames(kmed)<-c("cluster","count",'K%','BB%','Barrel%','Solid%'
                  ,'Flares%','Under%','Topped%','Weak%')
kmedc1<-km_$count[km_$cluster==1]
kmedc2<-km_$count[km_$cluster==2]
kmed$count<-NULL
kmed$cluster<-c("Power-Hitters","Table-Setters")
# plot with default options:
pkmed<-ggradar(plot.data = kmed
               ,values.radar = c("0%", "20%", "40%")
               ,label.gridline.max = TRUE
               ,group.point.size = 2
               ,group.line.width = 1
               ,group.colours = c("steel blue","orange")
               ,grid.min = 0
               ,grid.mid = 0.2
               ,grid.max = 0.4
               ,grid.label.size = 4.5
               ,gridline.mid.colour = "grey"
               ,axis.label.size = 3.3
               ,background.circle.transparency = 0
)+
  labs(title="K-Medoids")+
  theme(plot.title = element_text(hjust = 0.5,size=12, margin=margin(0,0,-8,0)),
        plot.background = element_rect(fill = "transparent", colour = NA),
        legend.direction = "vertical",
        legend.position = "bottom",
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-40,-25,-25,-25),
        legend.text = element_text(size=10),
        legend.background = element_rect(fill="transparent"),
        legend.key = element_rect(size = 5),
        legend.key.size = unit(-1.5, "cm")
  )
pkmed
ggsave("figs/kmedoids_radar.png", pkmed, width = 4, height = 4)

## HC
hc<-read.csv("output/HCClusters.csv")
colnames(hc)<-c("cluster","count",'K%','BB%','Barrel%','Solid%'
                ,'Flares%','Under%','Topped%','Weak%')
hcc1<-hc$count[hc$cluster==1]
hcc2<-hc$count[hc$cluster==2]
hcc3<-hc$count[hc$cluster==3]
hc$count<-NULL
hc$cluster<-c("Platoon","Power-Hitters","Table-Setters")
# plot with default options:
phc<-ggradar(plot.data = hc
             ,values.radar = c("0%", "20%", "40%")
             ,label.gridline.max = TRUE
             ,group.point.size = 2
             ,group.line.width = 1
             ,group.colours = c("darkorchid3","steel blue","orange")
             ,grid.min = 0
             ,grid.mid = 0.2
             ,grid.max = 0.4
             ,grid.label.size = 4.5
             ,gridline.mid.colour = "grey"
             ,axis.label.size = 3.3
             ,background.circle.transparency = 0
)+
  labs(title="Hierarchical Clusters")+
  theme(plot.title = element_text(hjust = 0.5,size=12, margin=margin(0,0,-8,0)),
        plot.background = element_rect(fill = "transparent", colour = NA),
        legend.direction = "vertical",
        legend.position = "bottom",
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-40,-25,-25,-25),
        legend.text = element_text(size=10),
        legend.background = element_rect(fill="transparent"),
        legend.key = element_rect(size = 5),
        legend.key.size = unit(-1.5, "cm")
  )
phc
ggsave("figs/hc_radar.png", phc, width = 4, height = 4.5)

## GMM
gmm<-read.csv("output/GMMClusters.csv")
colnames(gmm)<-c("cluster","count",'K%','BB%','Barrel%','Solid%'
                 ,'Flares%','Under%','Topped%','Weak%')
gmmc1<-gmm$count[gmm$cluster==1]
gmmc2<-gmm$count[gmm$cluster==2]
gmmc3<-gmm$count[gmm$cluster==3]
gmm$count<-NULL
gmm$cluster<-c("Table-Setters","Power-Hitters","Platoon")
# plot with default options:
pgmm<-ggradar(plot.data = gmm
              ,values.radar = c("0%", "20%", "40%")
              ,label.gridline.max = TRUE
              ,group.point.size = 2
              ,group.line.width = 1
              ,group.colours = c("darkorchid3","steel blue","orange")
              ,grid.min = 0
              ,grid.mid = 0.2
              ,grid.max = 0.4
              ,grid.label.size = 4.5
              ,gridline.mid.colour = "grey"
              ,axis.label.size = 3.3
              ,background.circle.transparency = 0
)+
  labs(title="GMM Clusters")+
  theme(plot.title = element_text(hjust = 0.5,size=12, margin=margin(0,0,-8,0)),
        plot.background = element_rect(fill = "transparent", colour = NA),
        legend.direction = "vertical",
        legend.position = "bottom",
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-40,-25,-25,-25),
        legend.text = element_text(size=10),
        legend.background = element_rect(fill="transparent"),
        legend.key = element_rect(size = 5),
        legend.key.size = unit(-1.5, "cm")
  )
pgmm
ggsave("figs/gmm_radar.png", pgmm, width = 4, height = 4.5)