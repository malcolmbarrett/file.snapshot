test_that("multiplication works", {
  save_png <- function(code, width = 400, height = 400) {
    path <- tempfile(fileext = ".png")
    png(path, width = width, height = height)
    on.exit(dev.off())
    code

    path
  }
  path <- save_png(plot(1:5))
  path

  expect_snapshot_file(save_png(hist(mtcars$mpg)), "plot.png")
})
