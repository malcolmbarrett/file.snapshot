test_that("snapshot files works", {
  # this file doesn't exist
  expect_snapshot_file("doesnt-exist.R")

  # this file exists at the root level
  #nothing happens
  expect_snapshot_file("hello.R")

  # using an absolute path does work
  expect_snapshot_file(usethis::proj_path("hello.R"), "hello2.R")

  # this file exists in the test directory
  expect_snapshot_file("test-file-snapshot.R")
})

test_that("different directory works", {
  root_dir <- getwd()
  dir <- withr::local_tempdir()
  setwd(dir)
  withr::local_options(usethis.quiet = TRUE)
  old_proj <- usethis::proj_set(dir, force = TRUE)
  withr::defer(usethis::proj_set(old_proj))

  # even absolute path doesn't work in a different working directory than proj?
  expect_snapshot_file(usethis::proj_path("hello_again.R"))

  # the example from the docs doesn't work, either
  save_png <- function(code, width = 400, height = 400) {
    path <- tempfile(fileext = ".png")
    png(path, width = width, height = height)
    on.exit(dev.off())
    code

    path
  }

  # fails
  expect_snapshot_file(save_png(hist(mtcars$mpg)), "plot.png")

  # but setting back to the project directory works
  setwd(root_dir)
  usethis::proj_set(old_proj)
  expect_snapshot_file(usethis::proj_path("hello_again.R"), "hello_again2.R")
  expect_snapshot_file(save_png(hist(mtcars$mpg)), "plot2.png")
})
