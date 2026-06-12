# Date and duration arithmetic on an annual grid for R
#
# This file is licensed to you under the MIT License.
#
# Copyright (c) Tim Gordon

test_that("pillar_shaft methods work", {
  skip_if_not_installed("pillar")
  expect_s3_class(pillar::pillar_shaft(datey(2000)), "pillar_shaft")
  expect_s3_class(pillar::pillar_shaft(durationy(1)), "pillar_shaft")
  expect_s3_class(pillar::pillar_shaft(1000 %to% 1001), "pillar_shaft")
})
