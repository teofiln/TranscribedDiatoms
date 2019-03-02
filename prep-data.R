#prep the data
library("tidyverse")
library("ape")

ttomes <- read_csv("alverson_mmetsp_log_summaries.csv")
clades <- read_csv("coded.taxa.v10.2.csv") %>% select(Genus=New_genus, Clade) %>% unique

Capitalize <- function(x) {
  paste(toupper(substring(x,1,1)), substring(x,2), sep="")
}

clades <- apply(clades, 2, Capitalize) %>% tbl_df()
colnames(clades) <- tolower(colnames(clades))
clades$genus[clades$genus=="Pseudonitzschia"] <- "Pseudo-nitzschia"
clades$genus[clades$genus=="Tetrampora"] <- "Tetramphora"

ttomes$genus <- Capitalize(ttomes$genus)
ttomes$genus[ttomes$genus == "Cosc"] <- "Coscinodiscus"
ttomes$genus[ttomes$genus == "Haslea?"] <- "Haslea"
ttomes$genus[ttomes$genus == "Ceratualina"] <- "Cerataulina"
ttomes$genus[ttomes$genus == "Pseudoauliscus"] <- "Pseudauliscus"
ttomes$genus[ttomes$genus == "NANA"] <- NA

# I think these are the correct names, but keep original for now
#ttomes$genus[ttomes$genus == "Amphiprora"] <- "Entomoneis"
#ttomes$genus[ttomes$genus == "Microtabella"] <- "Hyalosira"

ttomes$genus[!ttomes$genus %in% clades$genus]

ttomes_clades <- left_join(ttomes, clades, by="genus")
dim(ttomes_clades)
dim(ttomes)

# populate the missing clades manually
ttomes_clades$clade[ttomes_clades$genus %in% c("Proschkinia", "Rhoiconeis", "Donkinia")] <- "Naviculoid"
ttomes_clades$clade[ttomes_clades$genus == "Amphiprora"] <- "Surirelloid"
ttomes_clades$clade[ttomes_clades$genus %in% c("Craspedostauros", "Staurotropis")] <- "Nitzchioid"
ttomes_clades$clade[ttomes_clades$genus %in% c("Astartiella", "Anorthoneis", "Kolbesia")] <- "Cocconeid"
ttomes_clades$clade[ttomes_clades$genus == "Staurophora"] <- "Cymbelloid"
ttomes_clades$clade[ttomes_clades$genus == "Meridion"] <- "Diatomoid"
ttomes_clades$clade[ttomes_clades$genus == "Microtabella"] <- "Rhabdonemoid"
# singletons?
ttomes_clades$clade[ttomes_clades$genus == "Schizostauron"] <- "Capartogramma"
ttomes_clades$clade[ttomes_clades$genus == "Decussata"] <- "Decussata"
ttomes_clades$clade[ttomes_clades$genus == "Amblyamphora"] <- "Amblyamphora"
ttomes_clades$clade[ttomes_clades$genus == "Sternimirus"] <- "Sternimirus"
ttomes_clades$clade[ttomes_clades$genus == "Raphid"] <- "Raphid_Incertae_Sedis"
ttomes_clades$clade[is.na(ttomes_clades$genus)] <- "Raphid_Incertae_Sedis"

ttomes_clades %>% filter(is.na(clade)) %>% select(genus, species, clade)
dim(ttomes_clades)

colnames(ttomes_clades) <- Capitalize(colnames(ttomes_clades)) %>% 
  gsub("_", " ", .) %>% gsub("\\(", "", .) %>% gsub("\\)", "", .) %>% gsub("\\+", " and ", .)

glimpse(ttomes_clades)

save(ttomes_clades, file='ttomes_clades.Rsave') 

# make a backbone tree
groups <- read_csv("coded.taxa.v10.2.csv") %>% select(Clade, Informal_name) %>% unique

# 'centrics'
CC <- groups %>% filter(Informal_name=="Centric") %>% select(Clade) %>% unlist %>% unname
paste(CC[10], CC[13], CC[11], CC[7], CC[12], CC[2], CC[5], CC[1], CC[3], CC[4], CC[8], CC[9], CC[6], "Pennates", sep=",")
CCT <- "(parmales,((leptocylindroid,corethron),(melosiroid,((rhizosolenioid,coscinodiscoid),(toxariid,(chaetoceroid,((eupodiscoid,cymatosiroid),(thalassiosiroid,lithodesmioid)))),(biddulphioid,Pennates)))));"
CCTT <- read.tree(text=CCT)
CCTT$tip.label <- Capitalize(CCTT$tip.label)
plot.phylo(CCTT)

# 'araphids'
AA <- groups %>% filter(Informal_name=="Araphid") %>% select(Clade) %>% unlist %>% unname
paste(AA[2], AA[11], AA[4], AA[7], AA[5], AA[8], AA[1], AA[10], AA[3], AA[9], AA[6], "Raphids", sep=",")
AAT <- "((asteroplanoid,((striatelloid,blekleyoid),plagiogrammoid)),((staurosiroid,(rhabdonemoid,(diatomoid,(licmophoroid,(cyclophoroid,(thalassionemoid,fragilarioid)))))),Raphids));"
AATT <- read.tree(text=AAT)
AATT$tip.label <- Capitalize(AATT$tip.label)
plot.phylo(AATT)

# raphids
RR <- groups %>% filter(Informal_name=="Raphid") %>% select(Clade) %>% unlist %>% unname
paste(RR[1], RR[3], RR[10], RR[16], RR[13], RR[12], RR[6], RR[7], RR[11], RR[14], RR[15], RR[18], RR[9], RR[5], RR[17], RR[2], RR[4], 
      RR[8], RR[19], RR[20], 'Capartogramma', 'Decussata', 'Sternimirus', 'Amblyamphora', 'Raphid', sep=',')

RRT <- "((nitzchioid,(eunotoid,(naviculoid,((sellaphoroid,pinnularioid),(neidioid,((amphoroid,(halamphoroid,(epithemioid,surirelloid))),((craticuloid,((mastogloioid,tetramphora),amphipleuroid)),(cocconeid,cymbelloid)))))))),oxyamphora,phaeodactylum,Capartogramma,Decussata,Sternimirus,Amblyamphora,Raphid_Incertae_Sedis);"
RRTT <- read.tree(text=RRT)
RRTT$tip.label <- Capitalize(RRTT$tip.label)
plot.phylo(RRTT)

# graft
ALLT <- bind.tree(CCTT, AATT, where = Ntip(CCTT))
ALLTT <- bind.tree(ALLT, RRTT, where = 25)
plot(ALLTT)

DROP <- ALLTT$tip.label[!ALLTT$tip.label %in% ttomes_clades$Clade]
ALLTT <- drop.tip(ALLTT, DROP)
save(ALLTT, file="clade_tree.Rsave")
