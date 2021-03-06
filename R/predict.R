pathLength <- function(x, Tree, e=0, ni=0) {
  pathLength_cpp(x, Tree, e=0, ni=0)
}

#' @title predcit.iForest
#' @description predict.iForest is a method of the predict generic function.
#' @param object an \code{iForest} object
#' @param newdata a dataset to predict
#' @param type predict can export the anamoly score, a list of nodes, or the terminal nodes
#' @export
predict.iForest <- function(object, newdata, ..., nodes = FALSE, sparse = FALSE) {

  if (!is.data.frame(newdata)) newdata <- as.data.frame(newdata)

  ## check column types
  classes = vapply(newdata, class, FUN.VALUE = "")
  if (!all(classes %in% c("numeric","factor","integer"))) {
    stop("newdata contains classes other than numeric, factor, and integer")
  }

  ## check for missing values
  for (k in seq_along(newdata)) {
    if (any(is.na(newdata[k]))) stop("Missing values found in newdata")
  }

  ## check for column name mismatches
  i = match(object$vNames, names(newdata))
  if (any(is.na(i))) {
    m = object$vNames[!object$vNames %in% names(newdata)]
    stop(strwrap(c("Variables found in model not found in newdata: ",
      paste0(m, collapse = ", ")), width = 80, prefix = " "), call. = F)
  }

  if (sparse) {
    predict_iForest_sparse_nodes(newdata, object)
  } else if (nodes) {
    predict_iForest_nodes_cpp(newdata, object)
  } else {
    predict_iForest_pathLength_cpp(newdata, object)
  }
}
