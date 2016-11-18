#make sure that devtools are installed
if (!requireNamespace('devtools')){
  install.packages('devtools')
  requireNamespace('devtools')
}
install_git('https://github.com/karchjd/gppmr')
