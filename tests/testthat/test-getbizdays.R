context("getbizdays")

test_that("getbizdays works with years", {
  dc <- getbizdays(2022, "actual")
  expect_equal(dc, 365)

  dc <- getbizdays(2022:2024, "actual")
  expect_equal(dc, c(365, 365, 366))
})

test_that("getbizdays works with year-month", {
  dc <- getbizdays("2022-12", "actual")
  expect_equal(dc, 31)

  dc <- getbizdays(paste0(2022, "-", 10:12), "actual")
  expect_equal(dc, c(31, 30, 31))
})

test_that("getbizdays works with dates", {
  dc <- getbizdays("2022-12", "actual")
  expect_equal(dc, 31)

  dc <- getbizdays("2022-12", "actual")
  expect_equal(dc, 31)

  dts <- seq(as.Date("2022-01-01"), as.Date("2022-12-01"), by = "months")
  dc <- getbizdays(format(dts, "%Y-%m"), "actual")
  expect_equal(dc, c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
})

test_that("massive test with getbizdays Brazil/B3 calendar", {
  bds <- c(
    241, 247, 247, 246, 245, 245, 248, 249, 246, 246,
    248, 246, 249, 250, 249, 249, 246, 245, 249, 246,
    247, 249, 246, 248, 248, 246, 249, 246, 245, 248,
    249, 247, 250, 248
  )

  expect_equal(getbizdays(1990:2023, "Brazil/B3"), bds)

  business_days_by_month <- matrix(
    c(
      21, 17, 19, 19, 22, 20, 22, 23, 19, 21, 20, 18,  # 1990
      21, 16, 19, 22, 21, 20, 23, 22, 21, 23, 20, 19,  # 1991
      22, 20, 19, 19, 20, 21, 23, 21, 21, 21, 20, 20,  # 1992
      19, 17, 23, 19, 21, 21, 22, 22, 21, 20, 20, 21,  # 1993
      20, 17, 22, 19, 22, 21, 20, 23, 21, 19, 20, 21,  # 1994
      21, 18, 22, 17, 22, 21, 21, 23, 20, 21, 20, 19,  # 1995
      21, 18, 21, 20, 22, 19, 23, 22, 21, 22, 20, 19,  # 1996
      22, 18, 19, 21, 20, 21, 22, 21, 22, 23, 20, 20,  # 1997
      21, 18, 22, 19, 20, 21, 22, 21, 21, 21, 20, 20,  # 1998
      19, 18, 23, 19, 21, 21, 21, 22, 21, 20, 20, 21,  # 1999
      20, 21, 21, 19, 22, 21, 21, 23, 20, 21, 20, 19,  # 2000
      21, 18, 22, 20, 22, 20, 21, 23, 19, 22, 20, 18,  # 2001
      21, 18, 20, 22, 21, 20, 22, 22, 21, 23, 20, 19,  # 2002
      22, 20, 19, 20, 21, 20, 22, 21, 22, 23, 20, 20,  # 2003
      21, 18, 23, 20, 21, 21, 21, 22, 21, 20, 20, 21,  # 2004
      20, 18, 22, 20, 21, 22, 21, 23, 21, 20, 20, 21,  # 2005
      21, 18, 23, 18, 22, 21, 21, 23, 20, 21, 19, 19,  # 2006
      21, 18, 22, 20, 22, 20, 21, 23, 19, 22, 19, 18,  # 2007
      21, 19, 20, 21, 20, 21, 22, 21, 22, 23, 19, 20,  # 2008
      21, 18, 22, 20, 20, 21, 22, 21, 21, 21, 19, 20,  # 2009
      19, 18, 23, 20, 21, 21, 21, 22, 21, 20, 20, 21,  # 2010
      20, 20, 21, 19, 22, 21, 21, 23, 21, 20, 20, 21,  # 2011
      21, 19, 22, 20, 22, 20, 21, 23, 19, 22, 19, 18,  # 2012
      21, 18, 20, 22, 21, 20, 22, 22, 21, 23, 19, 19,  # 2013
      22, 20, 19, 20, 21, 19, 22, 21, 22, 23, 19, 20,  # 2014
      21, 18, 22, 20, 20, 21, 22, 21, 21, 21, 19, 20,  # 2015
      19, 19, 22, 20, 21, 22, 21, 23, 21, 20, 20, 21,  # 2016
      21, 18, 23, 18, 22, 21, 21, 23, 20, 21, 19, 19,  # 2017
      21, 18, 21, 21, 21, 21, 21, 23, 19, 22, 19, 18,  # 2018
      21, 20, 19, 21, 22, 19, 22, 22, 21, 23, 19, 19,  # 2019
      22, 18, 22, 20, 20, 21, 23, 21, 21, 21, 20, 20,  # 2020
      19, 18, 23, 20, 21, 21, 21, 22, 21, 20, 20, 21,  # 2021
      21, 19, 22, 19, 22, 21, 21, 23, 21, 20, 20, 21,  # 2022
      22, 18, 23, 18, 22, 21, 21, 23, 20, 21, 20, 19   # 2023
    ),
    ncol = 12, byrow = TRUE
  )

  years <- 1990:2023
  rownames(business_days_by_month) <- years
  colnames(business_days_by_month) <- 1:12
  diffs <- business_days_by_month
  for (year in rownames(business_days_by_month)) {
    ref <- paste0(year, "-", stringr::str_pad(1:12, 2, pad = "0"))
    bdbm <- getbizdays(ref, "Brazil/B3")
    diffs[year,] <- bdbm - business_days_by_month[year,]
  }

  expect_true(all(diffs == 0))
})
