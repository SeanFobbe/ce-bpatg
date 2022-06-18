

#' @param x A vector of TXT files.
#'
#' @return A data.table containing the name of the TXT files, their content and the filename metadata.



f.readtext <- function(x,
                       docvarnames){


    ## Read TXT files with filename metadata    
    dt <- readtext(x,
                   docvarsfrom = "filenames", 
                   docvarnames = docvarnames,
                   dvsep = "_", 
                   encoding = "UTF-8")




    ## Coerce to Data.table
    setDT(dt)

    return(dt)

    
}

