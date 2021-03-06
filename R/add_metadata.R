#' Add metadata
#'
#' @param P profile.data
#' @param metadata data.frame with new metadata columns
#' @param join_cols columns on which to join
#' @param ... additional parameters

add_metadata <- function(P, ...)
  UseMethod("add_metadata")


#' @describeIn add_metadata Add metadata to profile.data object

add_metadata.profile.data <- function(P, metadata, join_cols, ...) {
  testthat::expect_is(P, "profile.data")
  testthat::expect_true(all(join_cols %in% names(metadata)))
  testthat::expect_true(all(join_cols %in% names(meta(P))))
  common_columns <- setdiff(intersect(names(meta(P)), names(metadata)),
                            join_cols)
  testthat::expect_equal(length(common_columns), 0)

  # TODO: This throws a warning "joining character vector and factor, coercing
  # into character vector"
  metadata_1 <- dplyr::left_join(P$metadata, metadata, by = join_cols)
  testthat::expect_equal(nrow(metadata_1), nrow(meta(P)))
  testthat::expect_true(all(names(P$metadata) %in% names(metadata_1)),
                        info = setdiff(names(meta(P)), names(metadata_1)))
  P$metadata <- metadata_1

  P
}
