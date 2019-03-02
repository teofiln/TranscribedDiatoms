# make info text 

DD1 <- get(load('ttomes_clades.Rsave')) %>% 
  dplyr::select(`Num reads F and R`:`Num nuclear read pairs`, `Percent merged`:`BUSCOs percent`)

Names <- names(DD1)

i1 <- "Total number of forward and reverse reads per library after demultiplexing pooled Illumina sequencing libraries. We used these numbers to check whether we have sequenced at sufficient depth and whether there were any large-scale biases in pooling prior to sequencing."

i2 <- "Total number of bases in the raw reads corrected by `rcorrector`. This method analyzes the distributions of kmers in the RNAseq data, looking for very infrequent unique kmers which are considered putative sequencing errors."

i3 <- "Number of reads removed because they mapped against libraries of ribosomal, chloroplast and mitochondrial RNA or vector/plasmid sequences. ????"

i4 <- "Percent of total reads that mapped against the large ribosomal subunit rRNA (28S, LSU) of diatoms. This number is an indicator of the efficiency of the mRNA capture. We captured mRNA, and excluded rRNA, by selecting for RNA molecules with poly-A tails. A high proportion of ribosomal RNA (rRNA) is an indication that our mRNA capture was not very efficient."

i5 <- "Percent of total reads that mapped against the small ribosomal subunit rRNA (18S, SSU) of diatoms. This number is an indicator of the efficiency of the mRNA capture. We captured mRNA, and excluded rRNA, by selecting for RNA molecules with poly-A tails. A high proportion of ribosomal RNA (rRNA) is an indication that our mRNA capture was not very efficient."

i6 <- "Percent of total reads that mapped against the small ribosomal subunit rRNA (18S, SSU) of a broad range of species outside diatoms [we called these sequences Tree of Life (TOL) rRNA]. In addition to assessing the efficiency of the mRNA capture, this number provided an indication of the cohabitants and contaminants in our cultures. This includes potential symbiotic/mutualistic bacteria." 

i7 <- "Total number of read pairs (forward + reverse) that did not map to ribosomal RNA (both diatom and other), chloroplast, mitochondrial, or vector/plasmid sequences. This metric gave us an idea about the total amount of sequence data originating from the targetted mRNA transcriptome."

i8 <- "Percent of read pairs that originated from library fragments short enough such that the forward and reverse reads overlapped (after quality trimming). A higher fraction of merged reads suggests that many of the sequenced fragments were shorter than the total sequenced bases per fragment (most commonly 100bp + 100bp)."

i9 <- "Total number of contigs assembled by the Trinity assembler. This metric provided a measure of the total number of genes and isoforms expressed at the time of sequencing (after removing non-target RNA). A very large number of contigs might also indicate a lower quality library or assembly."

i10 <- "Total number of assembled bases by the Trinity assembler."

i11 <- "The fraction of Guanines (G) and Cytosines (C) within the assembled contigs. For diatom mRNA, this number is typically near or just below 50%. Higher fractions of GC might indicate bacterial contamination. ????"

i12 <- "The N50 is a measure of the contiguity of the assembly. It indicates the length of the contig which, together with longer contigs, comprise half of the entire assembly." 
#<a href="https://en.wikipedia.org/wiki/N50,_L50,_and_related_statistics">Wikipedia</a>"

i13 <- "The proportion of read pairs mapping in a way indicative of a good assembly as measured by Transrate. 'Good mappings' are those where both members of a pair are mapped to the same contig in the correct orientation without overlapping either end of the contig. The higher this number, the better the assembly."

i14 <- "Percent of contigs with BLAST hits to the Phaeodactylum tricornutum reference transcriptome. This is output from the Conditional Reciprocal Best Blast (CRBB) analysis part of the Transrate pipeline. Contigs with CRBB hits can be considered as high-confidence homologs."

i15 <- "The Transrate score is a measure of the quality of the assembly composed of all steps in the Transrate pipeline (including the proportion of good mappings and the CRBB analyses). This score provides some measure of confidence in the assembly and its completeness. The score ranges between 0 (poor) and 1.0 (good)."

i16 <- "The BUSCO pipeline is assessing assembly and annotation completeness with Benchmarking Universal Single-Copy Orthologs. The number of complete and fragmented BUSCOs is a homology-based measure of the completeness of an assembly. It indicates the number of genes conserved across eukaryotes(?) (HOW MANY WHICH DB?) that are also present (complete or partially) in the tested transcriptome."

i17 <- "The BUSCO pipeline is assessing assembly and annotation completeness with Benchmarking Universal Single-Copy Orthologs. The percent of BUSCOs present is a homology-based measure of the completeness of an assembly. It indicates the fraction of genes conserved across eukaryotes(?) that are also present (complete or partially) in the tested transcriptome."
  
II <- paste("i", 1:17, sep="")

ii <- lapply(II, get)

names(ii) <- Names[1:length(ii)]

save(ii, file = "metric_info.Rsave")
