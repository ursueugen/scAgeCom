# Utils

create_dir <- function(dir) {
  if (!(dir.exists(dir))) {
    dir.create(dir)
  } else {
    stop("Directory already exists.")
  }
}


copy_config <- function(dir) {
  
  if ( !file.exists("config.yml") ) {
    stop("config.yml not found.")
  }
  
  if ( !(dir.exists(dir)) ) {
    stop("Directory already exists.")
  } else {
    file.copy("config.yml", dir)
  }
}


read_explorecutoffs_arg <- function() {
  
  option_list = list(
    make_option(c("--explorecutoffs"), type="character", default=NULL, 
                help="directory where to explore-cutoff", metavar="character")
  ); 
  
  opt_parser = OptionParser(option_list=option_list);
  opt = parse_args(opt_parser);
  
  if (is.null(opt$explorecutoffs)){
    return(NULL)
  } else {
    return(opt$explorecutoffs)
  }
}


save_list_dfs <- function(l, dir) {
  
  is_not_list = !(class(l) == "list")
  is_first_not_df = (class(l[[1]]) != "data.frame")
  
  if ( is_not_list | is_first_not_df) {
    stop("Input must be list of dfs.")
  }
  
  create_dir(dir)
  
  for (name in names(l)) {
    
    df = l[[name]]
    
    # The issue with below commented code is that some cell types have ',' in
    #  their names. One solution is to save as .tsv
    
    #    fname = paste(dir, name, ".csv", sep="")
    #    write.csv(df, fname, quote=FALSE, row.names=TRUE, col.names=TRUE)
    
    fname = paste(dir, name, ".tsv", sep="")
    write.table(df, fname, sep='\t', quote=FALSE, row.names=TRUE, col.names=TRUE)
  }
  
}


fetch_results = function(filtered_path, ora_path) {
  filtered = readRDS(filtered_path)
  ora = readRDS(ora_path)
  names(ora) = names(filtered)
  message('ora object is unnammed')
  return(list(
    filtered = filtered,
    ora = ora
  ))
}

add_dummy_tissue = function(results) {
  message(paste0('utils.R add_dummy_tissue: upgrade warning:',
                 'A constant tissue column `Tissue` with `DummyTissue` value is inserted',
                 'for backwards compatibility. Will be solved later'))
  
  DUMMY_TISSUE = 'DummyTissue'
  results$scdiffcom_dt_raw$Tissue = DUMMY_TISSUE
  results$scdiffcom_dt_filtered$Tissue = DUMMY_TISSUE
  results$ORA$Tissue = DUMMY_TISSUE
  return(results)
}