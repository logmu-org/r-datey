ensure_is_datey <- function(datey) {
  if (!is_datey(datey)) {
    arg_name <- deparse(substitute(datey))
    stop(paste0("The argument '", arg_name, "' must be a `datey`."))
  }
}

convert_datey_to_valid_clicks <- function(datey) {
  ensure_is_datey(datey)
  clicks <- unclass(datey)
  clicks <- ifelse(clicks >= 534360000L & clicks < 1603080000L, clicks, NA_integer_)
}

as_integer_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) {
    arg_name <- deparse(substitute(x))
    stop(paste0("The argument '", arg_name, "' must be numeric."))
  }
  as.integer(x)
}

as_double_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) {
    arg_name <- deparse(substitute(x))
    stop(paste0("The argument '", arg_name, "' must be numeric."))
  }
  as.double(x)
}
