#make sure that devtools are installed
if (!requireNamespace('devtools')){
  install.packages('devtools')
}
devtools::install_git('https://github.com/karchjd/gppmr')
