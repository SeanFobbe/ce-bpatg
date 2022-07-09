library(targets)

tar_destroy()


delete <- c("txt/",
            "pdf/",
            "temp/",
            "analysis/",
            "output/")



unlink(delete, recursive = TRUE)
