
f.zip_targets <- function(x,
                          name.return,
                          mode = "mirror"){

    zip(name.return,
        x,
        mode = mode)

    return(name.return)
    
}


