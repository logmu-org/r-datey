as_integer_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) NA_integer_
  else if (is.integer(x)) x
  else if (is.double(x)) cpp_IntegralDoubleToInteger(x)
  else NA_integer_
}

as_double_for_cpp <- function(x) {
  # Exclude anything other than base numerics
  if (is.object(x) || !is.numeric(x)) NA_real_
  else if (is.double(x)) x
  else as.double(x)
}
