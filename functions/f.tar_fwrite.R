

#' Implements the data.table::fwrite function for use in the targets context. Mainly necessary to return the CSV file name for later tracking.
#'
#' @param x The data.table to be written to disk.
#' @param filename The filename of the CSV file.
#'
#' @param return The filename of the CSV file.



f.tar_fwrite <- function(x,
                         filename){


    data.table::fwrite(x,
                       file = filename,
                       na = "NA")

    return(filename)
    
}
