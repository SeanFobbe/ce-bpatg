

#' @param x A list with the relevant entries.
#' @param dir The directory to write the LaTeX definitions file to.
#'
#' @return The filename of a file containing definitions of LaTex commands.


f.latexdefs <- function(x,
                        datestamp,
                        dir){


    ## Make Definitions
    latexdefs <- c("%===========================\n% Definitions \n%===========================",
                   "\n% NOTE: This file was created automatically. Do not change it by hand.\n",
                   "\n%-----Author-----",
                   latexcommand("projectauthor", x$project$author),
                   
                   "\n%-----Version-----",
                   latexcommand("version", datestamp),
                   
                   "\n%-----Titles-----",
                   latexcommand("datatitle", x$project$fullname),
                   latexcommand("datashort", x$project$shortname),
                   latexcommand("softwaretitle",
                                paste0("Source Code des \\enquote{", x$project$fullname, "}")),
                   latexcommand("softwareshort", paste0(x$project$shortname, "-Source")),
                   
                   "\n%-----Data DOIs-----",
                   latexcommand("dataconceptdoi", x$doi$data$concept), 
                   latexcommand("dataversiondoi", x$doi$data$version),
                   latexcommand("dataconcepturldoi",
                                paste0("https://doi.org/", x$doi$data$concept)),
                   latexcommand("dataversionurldoi",
                                paste0("https://doi.org/", x$doi$data$version)),
                   
                   "\n%-----Software DOIs-----",
                   latexcommand("softwareconceptdoi", x$doi$software$concept),
                   latexcommand("softwareversiondoi", x$doi$software$version), 
                   latexcommand("softwareconcepturldoi",
                                paste0("https://doi.org/", x$doi$software$concept)),
                   latexcommand("softwareversionurldoi",
                                paste0("https://doi.org/", x$doi$software$version)),
                   
                   "\n%-----Additional DOIs-----",
                   latexcommand("aktenzeichenurldoi",
                                paste0("https://doi.org/", x$doi$aktenzeichen)),
                   latexcommand("personendatenurldoi",
                                paste0("https://doi.org/", x$doi$personendaten))
                   )





    ## Write LaTeX Parameters to disk

    writeLines(latexdefs,
               file.path(dir, paste0(x$project$shortname,
                                     "_Definitions.tex")))


    
}


