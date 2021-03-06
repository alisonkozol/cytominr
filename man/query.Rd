% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/query.R
\name{query}
\alias{query}
\alias{query.sim.mat}
\title{Query a similarity matrix}
\usage{
query(S, query_frame, equality_join_cols, ...)

\method{query}{sim.mat}(S, query_frame = NULL, equality_join_cols = NULL,
  return_all_cols = F, rename_value_to_metric = F, include_sim_name = F,
  ...)
}
\arguments{
\item{S}{sim.mat object}

\item{query_frame}{data.frame with query in each row}

\item{equality_join_cols}{list of column that should be equal}

\item{...}{additional parameters}

\item{return_all_cols}{If True, returns all columns of the query
result, else returns only the columns that were present in the query}

\item{rename_value_to_metric}{If True, rename the column name of the
similarity value to the name of the similarity metric}

\item{include_sim_name}{If True, include a column indicating the
name of the similarity metric}
}
\value{
data.frame of query result. The similarity value is stored in
\code{sim_val}
}
\description{
Query a similarity matrix
}
\section{Methods (by class)}{
\itemize{
\item \code{sim.mat}: Query a similarity matrix

Query can specified either by specifying a query frame or by specifying
columns that will tested for equality. This function will be rewritten once
this feature
'\url{https://github.com/hadley/dplyr/issues/557#issuecomment-127762110}
is implemented in \code{dplyr}
}}

