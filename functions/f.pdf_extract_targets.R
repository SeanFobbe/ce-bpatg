#' Parallel extraction of PDF to TXT.

#' @param x A vector of PDF filenames.
#' @param outputdir The directory to store the extracted TXT files in.

f.pdf_extract_targets <- function(x,
                                  outputdir){
    
    unlink("txt", recursive = TRUE)
    dir.create("txt")

    plan(multicore,
         workers = availableCores())
    
    pdf_extract(x,
                outputdir = "txt")

    files.txt <- list.files("txt", pattern = "\\.txt", full.names = TRUE)

    return(files.txt)
    
}
