#' Constructor for profile.data S3 class
#'
#' @param cf YAML configuration file
#' @param use_csv If TRUE, force loading of CSV file even if binary exists
#' @param imetadata  data.frame containing metadata
#' @param ifeatdata  data.frame containing featdata
#'
#' @return profile.data object

profile.data <- function(cf = NULL,
                         use_csv = F,
                         imetadata = NULL,
                         ifeatdata = NULL) {

  testthat::expect_true(xor(is.null(cf),
                            is.null(imetadata) & is.null(ifeatdata)))
  if (!is.null(cf)) {
    # Load the configuration file
    testthat::expect_true(file.exists(cf))
    cfg <- yaml::yaml.load_file(cf)
    cfg$cwd <- dirname(cf)

    # construct names of associated files
    cf_name <- sapply(strsplit(basename(cf),"\\."),
                      function(x) paste(x[1:(length(x) - 1)], collapse = "."))
    cfg$profile_file <- paste(cf_name, "csv", sep = ".")
    cfg$profile_file_binary <- paste(cf_name, "rda", sep = ".")
    cfg$digest_file <- paste(cf_name, "digest", sep = ".")

    frda <- file.path(cfg$cwd, cfg$profile_file_binary)
    fcsv <- file.path(cfg$cwd, cfg$profile_file)
    fdig <- file.path(cfg$cwd, cfg$digest_file)

    # Read binary file, or if it doesn't exist, then csv.
    # Save binary file if it doesn't exist
    # Do checksum comparison to make sure its the right binary

    if (file.exists(frda) & !use_csv) {
      data0 <- readRDS(frda)
      digest_val <- readLines(fdig)
      testthat::expect_equal(digest_val, digest::digest(data0))
    } else {
      data0 <- data.frame(read.csv(fcsv, header = TRUE, stringsAsFactors = F))
      saveRDS(data0, file = frda)
      writeLines(digest::digest(data0), fdig)
    }
    testthat::expect_false("xid" %in% colnames(data0))

    # get the index of featdata and metadata columns
    testthat::expect_true(!is.null(cfg$feat_start))
    testthat::expect_is(cfg$feat_start, "integer")
    testthat::expect_more_than(cfg$feat_start, 1)
    metadata_cids <- seq(cfg$feat_start - 1)
    featdata_cids <- seq(cfg$feat_start, ncol(data0))
    metadata <- data0[metadata_cids]
    featdata <- data0[featdata_cids]
    testthat::expect_equal(ncol(featdata) + ncol(metadata), ncol(data0))
  }

  if (!is.null(imetadata) & !is.null(ifeatdata)) {
    testthat::expect_is(imetadata, "data.frame")
    testthat::expect_is(ifeatdata, "data.frame")
    testthat::expect_false("xid" %in% colnames(imetadata))
    testthat::expect_false("xid" %in% colnames(ifeatdata))
    metadata <- imetadata %>% as.data.frame() # in case it is tbl_df
    featdata <- ifeatdata %>% as.data.frame() # in case it is tbl_df
    cfg <- NULL
  }

  futile.logger::flog.debug("%s metadata columns", NCOL(metadata))
  futile.logger::flog.debug("%s featdata columns", NCOL(featdata))

  testthat::expect_equal(nrow(metadata), nrow(featdata))

  # add an idx column to metadata and featdata
  # idx for a row is a hash of the metadata in that row
  # this means that rows with identical metadata are not allowed
  # upon creation of the profile.data object

  metadata$xid <- sapply(tidyr::unite_(metadata,
                                       "xid",
                                       from = names(metadata))$xid,
                         digest::digest, USE.NAMES = F)
  featdata$xid <- metadata$xid

  # Create profile.data object
  obj <- list(cfg = cfg,
              metadata = metadata,
              featdata = featdata)

  class(obj) <- "profile.data"

  obj
}
