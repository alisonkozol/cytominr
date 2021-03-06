context("Test add_metadata")

metadata_fname <-
  system.file("extdata",
              "clone_search_hairpins.csv",
              package = "cytominr")

metadata <- read.csv(metadata_fname, stringsAsFactors = F)
metadata %<>% dplyr::rename(shRNA_CloneID = Clone.ID)

test_that("Adding new metadata works as expected", {
  expect_is(add_metadata(cpseedseq_prf,
                         metadata,
                         join_cols = "shRNA_CloneID"), "profile.data")

  cpseedseq_prf_1 <- add_metadata(cpseedseq_prf,
                                  metadata,
                                  join_cols = "shRNA_CloneID")

  expect_true(all(names(metadata) %in% names(meta(cpseedseq_prf_1))))
  expect_equal(nrow(meta(cpseedseq_prf)), nrow(meta(cpseedseq_prf_1)))
  expect_true("xid" %in% names(cpseedseq_prf$metadata))
  expect_true("xid" %in% names(cpseedseq_prf_1$metadata))

})
