
#' @param url A vector of URLS.
#' @param filename A vector of filenames.
#' @param dir The destination directory. Will be created if not already present.
#' @param sleep.min Minimum number of seconds to randomly sleep between requests.
#' @param sleep.max Maximum number of seconds to randomly sleep between requests.
#' @param retries Number of retries for entire download set.
#' @param retry.sleep.min Minimum number of seconds to randomly sleep between requests in retry mode.
#' @param retry.sleep.max Maximum number of seconds to randomly sleep between requests in retry mode.
#' @param timeout Number of seconds for a download to timeout, even active ongoing ones.
#' @param debug.toggle Whether to activate debugging mode.
#' @param debug.files The number of files to download during debugging mode. Default is 500.

#' @return A vector of the downloaded file names.


f.download <- function(url,
                       filename,
                       dir,
                       sleep.min = 0,
                       sleep.max = 0.1,
                       retries = 3,
                       retry.sleep.min = 2,
                       retry.sleep.max = 5,
                       timeout = 300,
                       debug.toggle = FALSE,
                       debug.files = 500){
    
    ## Test for equality of length
    if(length(url) != length(filename)){

        stop("Length of arguments url and filename is not equal.")
        
    }

    ## Set timeout for downloads
    options(timeout = timeout)

    ## [Debugging Mode] Reduce download scope
    if (debug.toggle == TRUE){

        url <- url[sample(length(url), debug.files)]
        filename <- filename[sample(length(filename), debug.files)]

    }

    ## Create folder
    dir.create(dir, showWarnings = FALSE)

    ## Clean folder: Only files included in 'filename' may be present
    files.all <- list.files(dir, full.names = TRUE)
    delete <- setdiff(files.all, file.path(dir, filename))
    unlink(delete)

    ## Exclude already downloaded files
    files.present <- list.files(dir)
    filename.todo <- setdiff(filename, files.present)
    url.todo  <- url[filename %in% filename.todo]
    
    
    ## Download: First Try
    for (i in sample(length(url.todo))){
        tryCatch({download.file(url = url.todo[i],
                                destfile = file.path(dir,
                                                     filename.todo[i]))
        },
        error = function(cond) {
            return(NA)}
        )
        
        Sys.sleep(runif(1, sleep.min, sleep.max))
    }

    


    ## Download: Retries

    for(i in 1:retries){

        ## Missing files
        files.present <- list.files(dir)
        filename.missing <- setdiff(filename, files.present)
        url.missing  <- url[filename %in% filename.missing]

        if(length(filename.missing) > 0){
            
            for (i in 1:length(filename.missing)){
                
                response <- GET(url.missing[i])
                
                Sys.sleep(runif(1, 0.25, 0.75))
                
                if (response$status_code == 200){
                    tryCatch({download.file(url = url.missing[i],
                                            destfile = file.path(dir,
                                                                 filename.missing[i]))
                    },
                    error = function(cond) {
                        return(NA)}
                    )     
                }else{
                    message("Response code is not 200.")  
                }
                
                Sys.sleep(runif(1, retry.sleep.min, retry.sleep.max))
            } 
        }
        
    }

    if(length(filename.missing) > 0){

        warning(paste("Missing file:", filename.missing, collapse = "\n"))
        
    }


    ## Final File Count
    files.all <- list.files(dir, full.names = TRUE)

    message(paste("Downloaded", length(files.all), "of", length(filename), "files."))

    return(files.all)
    
}
