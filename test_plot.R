library(lavaan)
source("~/Dropbox/work/projects/_current/onyx_jamovi/lavaangui/plot_interactive.R")
HS.model <- ' visual  =~ 10*x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- lavaan::cfa(HS.model, data = HolzingerSwineford1939)
plot_interactive(fit)