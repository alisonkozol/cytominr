
cpseedseq <- read.csv("inst/extdata/well-summary-profile_mean-median-robust_std-untreated_norm.csv", stringsAsFactors = F)
cpseedseq <- cpseedseq[cpseedseq$MultipleHairpin_2013_03_07_Analysis_Per_Image.Image_Metadata_Plate
                       %in% c(38034, 38003, 37983),]
devtools::use_data(cpseedseq)
