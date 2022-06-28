




f.tar_multihashes <- function(x,
                              multicore = TRUE,
                              cores = 2){


    ## Parallel Computing Settings
    if(multicore == TRUE){

        plan("multicore",
             workers = cores)
        
    }else{

        plan("sequential")

    }

    ## Calculate Hashes
    multihashes <- f.future_multihashes(x)
    


    
    #'## Transform to data.table
    setDT(multihashes)

    setnames(multihashes,
             old = "x",
             new = "filename")


    #'## Add Index
    multihashes$index <- seq_len(multihashes[,.N])
    

    return(multihashes)
    
}
