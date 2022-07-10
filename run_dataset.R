# Run full data set pipeline

dir.create("output", showWarnings = FALSE)

rmarkdown::render("CE-BPatG_Compilation.Rmd",
                  output_file = paste0("output/CE-BPatG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"))

