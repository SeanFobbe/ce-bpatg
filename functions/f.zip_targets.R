
f.zip_targets <- function(x,
                          filename,
                          dir,
                          mode = "mirror"){


    filename <- file.path(dir, filename)
    
    zip::zip(filename,
             x,
             mode = mode)

    return(filename)
    
}


