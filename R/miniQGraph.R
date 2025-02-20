addTrans <- function(color,trans)
{
  # This function adds transparancy to a color.
  # Define transparancy with an integer between 0 and 255
  # 0 being fully transparant and 255 being fully visable
  # Works with either color and trans a vector of equal length,
  # or one of the two of length 1.
  
  if (length(color)!=length(trans)&!any(c(length(color),length(trans))==1)) stop("Vector lengths not correct")
  if (length(color)==1 & length(trans)>1) color <- rep(color,length(trans))
  if (length(trans)==1 & length(color)>1) trans <- rep(trans,length(color))
  
  num2hex <- function(x)
  {
    hex <- unlist(strsplit("0123456789ABCDEF",split=""))
    return(paste(hex[(x-x%%16)/16+1],hex[x%%16+1],sep=""))
  }
  rgb <- rbind(grDevices::col2rgb(color),trans)
  res <- paste("#",apply(apply(rgb,2,num2hex),2,paste,collapse=""),sep="")
  return(res)
}

ELLIPSEPOLY <- list(
  x = sin(seq(0, 2*pi, length = 200)),
  y = cos(seq(0, 2*pi, length = 200))
)

HEARTPOLY <- structure(list(x = c(0.000524613718038136, 0.00152037576817299, 
                                  0.00837191368505907, 0.0263525265968505, 0.0596231845491932, 
                                  0.110803218240353, 0.180680475594751, 0.268087394223726, 0.369954594919716, 
                                  0.481537715428025, 0.596797695163824, 0.70890097596103, 0.810795329588381, 
                                  0.895810220726289, 0.95822837243697, 0.993777720620083, 1, 0.976463167095426, 
                                  0.924798756665914, 0.848560847051974, 0.752919185599284, 0.644213780440664, 
                                  0.529410581862747, 0.415506655649061, 0.308937708512294, 0.21504056435074, 
                                  0.137618233447556, 0.0786460081162648, 0.0381443807024719, 0.0142296425596522, 
                                  0.0033371202850081, 0.000596558943702696, 0.000325551274901859, 
                                  -0.00340364703380058, -0.0161751396581412, -0.0426714553619016, 
                                  -0.0861970864784513, -0.148326642404516, -0.22870961369511, -0.325049731954249, 
                                  -0.433261288308903, -0.547788934599377, -0.662062851652114, -0.769049036210921, 
                                  -0.861845916483694, -0.934274319260742, -0.981408353675419, -1, 
                                  -0.988759630359335, -0.948467499354436, -0.881906282519685, -0.79362066640824, 
                                  -0.689525383893214, -0.576396567854278, -0.461291662282501, -0.350949456597994, 
                                  -0.251223532033918, -0.166599374905229, -0.0998378919663984, 
                                  -0.0517767300327744, -0.0213066683594325, -0.00552468083396929, 
                                  -4.94560549954004e-05), y = c(0.520897709618179, 0.534947678325485, 
                                                                0.575452559134198, 0.637673315472304, 0.714338676813725, 0.796497437137179, 
                                                                0.87454802681761, 0.939310336192077, 0.98300223008988, 1, 0.987295403433758, 
                                                                0.944606765832239, 0.874151080567606, 0.78013077798753, 0.66802603706674, 
                                                                0.543805951388826, 0.413176650345883, 0.28097147888861, 0.15076013428112, 
                                                                0.024715092692505, -0.0962689496523439, -0.212246769666327, -0.323760566618399, 
                                                                -0.43133676232965, -0.535035885584381, -0.634135831892105, -0.727002022607152, 
                                                                -0.811163164401614, -0.883574411157736, -0.941016958598965, -0.980559871117998, 
                                                                -1, -0.998200691457891, -0.975268605096653, -0.932537068881262, 
                                                                -0.872358940152541, -0.797745974695624, -0.711919363179301, -0.617852572062957, 
                                                                -0.517889982248489, -0.413512473049402, -0.305295947111203, -0.193074914032843, 
                                                                -0.0762862599001901, 0.045565535450107, 0.172405369550093, 0.303141763887568, 
                                                                0.435369118261749, 0.565288730801492, 0.687886497384175, 0.79736440992733, 
                                                                0.887780569712151, 0.953815194758073, 0.99155416691318, 0.999171547693052, 
                                                                0.977400335131055, 0.929705927528264, 0.86211598567256, 0.782708083545859, 
                                                                0.700805731636508, 0.625976704926773, 0.566958524171822, 0.530649611127533
                                  )), .Names = c("x", "y"))

STARPOLY = structure(list(x = c(0, 0.0123744263640521, 0.0247488527281041, 
                                0.0371232790921562, 0.0494977054562083, 0.0618721318202603, 0.0742465581843124, 
                                0.0866209845483645, 0.0989954109124165, 0.111369837276469, 0.123744263640521, 
                                0.136118690004573, 0.148493116368625, 0.160867542732677, 0.173241969096729, 
                                0.185616395460781, 0.197990821824833, 0.210365248188885, 0.222739674552937, 
                                0.235114100916989, 0.235114100916989, 0.272795280673735, 0.31047646043048, 
                                0.348157640187226, 0.385838819943971, 0.423519999700717, 0.461201179457462, 
                                0.498882359214208, 0.536563538970953, 0.574244718727699, 0.611925898484444, 
                                0.64960707824119, 0.687288257997935, 0.724969437754681, 0.762650617511426, 
                                0.800331797268172, 0.838012977024917, 0.875694156781663, 0.913375336538408, 
                                0.951056516295154, 0.951056516295154, 0.921023152622675, 0.890989788950196, 
                                0.860956425277718, 0.830923061605239, 0.800889697932761, 0.770856334260282, 
                                0.740822970587804, 0.710789606915325, 0.680756243242847, 0.650722879570368, 
                                0.62068951589789, 0.590656152225411, 0.560622788552933, 0.530589424880454, 
                                0.500556061207976, 0.470522697535497, 0.440489333863019, 0.41045597019054, 
                                0.380422606518061, 0.380422606518061, 0.391336429979873, 0.402250253441684, 
                                0.413164076903495, 0.424077900365306, 0.434991723827117, 0.445905547288928, 
                                0.45681937075074, 0.467733194212551, 0.478647017674362, 0.489560841136173, 
                                0.500474664597984, 0.511388488059795, 0.522302311521606, 0.533216134983417, 
                                0.544129958445229, 0.55504378190704, 0.565957605368851, 0.576871428830662, 
                                0.587785252292473, 0.587785252292473, 0.556849186382343, 0.525913120472213, 
                                0.494977054562083, 0.464040988651953, 0.433104922741822, 0.402168856831692, 
                                0.371232790921562, 0.340296725011432, 0.309360659101302, 0.278424593191172, 
                                0.247488527281041, 0.216552461370911, 0.185616395460781, 0.154680329550651, 
                                0.123744263640521, 0.0928081977303905, 0.0618721318202603, 0.0309360659101302, 
                                4.89858719658941e-17, 4.89858719658941e-17, -0.0309360659101301, 
                                -0.0618721318202603, -0.0928081977303904, -0.123744263640521, 
                                -0.154680329550651, -0.185616395460781, -0.216552461370911, -0.247488527281041, 
                                -0.278424593191171, -0.309360659101302, -0.340296725011432, -0.371232790921562, 
                                -0.402168856831692, -0.433104922741822, -0.464040988651952, -0.494977054562083, 
                                -0.525913120472213, -0.556849186382343, -0.587785252292473, -0.587785252292473, 
                                -0.576871428830662, -0.565957605368851, -0.55504378190704, -0.544129958445228, 
                                -0.533216134983417, -0.522302311521606, -0.511388488059795, -0.500474664597984, 
                                -0.489560841136173, -0.478647017674362, -0.46773319421255, -0.456819370750739, 
                                -0.445905547288928, -0.434991723827117, -0.424077900365306, -0.413164076903495, 
                                -0.402250253441684, -0.391336429979873, -0.380422606518061, -0.380422606518061, 
                                -0.41045597019054, -0.440489333863019, -0.470522697535497, -0.500556061207976, 
                                -0.530589424880454, -0.560622788552933, -0.590656152225411, -0.62068951589789, 
                                -0.650722879570368, -0.680756243242847, -0.710789606915325, -0.740822970587804, 
                                -0.770856334260283, -0.800889697932761, -0.83092306160524, -0.860956425277718, 
                                -0.890989788950197, -0.921023152622675, -0.951056516295154, -0.951056516295154, 
                                -0.913375336538408, -0.875694156781663, -0.838012977024917, -0.800331797268172, 
                                -0.762650617511426, -0.724969437754681, -0.687288257997935, -0.64960707824119, 
                                -0.611925898484444, -0.574244718727699, -0.536563538970953, -0.498882359214208, 
                                -0.461201179457462, -0.423519999700717, -0.385838819943971, -0.348157640187226, 
                                -0.31047646043048, -0.272795280673735, -0.235114100916989, -0.235114100916989, 
                                -0.222739674552937, -0.210365248188885, -0.197990821824833, -0.185616395460781, 
                                -0.173241969096729, -0.160867542732677, -0.148493116368625, -0.136118690004573, 
                                -0.123744263640521, -0.111369837276469, -0.0989954109124166, 
                                -0.0866209845483645, -0.0742465581843124, -0.0618721318202604, 
                                -0.0494977054562083, -0.0371232790921562, -0.0247488527281041, 
                                -0.0123744263640521, 0), y = c(1, 0.964400357776315, 0.928800715552629, 
                                                               0.893201073328944, 0.857601431105259, 0.822001788881573, 0.786402146657888, 
                                                               0.750802504434203, 0.715202862210518, 0.679603219986832, 0.644003577763147, 
                                                               0.608403935539461, 0.572804293315776, 0.537204651092091, 0.501605008868406, 
                                                               0.46600536664472, 0.430405724421035, 0.39480608219735, 0.359206439973664, 
                                                               0.323606797749979, 0.323606797749979, 0.322838913361819, 0.32207102897366, 
                                                               0.3213031445855, 0.320535260197341, 0.319767375809181, 0.318999491421022, 
                                                               0.318231607032862, 0.317463722644703, 0.316695838256543, 0.315927953868383, 
                                                               0.315160069480224, 0.314392185092064, 0.313624300703905, 0.312856416315745, 
                                                               0.312088531927586, 0.311320647539426, 0.310552763151267, 0.309784878763107, 
                                                               0.309016994374947, 0.309016994374947, 0.286247321105215, 0.263477647835481, 
                                                               0.240707974565749, 0.217938301296016, 0.195168628026283, 0.17239895475655, 
                                                               0.149629281486817, 0.126859608217084, 0.104089934947351, 0.0813202616776177, 
                                                               0.0585505884078848, 0.0357809151381518, 0.0130112418684188, -0.0097584314013141, 
                                                               -0.0325281046710471, -0.0552977779407801, -0.078067451210513, 
                                                               -0.100837124480246, -0.123606797749979, -0.123606797749979, -0.159681018624977, 
                                                               -0.195755239499976, -0.231829460374974, -0.267903681249972, -0.303977902124971, 
                                                               -0.340052122999969, -0.376126343874967, -0.412200564749966, -0.448274785624964, 
                                                               -0.484349006499962, -0.520423227374961, -0.556497448249959, -0.592571669124957, 
                                                               -0.628645889999956, -0.664720110874954, -0.700794331749952, -0.736868552624951, 
                                                               -0.772942773499949, -0.809016994374947, -0.809016994374947, -0.787489784144687, 
                                                               -0.765962573914427, -0.744435363684166, -0.722908153453906, -0.701380943223645, 
                                                               -0.679853732993385, -0.658326522763125, -0.636799312532864, -0.615272102302604, 
                                                               -0.593744892072343, -0.572217681842083, -0.550690471611823, -0.529163261381562, 
                                                               -0.507636051151302, -0.486108840921042, -0.464581630690781, -0.443054420460521, 
                                                               -0.42152721023026, -0.4, -0.4, -0.42152721023026, -0.443054420460521, 
                                                               -0.464581630690781, -0.486108840921042, -0.507636051151302, -0.529163261381562, 
                                                               -0.550690471611823, -0.572217681842083, -0.593744892072344, -0.615272102302604, 
                                                               -0.636799312532864, -0.658326522763125, -0.679853732993385, -0.701380943223646, 
                                                               -0.722908153453906, -0.744435363684166, -0.765962573914427, -0.787489784144687, 
                                                               -0.809016994374948, -0.809016994374948, -0.772942773499949, -0.736868552624951, 
                                                               -0.700794331749953, -0.664720110874954, -0.628645889999956, -0.592571669124958, 
                                                               -0.556497448249959, -0.520423227374961, -0.484349006499962, -0.448274785624964, 
                                                               -0.412200564749966, -0.376126343874967, -0.340052122999969, -0.303977902124971, 
                                                               -0.267903681249972, -0.231829460374974, -0.195755239499976, -0.159681018624977, 
                                                               -0.123606797749979, -0.123606797749979, -0.100837124480246, -0.0780674512105131, 
                                                               -0.0552977779407802, -0.0325281046710472, -0.00975843140131423, 
                                                               0.0130112418684187, 0.0357809151381517, 0.0585505884078846, 0.0813202616776176, 
                                                               0.104089934947351, 0.126859608217084, 0.149629281486816, 0.172398954756549, 
                                                               0.195168628026282, 0.217938301296015, 0.240707974565748, 0.263477647835481, 
                                                               0.286247321105214, 0.309016994374947, 0.309016994374947, 0.309784878763107, 
                                                               0.310552763151266, 0.311320647539426, 0.312088531927586, 0.312856416315745, 
                                                               0.313624300703905, 0.314392185092064, 0.315160069480224, 0.315927953868383, 
                                                               0.316695838256543, 0.317463722644702, 0.318231607032862, 0.318999491421022, 
                                                               0.319767375809181, 0.320535260197341, 0.3213031445855, 0.32207102897366, 
                                                               0.322838913361819, 0.323606797749979, 0.323606797749979, 0.359206439973664, 
                                                               0.39480608219735, 0.430405724421035, 0.46600536664472, 0.501605008868406, 
                                                               0.537204651092091, 0.572804293315776, 0.608403935539461, 0.644003577763147, 
                                                               0.679603219986832, 0.715202862210517, 0.750802504434203, 0.786402146657888, 
                                                               0.822001788881573, 0.857601431105259, 0.893201073328944, 0.928800715552629, 
                                                               0.964400357776315, 1)), .Names = c("x", "y"))

CROWNPOLY <- structure(list(x = c(0, 0.0526315789473684, 0.105263157894737, 
                                  0.157894736842105, 0.210526315789474, 0.263157894736842, 0.315789473684211, 
                                  0.368421052631579, 0.421052631578947, 0.473684210526316, 0.526315789473684, 
                                  0.578947368421053, 0.631578947368421, 0.684210526315789, 0.736842105263158, 
                                  0.789473684210526, 0.842105263157895, 0.894736842105263, 0.947368421052632, 
                                  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
                                  1, 0.973684210526316, 0.947368421052632, 0.921052631578947, 0.894736842105263, 
                                  0.868421052631579, 0.842105263157895, 0.815789473684211, 0.789473684210526, 
                                  0.763157894736842, 0.736842105263158, 0.710526315789474, 0.684210526315789, 
                                  0.657894736842105, 0.631578947368421, 0.605263157894737, 0.578947368421053, 
                                  0.552631578947368, 0.526315789473684, 0.5, 0.5, 0.473684210526316, 
                                  0.447368421052632, 0.421052631578947, 0.394736842105263, 0.368421052631579, 
                                  0.342105263157895, 0.315789473684211, 0.289473684210526, 0.263157894736842, 
                                  0.236842105263158, 0.210526315789474, 0.184210526315789, 0.157894736842105, 
                                  0.131578947368421, 0.105263157894737, 0.0789473684210527, 0.0526315789473685, 
                                  0.0263157894736842, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                                  0, 0, 0, 0, 0, 0, 0, 0, -0.0263157894736842, -0.0526315789473684, 
                                  -0.0789473684210526, -0.105263157894737, -0.131578947368421, 
                                  -0.157894736842105, -0.184210526315789, -0.210526315789474, -0.236842105263158, 
                                  -0.263157894736842, -0.289473684210526, -0.315789473684211, -0.342105263157895, 
                                  -0.368421052631579, -0.394736842105263, -0.421052631578947, -0.447368421052632, 
                                  -0.473684210526316, -0.5, -0.5, -0.526315789473684, -0.552631578947368, 
                                  -0.578947368421053, -0.605263157894737, -0.631578947368421, -0.657894736842105, 
                                  -0.684210526315789, -0.710526315789474, -0.736842105263158, -0.763157894736842, 
                                  -0.789473684210526, -0.815789473684211, -0.842105263157895, -0.868421052631579, 
                                  -0.894736842105263, -0.921052631578947, -0.947368421052632, -0.973684210526316, 
                                  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
                                  -1, -1, -1, -1, -1, -1, -0.947368421052632, -0.894736842105263, 
                                  -0.842105263157895, -0.789473684210526, -0.736842105263158, -0.684210526315789, 
                                  -0.631578947368421, -0.578947368421053, -0.526315789473684, -0.473684210526316, 
                                  -0.421052631578947, -0.368421052631579, -0.315789473684211, -0.263157894736842, 
                                  -0.210526315789474, -0.157894736842105, -0.105263157894737, -0.0526315789473685, 
                                  0), y = c(-0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 
                                            -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 
                                            -0.5, -0.447368421052632, -0.394736842105263, -0.342105263157895, 
                                            -0.289473684210526, -0.236842105263158, -0.184210526315789, -0.131578947368421, 
                                            -0.0789473684210527, -0.0263157894736842, 0.0263157894736842, 
                                            0.0789473684210527, 0.131578947368421, 0.184210526315789, 0.236842105263158, 
                                            0.289473684210526, 0.342105263157895, 0.394736842105263, 0.447368421052632, 
                                            0.5, 0.5, 0.473684210526316, 0.447368421052632, 0.421052631578947, 
                                            0.394736842105263, 0.368421052631579, 0.342105263157895, 0.315789473684211, 
                                            0.289473684210526, 0.263157894736842, 0.236842105263158, 0.210526315789474, 
                                            0.184210526315789, 0.157894736842105, 0.131578947368421, 0.105263157894737, 
                                            0.0789473684210527, 0.0526315789473685, 0.0263157894736842, 0, 
                                            0, 0.0263157894736842, 0.0526315789473684, 0.0789473684210526, 
                                            0.105263157894737, 0.131578947368421, 0.157894736842105, 0.184210526315789, 
                                            0.210526315789474, 0.236842105263158, 0.263157894736842, 0.289473684210526, 
                                            0.315789473684211, 0.342105263157895, 0.368421052631579, 0.394736842105263, 
                                            0.421052631578947, 0.447368421052632, 0.473684210526316, 0.5, 
                                            0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 
                                            0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.473684210526316, 0.447368421052632, 
                                            0.421052631578947, 0.394736842105263, 0.368421052631579, 0.342105263157895, 
                                            0.315789473684211, 0.289473684210526, 0.263157894736842, 0.236842105263158, 
                                            0.210526315789474, 0.184210526315789, 0.157894736842105, 0.131578947368421, 
                                            0.105263157894737, 0.0789473684210527, 0.0526315789473685, 0.0263157894736842, 
                                            0, 0, 0.0263157894736842, 0.0526315789473684, 0.0789473684210526, 
                                            0.105263157894737, 0.131578947368421, 0.157894736842105, 0.184210526315789, 
                                            0.210526315789474, 0.236842105263158, 0.263157894736842, 0.289473684210526, 
                                            0.315789473684211, 0.342105263157895, 0.368421052631579, 0.394736842105263, 
                                            0.421052631578947, 0.447368421052632, 0.473684210526316, 0.5, 
                                            0.5, 0.447368421052632, 0.394736842105263, 0.342105263157895, 
                                            0.289473684210526, 0.236842105263158, 0.184210526315789, 0.131578947368421, 
                                            0.0789473684210527, 0.0263157894736842, -0.0263157894736842, 
                                            -0.0789473684210527, -0.131578947368421, -0.184210526315789, 
                                            -0.236842105263158, -0.289473684210526, -0.342105263157895, -0.394736842105263, 
                                            -0.447368421052632, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 
                                            -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 
                                            -0.5, -0.5, -0.5)), .Names = c("x", "y"), row.names = c(NA, -180L
                                            ), class = "data.frame")

getArgs <- function(args)
{
  if (length(args)>0)
  {
    isqgraph <- sapply(args,function(x)"qgraph"%in%class(x))
    argLists <- c(lapply(args[isqgraph],'[[','Arguments'),lapply(args[isqgraph],'[','layout'))
    args <- args[!isqgraph]
    newArgs <- lapply(argLists,getArgs)
    for (l in newArgs) args <- c(args,l[!names(l)%in%names(args)])
  }
  return(args)
}

# Create qgraph model:

qgraph <- function( input, ... )
{
  
  ### EMPTY QGRAPH OBJECT ####
  qgraphObject <- list(
    Edgelist = list(),
    Arguments = list(),
    plotOptions = list(),
    graphAttributes = list(
      Nodes = list(),
      Edges = list(),
      Graph = list()
    ),
    layout = matrix(),
    layout.orig = matrix()
  )
  
  class(qgraphObject) <- "qgraph"
  
  
  ### Extract nested arguments ###
  # if ("qgraph"%in%class(input)) qgraphObject$Arguments <- list(...,input) else qgraphObject$Arguments <- list(...)
  qgraphObject$Arguments <- list(...,input=input) 
  
  
  
  if(!is.null(qgraphObject$Arguments$adj))
  {
    stop("'adj' argument is no longer supported. Please use 'input'")
  }
  
  # Import qgraphObject$Arguments:
  if (length(qgraphObject$Arguments) > 0) qgraphObject$Arguments <- getArgs(qgraphObject$Arguments)
  
  # Import default arguments:
  def <-  getOption("qgraph")
  if (!is.null(def$qgraph)) class(def$qgraph) <- "qgraph"
  if (any(sapply(def,function(x)!is.null(x))))
  {
    qgraphObject$Arguments <- getArgs(c(qgraphObject$Arguments,def))
  }
  
  ### Check arguments list:
  allArgs <- c("input", "layout", "groups", "minimum", "maximum", "cut", "details", 
               "threshold", "palette", "theme", "graph", "threshold", "sampleSize", 
               "tuning", "refit", "countDiagonal", "alpha", "bonf", "FDRcutoff", 
               "mar", "filetype", "filename", "width", "height", "normalize", "res",
               "DoNotPlot", "plot", "rescale", "standAlone", "color", "vsize", 
               "vsize2", "node.width", "node.height", "borders", "border.color", 
               "border.width", "shape", "polygonList", "vTrans", "subplots", 
               "subpars", "subplotbg", "images", "noPar", "pastel", "rainbowStart", 
               "usePCH", "node.resolution", "title", "preExpression", "postExpression", 
               "diag", "labels", "label.cex", "label.color", "label.prop", "label.norm", 
               "label.scale", "label.scale.equal", "label.font", "label.fill.vertical", 
               "label.fill.horizontal", "esize", "edge.width", "edge.color", 
               "posCol", "negCol", "unCol", "probCol", "negDashed", "probabilityEdges", 
               "colFactor", "trans", "fade", "loop", "lty", "edgeConnectPoints", 
               "curve", "curveAll", "curveDefault", "curveShape", "curveScale", 
               "curveScaleNodeCorrection", "curvePivot", "curvePivotShape", 
               "parallelEdge", "parallelAngle", "parallelAngleDefault", "edge.labels", 
               "edge.label.cex", "edge.label.bg", "edge.label.position", "edge.label.font", "edge.label.color",
               "repulsion", "layout.par", "layout.control", "aspect", "rotation", 
               "legend", "legend.cex", "legend.mode", "GLratio", "layoutScale", 
               "layoutOffset", "nodeNames", "bg", "bgcontrol", "bgres", "pty", 
               "gray",  "font", "directed", 
               "arrows", "arrowAngle", "asize", "open", "bidirectional", "mode", 
               "alpha", "sigScale", "bonf", "scores", "scores.range", "mode", 
               "edge.color", "knots", "knot.size", "knot.color", "knot.borders", 
               "knot.border.color", "knot.border.width", "means", "SDs", "meanRange", 
               "bars", "barSide", "barColor", "barLength", "barsAtSide", "pie", 
               "pieBorder", "pieColor", "pieColor2", "pieStart", "pieDarken", 
               "piePastel", "BDgraph", "BDtitles", "edgelist", "weighted", "nNodes", 
               "XKCD", "Edgelist", "Arguments", "plotOptions", "graphAttributes", 
               "layout", "layout.orig","resid","factorCors","residSize","filetype","model",
               "crossloadings","gamma","lambda.min.ratio","loopRotation","edgeConnectPoints","residuals","residScale","residEdge","CircleEdgeEnd","title.cex",  
               "node.label.offset", "node.label.position", "pieCImid", "pieCIlower", "pieCIupper", "pieCIpointcex", "pieCIpointcol",
               "edge.label.margin")
  
  if (any(!names(qgraphObject$Arguments) %in% allArgs)){
    wrongArgs <- names(qgraphObject$Arguments)[!names(qgraphObject$Arguments) %in% allArgs]
    warning(paste0("The following arguments are not documented and likely not arguments of qgraph and thus ignored: ",paste(wrongArgs,collapse = "; ")))
  }
  
  ## Extract arguments
  if(is.null(qgraphObject$Arguments[['verbose']]))
  {
    verbose <- FALSE
  } else verbose <- qgraphObject$Arguments[['verbose']] 
  
  if(is.null(qgraphObject$Arguments[['tuning']]))
  {
    tuning <- 0.5
  } else tuning <- qgraphObject$Arguments[['tuning']]  
  
  if(!is.null(qgraphObject$Arguments[['gamma']]))
  {
    tuning <- qgraphObject$Arguments[['gamma']]
  }
  
  if(is.null(qgraphObject$Arguments[['lambda.min.ratio']]))
  {
    lambda.min.ratio <- 0.01
  } else lambda.min.ratio <- qgraphObject$Arguments[['lambda.min.ratio']]  
  
  
  # Refit:
  if(is.null(qgraphObject$Arguments[['refit']]))
  {
    refit <- FALSE
  } else refit <- qgraphObject$Arguments[['refit']]  
  
  
  
  if(is.null(qgraphObject$Arguments[['FDRcutoff']]))
  {
    FDRcutoff <- 0.9
  } else FDRcutoff <- qgraphObject$Arguments[['FDRcutoff']]  
  
  
  
  
  # Coerce input to matrix:
  input <- as.matrix(input)
  
  # Set mode:
  sigSign <- FALSE
  if(is.null(qgraphObject$Arguments[['graph']])) graph <- "default" else graph=qgraphObject$Arguments[['graph']]
  
  if (!graph %in% c("default","cor","pcor","glasso","ggmModSelect","factorial")){
    stop("'graph' argument must be one of 'default', 'cor', 'pcor', 'glasso', 'ggmModSelect', or 'factorial'")
  }
  
  # Reset graph for replotting:
  qgraphObject$Arguments[['graph']] <- NULL
  
  
  
  
  ### SIGNIFICANCE GRAPH ARGUMENTS ###
  if(is.null(qgraphObject$Arguments[['mode']])) mode <- "strength" else mode <- qgraphObject$Arguments[['mode']]
  if(is.null(qgraphObject$Arguments$sigScale)) sigScale <- function(x)0.7*(1-x)^(log(0.4/0.7,1-0.05)) else sigScale <- qgraphObject$Arguments$sigScale
  if (!mode%in%c("strength","sig","direct")) stop("Mode must be 'direct', 'sig' or 'strength'")	
  if(is.null(qgraphObject$Arguments$bonf)) bonf=FALSE else bonf=qgraphObject$Arguments$bonf
  if(is.null(qgraphObject$Arguments$OmitInsig)) OmitInsig=FALSE else OmitInsig <- qgraphObject$Arguments$OmitInsig
  if(is.null(qgraphObject$Arguments[['alpha']]))
  {
    if (mode != "sig")
    {
      alpha <- 0.05
    } else alpha <- c(0.0001,0.001,0.01,0.05) 
  } else alpha <- qgraphObject$Arguments[['alpha']]
  if (length(alpha) > 4) stop("`alpha' can not have length > 4")
  
  
  #####
  # Settings for the edgelist
  if(is.null(qgraphObject$Arguments$edgelist)) 
  {
    if (nrow(input)!=ncol(input)) {
      # Check if it is an edgelist or break:
      if (ncol(input) %in% c(2,3) && ((is.character(input[,1]) || is.factor(input[,1])) || all(input[,1] %% 1 == 0)) &&
          ((is.character(input[,2]) || is.factor(input[,2])) || all(input[,2] %% 1 == 0))){
        edgelist <- TRUE
      } else {
        stop("Input is not a weights matrix or an edgelist.")
      }
    } else edgelist <- FALSE
  } else edgelist=qgraphObject$Arguments$edgelist
  
  if(is.null(qgraphObject$Arguments[['edgeConnectPoints']])) edgeConnectPoints <- NULL else edgeConnectPoints <- qgraphObject$Arguments[['edgeConnectPoints']]
  
  
  if(is.null(qgraphObject$Arguments[['label.color.split']])) label.color.split <- 0.25 else label.color.split <- qgraphObject$Arguments[['label.color.split']]
  labels <- qgraphObject$Arguments$labels
  
  if (edgelist)
  {
    if (is.character(input))
    {
      if(!is.logical(labels)) allNodes <- labels else allNodes <- unique(c(input[,1:2]))
      input[,1:2] <- match(input[,1:2],allNodes)
      input <- as.matrix(input)
      mode(input) <- "numeric"
      if (is.logical(labels) && labels) labels <- allNodes
    }
  }
  
  if(is.null(qgraphObject$Arguments$nNodes)) 
  {
    if (edgelist)
    {
      if (!is.logical(labels)) nNodes <- length(labels) else nNodes <- max(c(input[,1:2])) 
    } else nNodes=nrow(input)
  } else nNodes=qgraphObject$Arguments$nNodes
  
  
  #####
  
  
  #### Arguments for pies with Jonas
  # Arguments for pies:
  if(is.null(qgraphObject$Arguments[['pieRadius']])){
    pieRadius <- 1
  } else {
    pieRadius <- qgraphObject$Arguments[['pieRadius']]
  }
  
  if(is.null(qgraphObject$Arguments[['pieBorder']])){
    pieBorder <- .15
  }
  
  if(is.null(qgraphObject$Arguments[['pieStart']])){
    pieStart <- 0
  } else {
    pieStart <- qgraphObject$Arguments[['pieStart']]
    if (any(pieStart < 0 | pieStart > 1)){
      stop("Values in the 'pieStart' argument must be within [0,1]")
    }
  }
  
  if(is.null(qgraphObject$Arguments[['pieDarken']])){
    pieDarken <- 0.25
    if (any(pieDarken < 0 | pieDarken > 1)){
      stop("Values in the 'pieDarken' argument must be within [0,1]")
    }
  } else {
    pieDarken <- qgraphObject$Arguments[['pieDarken']]
  }
  
  if(is.null(qgraphObject$Arguments[['pieColor']])){
    # pieColor <- 'grey'
    pieColor <- NA
  } else {
    pieColor <- qgraphObject$Arguments[['pieColor']]
  }
  
  
  if(is.null(qgraphObject$Arguments[['pieColor2']])){
    pieColor2 <- 'white'
  } else {
    pieColor2 <- qgraphObject$Arguments[['pieColor2']]
  }
  
  # Make arguments vectorized:
  if (length(pieColor) == 1){
    pieColor <- rep(pieColor,length=nNodes)
  }
  if (length(pieColor) != nNodes){
    stop("Length of 'pieColor' argument must be 1 or number of nodes")
  }
  
  if (length(pieColor2) == 1){
    pieColor2 <- rep(pieColor2,length=nNodes)
  }
  if (length(pieColor2) != nNodes){
    stop("Length of 'pieColor2' argument must be 1 or number of nodes")
  }
  
  if (length(pieBorder) == 1){
    pieBorder <- rep(pieBorder,length=nNodes)
  }
  if (length(pieBorder) != nNodes){
    stop("Length of 'pieBorder' argument must be 1 or number of nodes")
  }
  
  if (length(pieStart) == 1){
    pieStart <- rep(pieStart,length=nNodes)
  }
  if (length(pieStart) != nNodes){
    stop("Length of 'pieStart' argument must be 1 or number of nodes")
  }
  
  if (length(pieDarken) == 1){
    pieDarken <- rep(pieDarken,length=nNodes)
  }
  if (length(pieDarken) != nNodes){
    stop("Length of 'pieDarken' argument must be 1 or number of nodes")
  }
  
  
  
  
  
  if(is.null(qgraphObject$Arguments[['pie']])){
    drawPies <- FALSE
    pie <- NULL
  }
  
  pieCIs <- FALSE

  
  
  if (is.expression(labels)) labels <- as.list(labels)
  
  if(is.null(qgraphObject$Arguments[['background']])) background <- NULL else background <- qgraphObject$Arguments[['background']]
  if(is.null(qgraphObject$Arguments[['label.prop']])){
    label.prop <- 0.9*(1-ifelse(pieBorder < 0.5,pieBorder,0))
  } else {
    label.prop <- qgraphObject$Arguments[['label.prop']]
  }
  
  if(is.null(qgraphObject$Arguments[['label.norm']])) label.norm <- "OOO" else label.norm <- qgraphObject$Arguments[['label.norm']]
  
  if(is.null(qgraphObject$Arguments[['nodeNames']])) nodeNames <- NULL else nodeNames <- qgraphObject$Arguments[['nodeNames']]
  
  if(is.null(qgraphObject$Arguments[['subplots']])) {
    subplots <- NULL       
  } else {
    subplots <- qgraphObject$Arguments[['subplots']]        
  }
  if(is.null(qgraphObject$Arguments[['subpars']])) subpars <- list(mar=c(0,0,0,0)) else subpars <- qgraphObject$Arguments[['subpars']]
  
  
  if(is.null(qgraphObject$Arguments[['subplotbg']])) {
    subplotbg <- NULL       

  } else {
    subplotbg <- qgraphObject$Arguments[['subplotbg']]        
  }
  
  if(is.null(qgraphObject$Arguments[['images']])) images <- NULL else images <- qgraphObject$Arguments[['images']]
  
  if(is.null(qgraphObject$Arguments[['noPar']])) noPar <- FALSE else noPar <- qgraphObject$Arguments[['noPar']]
  
  
  
  # Knots:
  if(is.null(qgraphObject$Arguments[['knots']])) knots <- list() else knots <- qgraphObject$Arguments[['knots']]
  if(is.null(qgraphObject$Arguments[['knot.size']])) knot.size <- 1 else knot.size <- qgraphObject$Arguments[['knot.size']]
  if(is.null(qgraphObject$Arguments[['knot.color']])) knot.color <- NA else knot.color <- qgraphObject$Arguments[['knot.color']]
  if(is.null(qgraphObject$Arguments[['knot.borders']])) knot.borders <- FALSE else knot.borders <- qgraphObject$Arguments[['knot.borders']]
  if(is.null(qgraphObject$Arguments[['knot.border.color']])) knot.border.color <- "black" else knot.border.color <- qgraphObject$Arguments[['knot.border.color']]
  if(is.null(qgraphObject$Arguments[['knot.border.width']])) knot.border.width <- 1 else knot.border.width <- qgraphObject$Arguments[['knot.border.width']]
  
  
  #####
  
  
  
  if(is.null(qgraphObject$Arguments$shape))  {
    shape <- rep("circle",nNodes) 
    if (!is.null(subplots))
    {
      whichsub <- which(sapply(subplots,function(x)is.expression(x)|is.function(x)))
      
      shape[whichsub][!shape[whichsub]%in%c("square","rectangle")] <- "square"
    }      
  } else {
    shape <- qgraphObject$Arguments[['shape']]        
  }
  
  
  if(is.null(qgraphObject$Arguments[['usePCH']])) 
  {
    if (nNodes > 50 && !drawPies) usePCH <- TRUE else usePCH <- NULL 
  } else usePCH <- qgraphObject$Arguments[['usePCH']]
  
  if(is.null(qgraphObject$Arguments[['node.resolution']])) node.resolution <- 100 else node.resolution <- qgraphObject$Arguments[['node.resolution']]
  
  
  # Default for fact cut and groups
  if (graph=="factorial") fact=TRUE else fact=FALSE
  if (fact & edgelist) stop('Factorial graph needs a correlation matrix')
  defineCut <- FALSE
  if(is.null(qgraphObject$Arguments[['cut']])) 
  {
    cut=0
    if (nNodes>=20 | fact) 
    {
      cut=0.3
      defineCut <- TRUE
    }
    if (mode=="sig") cut <- ifelse(length(alpha)>1,sigScale(alpha[length(alpha)-1]),sigScale(alpha[length(alpha)]))
  } else if (mode != "sig") cut <- ifelse(is.na(qgraphObject$Arguments[['cut']]),0,qgraphObject$Arguments[['cut']]) else cut <- ifelse(length(alpha)>1,sigScale(alpha[length(alpha)-1]),sigScale(alpha[length(alpha)]))
  
  if(is.null(qgraphObject$Arguments$groups)) groups=NULL else groups=qgraphObject$Arguments$groups
  
  if (is.factor(groups) | is.character(groups)) groups <- tapply(1:length(groups),groups,function(x)x)
  
  
  
  
  
  # Factorial graph:
  if(is.null(qgraphObject$Arguments$nfact))
  {
    nfact=NULL
  } else nfact=qgraphObject$Arguments$nfact
  

  
  # Glasso arguments:
  if(is.null(qgraphObject$Arguments[['sampleSize']]))
  {
    sampleSize <- NULL
  } else sampleSize <- qgraphObject$Arguments[['sampleSize']]
  
  if(is.null(qgraphObject$Arguments[['countDiagonal']]))
  {
    countDiagonal <- FALSE
  } else countDiagonal <- qgraphObject$Arguments[['countDiagonal']]
  
  
  
  # SET DEFAULT qgraphObject$Arguments:
  # General qgraphObject$Arguments:
  if(is.null(qgraphObject$Arguments$DoNotPlot)) DoNotPlot=FALSE else DoNotPlot=qgraphObject$Arguments$DoNotPlot
  if(is.null(qgraphObject$Arguments[['layout']])) layout=NULL else layout=qgraphObject$Arguments[['layout']]
  if(is.null(qgraphObject$Arguments$maximum)) maximum=0 else maximum=qgraphObject$Arguments$maximum
  if(is.null(qgraphObject$Arguments$minimum))
  {
    minimum <- 0
    if (mode=="sig") minimum <- ifelse(length(alpha)>1,sigScale(alpha[length(alpha)]),0)
  } 
  if (minimum < 0)
  {
    warning("'minimum' set to absolute value")
    minimum <- abs(minimum)
  }
  
  # Threshold argument removes edges from network:
  if(is.null(qgraphObject$Arguments[['threshold']]))
  {
    threshold <- 0
  } else {
    threshold <- qgraphObject$Arguments[['threshold']]
  }
  
  if(is.null(qgraphObject$Arguments$weighted)) weighted=NULL else weighted=qgraphObject$Arguments$weighted
  if(is.null(qgraphObject$Arguments$rescale)) rescale=TRUE else rescale=qgraphObject$Arguments$rescale
  if(is.null(qgraphObject$Arguments[['edge.labels']])) edge.labels=FALSE else edge.labels=qgraphObject$Arguments[['edge.labels']]
  if(is.null(qgraphObject$Arguments[['edge.label.bg']])) edge.label.bg=TRUE else edge.label.bg=qgraphObject$Arguments[['edge.label.bg']]
  
  if (identical(FALSE,edge.label.bg)) plotELBG <- FALSE else plotELBG <- TRUE
  
  if(is.null(qgraphObject$Arguments[['edge.label.margin']])) edge.label.margin=0 else edge.label.margin=qgraphObject$Arguments[['edge.label.margin']]
  
  
  
  ### Themes ###
  # Default theme:
  posCol <- c("#009900","darkgreen")
  negCol <- c("#BF0000","red")
  bcolor <- NULL
  bg <- FALSE
  negDashed <- FALSE
  parallelEdge <- FALSE
  fade <- NA 
  border.width <- 1 
  font <- 1 
  unCol <- "#808080" 
  palette <- "rainbow"


  
  # Overwrite:
  if(!is.null(qgraphObject$Arguments[['parallelEdge']]))  parallelEdge <- qgraphObject$Arguments[['parallelEdge']]
  
  if(!is.null(qgraphObject$Arguments[['fade']])) fade <- qgraphObject$Arguments[['fade']]
  
  if(!is.null(qgraphObject$Arguments[['negDashed']])) negDashed <- qgraphObject$Arguments[['negDashed']]
  if(!is.null(qgraphObject$Arguments[['posCol']])) posCol <- qgraphObject$Arguments[['posCol']]
  if(!is.null(qgraphObject$Arguments[['negCol']])) negCol <- qgraphObject$Arguments[['negCol']]
  if(!is.null(qgraphObject$Arguments[['border.width']])) border.width <- qgraphObject$Arguments[['border.width']]
  
  if(!is.null(qgraphObject$Arguments[['font']])) font <- qgraphObject$Arguments[['font']]
  if(is.null(qgraphObject$Arguments[['edge.label.font']])) edge.label.font=font else edge.label.font=qgraphObject$Arguments[['edge.label.font']]
  if(is.null(qgraphObject$Arguments[['label.font']])) label.font <- font else label.font <- qgraphObject$Arguments[['label.font']]
  if(!is.null(qgraphObject$Arguments[['unCol']])) unCol <- qgraphObject$Arguments[['unCol']] 
  
  
  if(is.null(qgraphObject$Arguments[['probCol']])) probCol <- "black" else probCol <- qgraphObject$Arguments[['probCol']]
  if(!is.null(qgraphObject$Arguments[['probabilityEdges']])) 
  {
    if (isTRUE(qgraphObject$Arguments[['probabilityEdges']]))
    {
      posCol <- probCol
    }
  }
  
  if (length(posCol)==1) posCol <- rep(posCol,2)
  if (length(posCol)!=2) stop("'posCol' must be of length 1 or 2.")
  if (length(negCol)==1) negCol <- rep(negCol,2)
  if (length(negCol)!=2) stop("'negCol' must be of length 1 or 2.")
  
  # border color:
  if(!is.null(qgraphObject$Arguments[['border.color']])) {
    bcolor <- qgraphObject$Arguments[['border.color']]
  }
  # Alias?
  if(!is.null(qgraphObject$Arguments[['border.colors']])) {
    bcolor <- qgraphObject$Arguments[['border.colors']]
  }
  
  # BG:
  if(!is.null(qgraphObject$Arguments$bg)) bg <- qgraphObject$Arguments$bg
  
  # Palette:
  
  # PALETTE either one of the defaults or a function
  if(!is.null(qgraphObject$Arguments[['palette']])){
    palette <- qgraphObject$Arguments[['palette']]
  }
  
  # Check palette:
  if (!is.function(palette)){
    if (length(palette) != 1 && !is.character(palette)){
      stop("'palette' must be a single string.")
    }
    if (!palette %in% c("rainbow","colorblind","R","ggplot2","gray","grey","pastel","neon","pride")){
      stop(paste0("Palette '",palette,"' is not supported."))
    }
  }
  
  
  ###
  
  
  if(is.null(qgraphObject$Arguments[['colFactor']])) colFactor <- 1 else colFactor <- qgraphObject$Arguments[['colFactor']]
  
  if(is.null(qgraphObject$Arguments[['edge.color']])) edge.color <- NULL else edge.color=qgraphObject$Arguments[['edge.color']]
  if(is.null(qgraphObject$Arguments[['edge.label.cex']])) edge.label.cex=1 else edge.label.cex=qgraphObject$Arguments[['edge.label.cex']]
  if(is.null(qgraphObject$Arguments[['edge.label.position']])) edge.label.position <- 0.5 else edge.label.position=qgraphObject$Arguments[['edge.label.position']]
  
  
  if(is.null(qgraphObject$Arguments$directed))
  {
    if (edgelist) directed=TRUE else directed=NULL 
  } else directed=qgraphObject$Arguments$directed
  if(is.null(qgraphObject$Arguments[['legend']]))
  {
    if ((!is.null(groups) & !is.null(names(groups))) | !is.null(nodeNames)) legend <- TRUE else legend <- FALSE
  } else legend <- qgraphObject$Arguments[['legend']]
  
  stopifnot(is.logical(legend))
  
  if(is.null(qgraphObject$Arguments$plot)) plot=TRUE else plot=qgraphObject$Arguments$plot
  if(is.null(qgraphObject$Arguments$rotation)) rotation=NULL else rotation=qgraphObject$Arguments$rotation
  if(is.null(qgraphObject$Arguments[['layout.control']])) layout.control=0.5 else layout.control=qgraphObject$Arguments[['layout.control']]
  
  # repulsion controls the repulse.rad argument
  if(is.null(qgraphObject$Arguments[['repulsion']])) repulsion=1 else repulsion=qgraphObject$Arguments[['repulsion']]
  if(is.null(qgraphObject$Arguments[['layout.par']])) {
    if (is.null(layout) || identical(layout,"spring")) layout.par <- list(repulse.rad = nNodes^(repulsion * 3))  else layout.par <- list()
  } else layout.par=qgraphObject$Arguments[['layout.par']]
  
  if(is.null(qgraphObject$Arguments[['layoutRound']])){
    layoutRound <- TRUE
  } else { 
    layoutRound <- qgraphObject$Arguments[['layoutRound']]
  }
  layout.par$round <- layoutRound
  
  if(is.null(qgraphObject$Arguments$details)) details=FALSE else details=qgraphObject$Arguments$details
  if(is.null(qgraphObject$Arguments$title)) title <- NULL else title <- qgraphObject$Arguments$title
  
  if(is.null(qgraphObject$Arguments[['title.cex']])) title.cex <- NULL else title.cex <- qgraphObject$Arguments[['title.cex']]
  
  if(is.null(qgraphObject$Arguments$preExpression)) preExpression <- NULL else preExpression <- qgraphObject$Arguments$preExpression
  if(is.null(qgraphObject$Arguments$postExpression)) postExpression <- NULL else postExpression <- qgraphObject$Arguments$postExpression
  
  
  # Output qgraphObject$Arguments:
  
  if(is.null(qgraphObject$Arguments[['edge.label.color']])) ELcolor <- NULL else ELcolor <- qgraphObject$Arguments[['edge.label.color']]
  

  
  PlotOpen <- !is.null(grDevices::dev.list()[grDevices::dev.cur()])
  
  if(is.null(qgraphObject$Arguments$filetype)) filetype="default" else filetype=qgraphObject$Arguments$filetype
  if(is.null(qgraphObject$Arguments$filename)) filename="qgraph" else filename=qgraphObject$Arguments$filename
  if(is.null(qgraphObject$Arguments$width)) width <- 7 else width <- qgraphObject$Arguments[['width']]
  if(is.null(qgraphObject$Arguments$height)) height <- 7 else height <- qgraphObject$Arguments[['height']]
  if(is.null(qgraphObject$Arguments$pty)) pty='m' else pty=qgraphObject$Arguments$pty
  if(is.null(qgraphObject$Arguments$res)) res=320 else res=qgraphObject$Arguments$res
  if(is.null(qgraphObject$Arguments[['normalize']])) normalize <- TRUE else normalize <- qgraphObject$Arguments[['normalize']]
  
  # Graphical qgraphObject$Arguments
  if(is.null(qgraphObject$Arguments[['mar']])) mar <- c(3,3,3,3)/10 else mar <- qgraphObject$Arguments[["mar"]]/10
  if(is.null(qgraphObject$Arguments[['vsize']])) 
  {
    vsize <- 8*exp(-nNodes/80)+1
    if(is.null(qgraphObject$Arguments[['vsize2']])) vsize2 <- vsize else vsize2 <- vsize * qgraphObject$Arguments[['vsize2']]
  } else {
    vsize <- qgraphObject$Arguments[['vsize']]
    if(is.null(qgraphObject$Arguments[['vsize2']])) vsize2 <- vsize else vsize2 <- qgraphObject$Arguments[['vsize2']]
  }
  
  if(!is.null(qgraphObject$Arguments[['node.width']])) 
  {
    vsize <- vsize * qgraphObject$Arguments[['node.width']]
  }
  
  if(!is.null(qgraphObject$Arguments[['node.height']])) 
  {
    vsize2 <- vsize2 * qgraphObject$Arguments[['node.height']]
  }
  
  if(is.null(qgraphObject$Arguments$color)) color=NULL else color=qgraphObject$Arguments$color
  
  if(is.null(qgraphObject$Arguments[['gray']])) gray <- FALSE else gray <- qgraphObject$Arguments[['gray']]
  
  if (gray) {
    posCol <- negCol <- c("gray10","black")
    warning("The 'gray' argument is deprecated, please use theme = 'gray' instead.")
  }
  
  if(is.null(qgraphObject$Arguments[['pastel']])){
    pastel <- FALSE 
  } else {
    warning("The 'pastel' argument is deprecated, please use palette = 'pastel' instead.")
    palette <- "pastel"
    pastel <- qgraphObject$Arguments[['pastel']]
  }
  
  
  
  if(is.null(qgraphObject$Arguments[['piePastel']])) piePastel <- FALSE else piePastel <- qgraphObject$Arguments[['piePastel']]
  if(is.null(qgraphObject$Arguments[['rainbowStart']])) rainbowStart <- 0 else rainbowStart <- qgraphObject$Arguments[['rainbowStart']]
  
  if(is.null(qgraphObject$Arguments$bgcontrol)) bgcontrol=6 else bgcontrol=qgraphObject$Arguments$bgcontrol
  if(is.null(qgraphObject$Arguments$bgres)) bgres=100 else bgres=qgraphObject$Arguments$bgres
  if(is.null(qgraphObject$Arguments[['trans',exact=FALSE]])) transparency <- NULL else transparency <- qgraphObject$Arguments[['trans',exact=FALSE]]
  if (is.null(transparency))
  {
    if (isTRUE(bg)) transparency <- TRUE else transparency <- FALSE
  }
  
  

  if (is.logical(fade)){
    fade <- ifelse(fade,NA,1)
  }
  
  if (identical(fade,FALSE)){
    fade <- 1
  }
  
  if(is.null(qgraphObject$Arguments[['loop']])) loop=1 else loop=qgraphObject$Arguments[['loop']]
  if(is.null(qgraphObject$Arguments[['loopRotation']]))
  {
    loopRotation <- NA
  } else {
    loopRotation=qgraphObject$Arguments[['loopRotation']]
  }
  
  if(is.null(qgraphObject$Arguments[['residuals']])) residuals=FALSE else residuals=qgraphObject$Arguments[['residuals']]
  if(is.null(qgraphObject$Arguments[['residScale']])) residScale=1 else residScale=qgraphObject$Arguments[['residScale']]
  if(is.null(qgraphObject$Arguments[['residEdge']])) residEdge=FALSE else residEdge=qgraphObject$Arguments[['residEdge']]
  
  if(is.null(qgraphObject$Arguments[['bars']])) bars <- list() else bars <- qgraphObject$Arguments[['bars']]
  if(is.null(qgraphObject$Arguments[['barSide']])) barSide <- 1 else barSide <- qgraphObject$Arguments[['barSide']]
  if(is.null(qgraphObject$Arguments[['barLength']])) barLength <- 0.5 else barLength <- qgraphObject$Arguments[['barLength']]
  if(is.null(qgraphObject$Arguments[['barColor']])) barColor <- 'border' else barColor <- qgraphObject$Arguments[['barColor']]
  if(is.null(qgraphObject$Arguments[['barsAtSide']])) barsAtSide <- FALSE else barsAtSide <- qgraphObject$Arguments[['barsAtSide']]
  
  # Means and SDs:
  if(is.null(qgraphObject$Arguments[['means']])) means <- NA else means <- qgraphObject$Arguments[['means']]
  if(is.null(qgraphObject$Arguments[['SDs']])) SDs <- NA else SDs <- qgraphObject$Arguments[['SDs']]
  if(is.null(qgraphObject$Arguments[['meanRange']])) {
    if (all(is.na(means))) meanRange <- c(NA,NA) else meanRange <- range(means,na.rm=TRUE) 
  }else meanRange <- qgraphObject$Arguments[['meanRange']]
  
  
  if (!is.list(bars)) bars <- as.list(bars)
  
  if(is.null(qgraphObject$Arguments[['CircleEdgeEnd']])) CircleEdgeEnd=FALSE else CircleEdgeEnd=qgraphObject$Arguments[['CircleEdgeEnd']]
  if(is.null(qgraphObject$Arguments[['loopAngle']])) loopangle=pi/2 else loopAngle=qgraphObject$Arguments[['loopAngle']]
  if(is.null(qgraphObject$Arguments[['legend.cex']])) legend.cex=0.6 else legend.cex=qgraphObject$Arguments[['legend.cex']]
  if(is.null(qgraphObject$Arguments[['legend.mode']]))
  {
    if (!is.null(nodeNames) && !is.null(groups)){
      legend.mode <- "style1" # or style2
    } else if (!is.null(nodeNames)) legend.mode <- "names" else legend.mode <- "groups"
  }  else legend.mode=qgraphObject$Arguments[['legend.mode']]
  
  if(is.null(qgraphObject$Arguments$borders)){
    borders <- TRUE       
  } else {
    borders <- qgraphObject$Arguments[['borders']]        
  }
  
  
  ### Polygon lookup list:
  polygonList = list(
    ellipse = ELLIPSEPOLY,
    heart  = HEARTPOLY,
    star = STARPOLY,
    crown = CROWNPOLY
  )
  
  if(!is.null(qgraphObject$Arguments[['polygonList']])) polygonList  <- c( polygonList, qgraphObject$Arguments[['polygonList']])
  
  # Rescale to -1 - 1 and compute radians per point:
  for (i in seq_along(polygonList))
  {
    polygonList[[i]]$x <- (polygonList[[i]]$x - min(polygonList[[i]]$x)) / (max(polygonList[[i]]$x) - min(polygonList[[i]]$x)) * 2 - 1
    polygonList[[i]]$y <- (polygonList[[i]]$y - min(polygonList[[i]]$y)) / (max(polygonList[[i]]$y) - min(polygonList[[i]]$y)) * 2 - 1
  }
  
  if(is.null(qgraphObject$Arguments[['label.scale']])) label.scale=TRUE else label.scale=qgraphObject$Arguments[['label.scale']]
  
  if(is.null(qgraphObject$Arguments[['label.cex']])){ 
    if (label.scale){
      label.cex <- 1  
    } else {
      label.cex <- 1
    }
  } else label.cex <- qgraphObject$Arguments[['label.cex']]
  
  if(is.null(qgraphObject$Arguments$label.scale.equal)) label.scale.equal=FALSE else label.scale.equal=qgraphObject$Arguments$label.scale.equal
  
  if(is.null(qgraphObject$Arguments$label.fill.horizontal)) label.fill.horizontal<-1 else label.fill.horizontal <- qgraphObject$Arguments$label.fill.horizontal
  if(is.null(qgraphObject$Arguments$label.fill.vertical)) label.fill.vertical<-1 else label.fill.vertical <- qgraphObject$Arguments$label.fill.vertical
  if(is.null(qgraphObject$Arguments$node.label.offset)) node.label.offset<-c(0.5, 0.5) else node.label.offset <- qgraphObject$Arguments$node.label.offset
  if(is.null(qgraphObject$Arguments$node.label.position)) node.label.position<-NULL else node.label.position <- qgraphObject$Arguments$node.label.position
  
  
  
  if(is.null(qgraphObject$Arguments$scores)) scores=NULL else scores=qgraphObject$Arguments$scores
  if(is.null(qgraphObject$Arguments$scores.range)) scores.range=NULL else scores.range=qgraphObject$Arguments$scores.range
  if(is.null(qgraphObject$Arguments$lty)) lty=1 else lty=qgraphObject$Arguments$lty
  if(is.null(qgraphObject$Arguments$vTrans)) vTrans=255 else vTrans=qgraphObject$Arguments$vTrans
  if(is.null(qgraphObject$Arguments[['GLratio']])) GLratio <- 2.5 else GLratio <- qgraphObject$Arguments[['GLratio']]
  if(is.null(qgraphObject$Arguments$layoutScale)) layoutScale <- 1 else layoutScale <- qgraphObject$Arguments$layoutScale
  if(is.null(qgraphObject$Arguments[['layoutOffset']])) layoutOffset <- 0 else layoutOffset <- qgraphObject$Arguments[['layoutOffset']]
  
  # Aspect ratio:
  if(is.null(qgraphObject$Arguments[['aspect']])) aspect=FALSE else aspect=qgraphObject$Arguments[['aspect']]
  
  # qgraphObject$Arguments for directed graphs:
  if(is.null(qgraphObject$Arguments[['curvePivot']])) curvePivot <- FALSE else curvePivot <- qgraphObject$Arguments[['curvePivot']]
  if (isTRUE(curvePivot)) curvePivot <- 0.1
  if(is.null(qgraphObject$Arguments[['curveShape']])) curveShape <- -1 else curveShape <- qgraphObject$Arguments[['curveShape']]
  if(is.null(qgraphObject$Arguments[['curvePivotShape']])) curvePivotShape <- 0.25 else curvePivotShape <- qgraphObject$Arguments[['curvePivotShape']]
  if(is.null(qgraphObject$Arguments[['curveScale']])) curveScale <- TRUE else curveScale <- qgraphObject$Arguments[['curveScale']]
  
  if(is.null(qgraphObject$Arguments[['curveScaleNodeCorrection']])) curveScaleNodeCorrection <- TRUE else curveScaleNodeCorrection <- qgraphObject$Arguments[['curveScaleNodeCorrection']]
  
  if(is.null(qgraphObject$Arguments[['parallelAngle']])) parallelAngle <- NA else parallelAngle <- qgraphObject$Arguments[['parallelAngle']]
  
  if(is.null(qgraphObject$Arguments[['parallelAngleDefault']])) parallelAngleDefault <- pi/6 else parallelAngleDefault <- qgraphObject$Arguments[['parallelAngleDefault']]
  
  if(is.null(qgraphObject$Arguments[['curveDefault']])) curveDefault <- 1 else curveDefault <- qgraphObject$Arguments[['curveDefault']]
  
  if(is.null(qgraphObject$Arguments[['curve']]))
  {
    if (any(parallelEdge))
    { 
      curve <- ifelse(parallelEdge,0,NA)
    } else curve <- NA 
  } else {      
    curve <- qgraphObject$Arguments[['curve']]
    if (length(curve)==1) 
    {
      curveDefault <- curve
      curve <- NA
    }
  }
  if(is.null(qgraphObject$Arguments[['curveAll']])) curveAll <- FALSE else curveAll <- qgraphObject$Arguments[['curveAll']]
  if (curveAll)
  {
    curve[is.na(curve)] <- curveDefault
  }
  if(is.null(qgraphObject$Arguments$arrows)) arrows=TRUE else arrows=qgraphObject$Arguments$arrows
  if(is.null(qgraphObject$Arguments$open)) open=FALSE else open=qgraphObject$Arguments$open
  if(is.null(qgraphObject$Arguments$bidirectional)) bidirectional=FALSE else bidirectional=qgraphObject$Arguments$bidirectional
  
  
  if(is.null(qgraphObject$Arguments$hyperlinks)) hyperlinks=NULL else hyperlinks=qgraphObject$Arguments$hyperlinks
  
  # qgraphObject$Arguments for TEX:
  if(is.null(qgraphObject$Arguments$standAlone)) standAlone=TRUE else standAlone=qgraphObject$Arguments$standAlone
  
  ### EASTER EGGS ###
  if(is.null(qgraphObject$Arguments[['XKCD']])) XKCD <- FALSE else XKCD <- TRUE
  
 
  if ((legend&is.null(scores))|(identical(filetype,"svg")))
  {
    width=width*(1+(1/GLratio))
  }
  
  # Specify background:
  background <- "white"
  
  if (isColor(bg)) background <- bg
  # Remove alpha:
  background <- grDevices::col2rgb(background, alpha = TRUE)
  background <- grDevices::rgb(background[1],background[2],background[3],background[4],maxColorValue=255)
  
  if (is.null(subplotbg)) subplotbg <- background
  
  if (isTRUE(edge.label.bg)) edge.label.bg <- background
  if(is.null(qgraphObject$Arguments[['label.color']])) {
    if(is.null(qgraphObject$Arguments$lcolor)) lcolor <- NA else lcolor <- qgraphObject$Arguments$lcolor
  } else lcolor <- qgraphObject$Arguments[['label.color']]
  
  # Legend setting 2
  if (legend & !is.null(scores))
  {
    layout(t(1:2),widths=c(GLratio,1))
  }
  
  # Weighted settings:
  if (is.null(weighted))
  {
    if (edgelist)
    {
      if (ncol(input)==2) weighted=FALSE else weighted=TRUE
    }
    if (!edgelist)
    {
      if (all(unique(c(input)) %in% c(0,1)) & !grepl("sig",mode)) weighted <- FALSE else weighted <- TRUE
    }
  }		
  if (!weighted) cut=0
  
  
  if (!edgelist)
  {
    if (!is.logical(directed)) if (is.null(directed))
    {
      if (!isSymmetric(unname(input))) directed=TRUE else directed=FALSE
    }
  }
  
  
  # Set default edge width:
  if(is.null(qgraphObject$Arguments[["esize"]])) 
  {
    if (weighted)
    {
      esize <- 15*exp(-nNodes/90)+1
    } else {
      esize <- 2
    }
    if (any(directed)) esize <- max(esize/2,1)
  } else esize <- qgraphObject$Arguments$esize
  
  # asize default:
  if(is.null(qgraphObject$Arguments[["asize"]]))
  {
    asize <- 2*exp(-nNodes/20)+2
  } else asize <- qgraphObject$Arguments[["asize"]]
  
  if(!is.null(qgraphObject$Arguments[["edge.width"]]))
  {
    esize <- esize * qgraphObject$Arguments[["edge.width"]]
    asize <- asize * sqrt(qgraphObject$Arguments[["edge.width"]])
  }
  
  ## arrowAngle default:
  if(is.null(qgraphObject$Arguments[["arrowAngle"]])) 
  {
    if (weighted) arrowAngle <- pi/6 else arrowAngle <- pi/8
  } else {
    arrowAngle <- qgraphObject$Arguments[["arrowAngle"]]
  }
  
  
  ########### GRAPHICAL MODEL SELECTION #######
  
  
  

  
 
  
  
  ## Thresholding ####
  # If threshold is TRUE and graph = "glasso" or "ggmModSelect", set to FALSE:
  if (isTRUE(threshold) && (graph == "glasso" || graph == "ggmModSelect")){
    threshold <- qgraphObject$Arguments[['threshold']] <- 0
  }
  
 
  
  
  #######################3
  
  ## diag default:
  if(is.null(qgraphObject$Arguments[['diag']])) 
  {
    if (edgelist) diag <- FALSE  else diag <- length(unique(diag(input))) > 1
  } else { 
    diag <- qgraphObject$Arguments$diag
  }
  
  # Diag:
  diagCols=FALSE
  diagWeights=0
  if (is.character(diag)) 
  {
    if (diag=="col" & !edgelist)
    {
      diagWeights=diag(input)
      diagCols=TRUE
      diag=FALSE
    }
  }
  if (is.numeric(diag))
  {
    if (length(diag)==1) diag=rep(diag,nNodes)
    if (length(diag)!=nNodes) stop("Numerical assignment of the 'diag' argument must be if length equal to the number of nodes")
    diagWeights=diag
    diagCols=TRUE
    diag=FALSE
  }
  if (is.logical(diag)) if (!diag & !edgelist) diag(input)=0
  
  # CREATE EDGELIST:
  
  E <- list()
  
  # Remove nonfinite weights:
  if (any(!is.finite(input)))
  {
    input[!is.finite(input)] <- 0
    warning("Non-finite weights are omitted")
  }
  if (edgelist)
  {
    E$from=input[,1]
    E$to=input[,2]
    if (ncol(input)>2) E$weight=input[,3] else E$weight=rep(1,length(E$from))
    if (length(directed)==1) directed=rep(directed,length(E$from))
  }
  
  keep <- abs(E$weight)>threshold
  
  ######
  if (length(loopRotation)==1) loopRotation <- rep(loopRotation,nNodes)
  
  if (length(directed)==1) 
  {
    directed <- rep(directed,length(E$from))
  }
  directed <- directed[keep]
  
  if (!is.null(edge.color) && length(edge.color) != sum(keep)) 
  {
    edge.color <- rep(edge.color,length=length(E$from))
    if (length(edge.color) != length(keep)) stop("'edge.color' is wrong length")
    edge.color <- edge.color[keep]
  }
  
  if (!is.logical(edge.labels))
  {
    if (length(edge.labels) == 1) edge.labels <- rep(edge.labels,length(E$from))
    if (length(edge.labels) != length(keep) & length(edge.labels) != sum(keep)) stop("'edge.label.bg' is wrong length")
    if (length(edge.labels)==length(keep)) edge.labels <- edge.labels[keep]
    
  }
  
 
  if (length(edge.label.bg) == 1) edge.label.bg <- rep(edge.label.bg,length(E$from))
  if (length(edge.label.bg) != length(keep) & length(edge.label.bg) != sum(keep)) stop("'edge.label.bg' is wrong length")
  if (length(edge.label.bg)==length(keep)) edge.label.bg <- edge.label.bg[keep]
  
  if (length(edge.label.margin) == 1) edge.label.margin <- rep(edge.label.margin,length(E$from))
  if (length(edge.label.margin) != length(keep) & length(edge.label.margin) != sum(keep)) stop("'edge.label.margin' is wrong length")
  if (length(edge.label.margin)==length(keep)) edge.label.margin <- edge.label.margin[keep]
  
  
  
  if (length(edge.label.font) == 1) edge.label.font <- rep(edge.label.font,length(E$from))
  if (length(edge.label.font) != length(keep) & length(edge.label.font) != sum(keep)) stop("'edge.label.font' is wrong length")
  if (length(edge.label.font)==length(keep)) edge.label.font <- edge.label.font[keep]
  
  
  if (length(lty) == 1) lty <- rep(lty,length(E$from))
  if (length(lty) != length(keep) & length(lty) != sum(keep)) stop("'lty' is wrong length")
  if (length(lty)==length(keep)) lty <- lty[keep]
  
  if (length(fade) == 1) fade <- rep(fade,length(E$from))
  if (length(fade) != length(keep) & length(fade) != sum(keep)) stop("'fade' is wrong length")
  if (length(fade)==length(keep)) fade <- fade[keep]
  
  
  if (!is.null(edgeConnectPoints))
  {
    if (length(edgeConnectPoints) == 1) edgeConnectPoints <- matrix(rep(edgeConnectPoints,2*length(E$from)),,2)
    if (nrow(edgeConnectPoints) != length(keep) & nrow(edgeConnectPoints) != sum(keep)) stop("Number of rows in 'edgeConnectPoints' do not match number of edges")
    if (nrow(edgeConnectPoints)==length(keep)) edgeConnectPoints <- edgeConnectPoints[keep,,drop=FALSE]
  }
  
  if (length(edge.label.position) == 1) edge.label.position <- rep(edge.label.position,length(E$from))
  if (length(edge.label.position) != length(keep) & length(edge.label.position) != sum(keep)) stop("'edge.label.position' is wrong length")
  if (length(edge.label.position)==length(keep)) edge.label.position <- edge.label.position[keep]  
  
  
  if (!is.null(ELcolor))
  {
    ELcolor <- rep(ELcolor,length = length(E$from))
    ELcolor <- ELcolor[keep]    
  }
  
  
  if (is.list(knots))
  {
    knotList <- knots
    knots <- rep(0,length(E$from))
    for (k in seq_along(knotList))
    {
      knots[knotList[[k]]] <- k
    }
  }
  if (length(knots)==length(keep)) knots <- knots[keep]
  
  if (length(bidirectional)==1) 
  {
    bidirectional <- rep(bidirectional,length(E$from))
  }
  if (length(bidirectional)==length(keep)) bidirectional <- bidirectional[keep]
  if (length(residEdge)==1) 
  {
    residEdge <- rep(residEdge,length(E$from))
  }
  if (length(residEdge)==length(keep)) residEdge <- residEdge[keep]    
  
  if (length(CircleEdgeEnd)==1) 
  {
    CircleEdgeEnd <- rep(CircleEdgeEnd,length(E$from))
  }
  if (length(CircleEdgeEnd)==length(keep)) CircleEdgeEnd <- CircleEdgeEnd[keep]    
  
  if (!is.logical(edge.labels))
  {
    if (length(edge.labels)==length(keep))
    {
      edge.labels <- edge.labels[keep]
    }
  }
  
  if (length(curve)==1) 
  {
    curve <- rep(curve,length(E$from))
  }
  if (length(curve)==length(keep)) curve <- curve[keep]   
  
  
  if (length(parallelEdge)==1) 
  {
    parallelEdge <- rep(parallelEdge,length(E$from))
  }
  if (length(parallelEdge)==length(keep)) parallelEdge <- parallelEdge[keep]    
  
  
  if (length(parallelAngle)==1) 
  {
    parallelAngle <- rep(parallelAngle,length(E$from))
  }
  if (length(parallelAngle)==length(keep)) parallelAngle <- parallelAngle[keep]    
  
  E$from=E$from[keep]
  E$to=E$to[keep]
  if (mode=="sig") Pvals <- Pvals[keep]
  E$weight=E$weight[keep]
  
  
  
  
  if (length(E$from) > 0)
  {
    maximum=max(abs(c(maximum,max(abs(E$weight)),cut,abs(diagWeights))))
  } else maximum = 1
  if (cut==0)
  {
    avgW=(abs(E$weight)-minimum)/(maximum-minimum)
  } else if (maximum>cut) avgW=(abs(E$weight)-cut)/(maximum-cut) else avgW=rep(0,length(E$from))
  avgW[avgW<0]=0
  
  
  edgesort=sort(abs(E$weight),index.return=TRUE)$ix
  edge.width=rep(1,length(E$weight))
  
  
  # lty and curve settings:
  
  if (length(lty)==1) lty=rep(lty,length(E$from))
  
  if (length(edge.label.position)==1) edge.label.position=rep(edge.label.position,length(E$from))
  
  
  # Make bidirectional vector:
  if (length(bidirectional)==1) bidirectional=rep(bidirectional,length(E$from))
  if (length(bidirectional)!=length(E$from)) stop("Bidirectional vector must be of length 1 or equal to the number of edges")
  
  srt <- cbind(pmin(E$from,E$to), pmax(E$from,E$to) , knots, abs(E$weight) > minimum)
  
  if (!curveAll | any(parallelEdge))
  {
    dub <- duplicated(srt)|duplicated(srt,fromLast=TRUE)
    
    if (!curveAll)
    {
      if (length(curve)==1) curve <- rep(curve,length(E$from))
      curve <- ifelse(is.na(curve),ifelse(knots==0&dub&!bidirectional&is.na(curve),ifelse(E$from==srt[,1],1,-1) * stats::ave(1:nrow(srt),srt[,1],srt[,2],bidirectional,FUN=function(x)seq(curveDefault,-curveDefault,length=length(x))),0),curve)
    }
    
    if (any(parallelEdge))
    {
      # Set parallelAngle value:   
      parallelAngle <- ifelse(is.na(parallelAngle),ifelse(knots==0&dub&!bidirectional&is.na(parallelAngle),ifelse(E$from==srt[,1],1,-1) * stats::ave(1:nrow(srt),srt[,1],srt[,2],bidirectional,FUN=function(x)seq(parallelAngleDefault,-parallelAngleDefault,length=length(x))),0),parallelAngle) 
    }
    
    rm(dub)
  }
  
  parallelAngle[is.na(parallelAngle)] <- 0
  
  # Layout settings:
  if (nNodes == 1 & isTRUE(rescale))
  {
    layout <- matrix(0,1,2)
  } else {
    if (is.null(layout)) layout="default"
    # Layout matrix:
    if (is.matrix(layout)) if (ncol(layout)>2)
    {
      layout[is.na(layout)] <- 0
      # If character and labels exist, replace:
      if (is.character(layout) && is.character(labels))
      {
        layout[] <- match(layout,labels)
        layout[is.na(layout)] <- 0
        mode(layout) <- 'numeric'
      }
      
      # Check:
      if (!all(seq_len(nNodes) %in% layout)) stop("Grid matrix does not contain a placement for every node.")
      if (any(sapply(seq_len(nNodes),function(x)sum(layout==x))>1)) stop("Grid matrix contains a double entry.")
      
      Lmat=layout
      LmatX=seq(-1,1,length=ncol(Lmat))
      LmatY=seq(1,-1,length=nrow(Lmat))
      layout=matrix(0,nrow=nNodes,ncol=2)
      
      loc <- t(sapply(1:nNodes,function(x)which(Lmat==x,arr.ind=T)))
      layout <- cbind(LmatX[loc[,2]],LmatY[loc[,1]])
      
    }
  }
  
  # Rescale layout:
  l=original.layout=layout
  if (rescale) {
    if (aspect)
    {
      # center:
      l[,1] <- l[,1] - mean(l[,1])
      l[,2] <- l[,2] - mean(l[,2])
      lTemp <- l
      
      if (length(unique(lTemp[,1]))>1)
      {
        l[,1]=(lTemp[,1]-min(lTemp))/(max(lTemp)-min(lTemp))*2-1
      } else l[,1] <- 0
      if (length(unique(lTemp[,2]))>1)
      {
        l[,2]=(lTemp[,2]-min(lTemp))/(max(lTemp)-min(lTemp))*2-1 
      } else l[,2] <- 0
      
      rm(lTemp)
      
      
      
      layout=l    
    } else
    {
      if (length(unique(l[,1]))>1)
      {
        l[,1]=(l[,1]-min(l[,1]))/(max(l[,1])-min(l[,1]))*2-1
      } else l[,1] <- 0
      if (length(unique(l[,2]))>1)
      {
        l[,2]=(l[,2]-min(l[,2]))/(max(l[,2])-min(l[,2]))*2-1 
      } else l[,2] <- 0
      layout=l
    }
  }
  
  ## Offset and scale:
  if (length(layoutScale) == 1) layoutScale <- rep(layoutScale,2)
  if (length(layoutOffset) == 1) layoutOffset <- rep(layoutOffset,2)
  layout[,1] <- layout[,1] * layoutScale[1] + layoutOffset[1]
  layout[,2] <- layout[,2] * layoutScale[2] + layoutOffset[2]
  l <- layout
  
  
  # Set Edge widths:
  if (mode=="direct")
  {
    edge.width <- abs(E$weight)
  } else
  {
    if (weighted)
    {
      edge.width <- avgW*(esize-1)+1
      edge.width[edge.width<1]=1
    } else {
      edge.width <- rep(esize,length(E$weight))
    }
  }
  
  
  # Set edge colors:
  if (is.null(edge.color) || (any(is.na(edge.color)) || any(is.na(fade)) || any(fade != 1)))
  {
    if (!is.null(edge.color))
    {
      repECs <- TRUE
      ectemp <- edge.color
    } else  repECs <- FALSE
    
    # col vector will contain relative strength:
    col <- rep(1,length(E$from))
    
    if (!weighted) 
    {
      if (!is.logical(transparency)) Trans <- transparency else Trans <- 1
      edge.color <- rep(addTrans(unCol,round(255*Trans)),length(edgesort))
    }
    if (repECs)
    {
      # Colors to fade:
      indx <- !is.na(ectemp) & is.na(fade)
      
      edge.color[indx] <- ectemp[indx]
      rm(ectemp)
      rm(indx)
    }
  } else {
    if (length(edge.color) == 1) edge.color <- rep(edge.color,length(E$from))
    if (length(edge.color) != length(E$from)) stop("Number of edge colors not equal to number of edges")
  }
  
  if (is.null(color) & !is.null(groups))
  {
    if (is.function(palette)){
      color <- palette(length(groups))
    } else if (palette == "rainbow"){
      color <- grDevices::rainbow(length(groups), start = rainbowStart, end = (rainbowStart + (max(1.1,length(groups)-1))/length(groups)) %% 1)   
    }  else stop(paste0("Palette '",palette,"' is not supported."))
  }
  
  # Default color:
  if (is.null(color))	color <- "background"  
  
  
  
  vertex.colors <- rep(color, length=nNodes)
  if (!is.null(groups)) 
  {
    vertex.colors <- rep("background", length=nNodes)
    for (i in 1:length(groups)) vertex.colors[groups[[i]]]=color[i] 
  } else vertex.colors <- rep(color, length=nNodes)
  if (length(color)==nNodes) vertex.colors <- color
  if (all(grDevices::col2rgb(background,TRUE) == grDevices::col2rgb("transparent",TRUE)))
  {
    vertex.colors[vertex.colors=="background"] <- "white"
  } else  vertex.colors[vertex.colors=="background"] <- background
  
  # Label color:
  if (length(lcolor) != nNodes){
    lcolor <- rep(lcolor,nNodes)
  }
  if (any(is.na(lcolor))){
    lcolor[is.na(lcolor)] <- ifelse(vertex.colors == "background",
                                    ifelse(mean(grDevices::col2rgb(background)/255) > 0.5,"black","white"),
                                    ifelse(colMeans(grDevices::col2rgb(vertex.colors[is.na(lcolor)])/255) > label.color.split,"black","white")
    )
  }
  
  # Dummy groups list:
  if (is.null(groups)) 
  {
    groups <- list(1:nNodes)
  }
  
  # Scores:
  if (!is.null(scores)) 
  {
    if (length(scores)!=nNodes)
    {
      warning ("Length of scores is not equal to nuber of items")
    } else
    {
      bcolor <- vertex.colors
      if (is.null(scores.range)) scores.range=c(min(scores),max(scores))
      scores[is.na(scores)]=scores.range[1]
      rgbmatrix=1-t(grDevices::col2rgb(vertex.colors)/255)
      for (i in 1:nNodes) rgbmatrix[i,]=rgbmatrix[i,] * (scores[i]-scores.range[1] ) / (scores.range[2]-scores.range[1] )
      vertex.colors=grDevices::rgb(1-rgbmatrix)
    }
  }
  
  if (diagCols)
  {
    if (diagCols & !is.null(scores)) stop("Multiple modes specified for vertex colors (diag and scores)")
    if (diagCols & weighted)
    {
      if (is.null(bcolor) & !all(vertex.colors=="white")) bcolor=vertex.colors
      if (cut==0) 
      {
        colV=(abs(diagWeights)-minimum)/(maximum-minimum)
      } else 
      {
        colV=(abs(diagWeights)-minimum)/(cut-minimum)
      }
      colV[colV>1]=1
      colV[colV<0]=0
      
      if (transparency) 
      {
        vertex.colors=rep("#00000000",nNodes)
        colV=colV^(2)
        neg=grDevices::col2rgb(grDevices::rgb(0.75,0,0))/255
        pos=grDevices::col2rgb(grDevices::rgb(0,0.6,0))/255
        
        # Set colors for edges over cutoff:
        vertex.colors[diagWeights< -1* minimum] <- grDevices::rgb(neg[1],neg[2],neg[3],colV[diagWeights< -1*minimum])
        vertex.colors[diagWeights> minimum] <- grDevices::rgb(pos[1],pos[2],pos[3],colV[diagWeights> minimum])
      } else 
      {
        vertex.colors=rep("white",nNodes)
        vertex.colors[diagWeights>minimum]=grDevices::rgb(1-colV[diagWeights > minimum],1-(colV[diagWeights> minimum]*0.25),1-colV[diagWeights > minimum])
        vertex.colors[diagWeights< -1*minimum]=grDevices::rgb(1-(colV[diagWeights< (-1)*minimum]*0.25),1-colV[diagWeights < (-1)*minimum],1-colV[diagWeights < (-1)*minimum])
      }
      if (cut!=0)
      {
        # Set colors for edges over cutoff:
        vertex.colors[diagWeights<= -1*cut] <- "red"
        vertex.colors[diagWeights>= cut] <- "darkgreen"
      }
    }
  }
  if (is.null(bcolor))
  {
    bcolor <- rep(ifelse(mean(grDevices::col2rgb(background)/255)>0.5,"black","white"),nNodes)
  } else {
    bcolor <- rep(bcolor,length=nNodes)
  }
  
  if (any(vTrans<255) || length(vTrans) > 1)
  {
    if ( length(vTrans) > 1 && length(vTrans) != nNodes)
    {vTrans <- 255}
    
    # Transparance in vertex colors:
    num2hex <- function(x)
    {
      hex=unlist(strsplit("0123456789ABCDEF",split=""))
      return(paste(hex[(x-x%%16)/16+1],hex[x%%16+1],sep=""))
    }
    
    colHEX <- grDevices::rgb(t(grDevices::col2rgb(vertex.colors)/255))
    
    vertex.colors <- paste(sapply(strsplit(colHEX,split=""),function(x)paste(x[1:7],collapse="")),num2hex(vTrans),sep="")
  }
  
  
  # Vertex size:
  if (length(vsize)==1) vsize=rep(vsize,nNodes)
  if (length(vsize2)==1) vsize2=rep(vsize2,nNodes)
  if (!edgelist) Vsums=rowSums(abs(input))+colSums(abs(input))
  if (edgelist)
  {
    Vsums=numeric(0)
    for (i in 1:nNodes) Vsums[i]=sum(c(input[,1:2])==i)
  }
  if (length(vsize)==2 & nNodes>2 & length(unique(Vsums))>1) vsize=vsize[1] + (vsize[2]-vsize[1]) * (Vsums-min(Vsums))/(max(Vsums)-min(Vsums))
  if (length(vsize)==2 & nNodes>2 & length(unique(Vsums))==1) vsize=rep(mean(vsize),nNodes)
  
  if (length(vsize2)==2 & nNodes>2 & length(unique(Vsums))>1) vsize2=vsize2[1] + (vsize2[2]-vsize2[1]) * (Vsums-min(Vsums))/(max(Vsums)-min(Vsums))
  if (length(vsize2)==2 & nNodes>2 & length(unique(Vsums))==1) vsize2=rep(mean(vsize2),nNodes)
  
  # Vertex shapes:
  if (length(shape)==1) shape=rep(shape,nNodes)
  
  # means:
  if (length(means)==1) means <- rep(means,nNodes)
  if (length(SDs)==1) SDs <- rep(SDs, nNodes)
  
  # Arrow sizes:
  if (length(asize)==1) asize=rep(asize,length(E$from))
  
  if (length(asize)!=length(E$from)) warning("Length of 'asize' is not equal to the number of edges")
  
  
  
  # Edge labels:
  # Make labels:
  
  if (!is.logical(edge.labels))
  {
    #       edge.labels=as.character(edge.labels)
    if (length(edge.labels)!=length(E$from))
    {
      warning("Number of edge labels did not correspond to number of edges, edge labes have been ommited")
      edge.labels <- FALSE
    }
    
    if (length(edge.labels) > 0 & is.character(edge.labels))
    {
      edge.labels[edge.labels=="NA"]=""
    }  
  } else
  {
    if (edge.labels)
    {
      edge.labels= as.character(round(E$weight,2))
    } else edge.labels <- rep('',length(E$from))
  }
  
  if (is.numeric(edge.labels)) edge.labels <- as.character(edge.labels)
  
  # Bars:
  length(bars) <- nNodes
  barSide <- rep(barSide,nNodes)
  barColor <- rep(barColor, nNodes)
  barLength <- rep(barLength, nNodes)
  barColor[barColor == 'border'] <- bcolor[barColor == 'border']
  
  
  # Compute loopRotation:
  if (DoNotPlot)
  {
    loopRotation[is.na(loopRotation)] <- 0
  } 
  
  
  # Node names:
  if (is.null(nodeNames)) nodeNames <- labels
  
  
  # Make labels:
  if (is.logical(labels))
  {
    if (labels)
    {
      labels=1:nNodes
    } else 
    {
      labels <- rep('',nNodes)
    }
  }
  
  border.width <- rep(border.width, nNodes)
  
  # Node argument setup:
  borders <- rep(borders,length=nNodes)
  label.font <- rep(label.font,length=nNodes)
  
  # Make negative dashed:
  if (negDashed){
    lty[] <- ifelse(E$weight < 0, 2, 1)
  }
  
  ########### SPLIT HERE ###########
  
  ### Fill qgraph object with stuff:
  ## Edgelist:
  qgraphObject$Edgelist$from <- E$from
  qgraphObject$Edgelist$to <- E$to
  qgraphObject$Edgelist$weight <- E$weight
  qgraphObject$Edgelist$directed <- directed
  qgraphObject$Edgelist$bidirectional <- bidirectional
  
  # Nodes:
  qgraphObject$graphAttributes$Nodes$border.color <- bcolor
  qgraphObject$graphAttributes$Nodes$borders <- borders
  qgraphObject$graphAttributes$Nodes$border.width <- border.width
  qgraphObject$graphAttributes$Nodes$label.cex <- label.cex
  qgraphObject$graphAttributes$Nodes$label.font <- label.font
  qgraphObject$graphAttributes$Nodes$label.color <- lcolor
  qgraphObject$graphAttributes$Nodes$labels <- labels
  qgraphObject$graphAttributes$Nodes$names <- nodeNames
  qgraphObject$graphAttributes$Nodes$loopRotation <- loopRotation
  qgraphObject$graphAttributes$Nodes$shape <- shape
  qgraphObject$graphAttributes$Nodes$color <- vertex.colors
  qgraphObject$graphAttributes$Nodes$width <- vsize
  qgraphObject$graphAttributes$Nodes$height <- vsize2
  qgraphObject$graphAttributes$Nodes$subplots <- subplots
  qgraphObject$graphAttributes$Nodes$images <- images
  qgraphObject$graphAttributes$Nodes$bars <- bars
  qgraphObject$graphAttributes$Nodes$barSide <- barSide
  qgraphObject$graphAttributes$Nodes$barColor <- barColor
  qgraphObject$graphAttributes$Nodes$barLength <- barLength
  qgraphObject$graphAttributes$Nodes$means <- means
  qgraphObject$graphAttributes$Nodes$SDs <- SDs
  qgraphObject$graphAttributes$Nodes$node.label.offset <- node.label.offset
  qgraphObject$graphAttributes$Nodes$node.label.position <- node.label.position
  
  
  # Pies:
  qgraphObject$graphAttributes$Nodes$pieColor <- pieColor
  qgraphObject$graphAttributes$Nodes$pieColor2 <- pieColor2
  qgraphObject$graphAttributes$Nodes$pieBorder <- pieBorder
  qgraphObject$graphAttributes$Nodes$pie <- pie
  qgraphObject$graphAttributes$Nodes$pieStart <- pieStart
  qgraphObject$graphAttributes$Nodes$pieDarken <- pieDarken
  
  
  
  # Edges:
  qgraphObject$graphAttributes$Edges$curve <- curve
  qgraphObject$graphAttributes$Edges$color <- edge.color
  qgraphObject$graphAttributes$Edges$labels <- edge.labels
  qgraphObject$graphAttributes$Edges$label.cex <- edge.label.cex
  qgraphObject$graphAttributes$Edges$label.bg <- edge.label.bg
  qgraphObject$graphAttributes$Edges$label.margin <- edge.label.margin
  qgraphObject$graphAttributes$Edges$label.font <- edge.label.font
  qgraphObject$graphAttributes$Edges$label.color <- ELcolor
  qgraphObject$graphAttributes$Edges$width <- edge.width
  qgraphObject$graphAttributes$Edges$lty <- lty
  qgraphObject$graphAttributes$Edges$fade <- fade
  qgraphObject$graphAttributes$Edges$edge.label.position <- edge.label.position
  qgraphObject$graphAttributes$Edges$residEdge <- residEdge
  qgraphObject$graphAttributes$Edges$CircleEdgeEnd <- CircleEdgeEnd
  qgraphObject$graphAttributes$Edges$asize <- asize
  if (mode == "sig") qgraphObject$graphAttributes$Edges$Pvals <- Pvals else Pvals <- NULL
  qgraphObject$graphAttributes$Edges$parallelEdge <- parallelEdge
  qgraphObject$graphAttributes$Edges$parallelAngle <- parallelAngle
  qgraphObject$graphAttributes$Edges$edgeConnectPoints <- edgeConnectPoints
  
  # Knots:
  qgraphObject$graphAttributes$Knots$knots <- knots
  qgraphObject$graphAttributes$Knots$knot.size <- knot.size
  qgraphObject$graphAttributes$Knots$knot.color <- knot.color
  qgraphObject$graphAttributes$Knots$knot.borders <- knot.borders
  qgraphObject$graphAttributes$Knots$knot.border.color <- knot.border.color
  qgraphObject$graphAttributes$Knots$knot.border.width <- knot.border.width
  
  # Graph:
  qgraphObject$graphAttributes$Graph$nNodes <- nNodes
  qgraphObject$graphAttributes$Graph$weighted <- weighted
  qgraphObject$graphAttributes$Graph$edgesort <- edgesort
  qgraphObject$graphAttributes$Graph$scores <- scores
  qgraphObject$graphAttributes$Graph$scores.range <- scores.range
  qgraphObject$graphAttributes$Graph$groups <- groups
  qgraphObject$graphAttributes$Graph$minimum <- minimum
  qgraphObject$graphAttributes$Graph$maximum <- maximum
  qgraphObject$graphAttributes$Graph$cut <- cut
  qgraphObject$graphAttributes$Graph$polygonList <- polygonList
  qgraphObject$graphAttributes$Graph$mode <- mode
  qgraphObject$graphAttributes$Graph$color <- color
  
  # Layout:
  qgraphObject$layout <- layout
  qgraphObject$layout.orig <- original.layout
  
  # Plot options:
  qgraphObject$plotOptions$filetype <- filetype
  qgraphObject$plotOptions$filename <- filename
  qgraphObject$plotOptions$background <- background
  qgraphObject$plotOptions$bg <- bg
  qgraphObject$plotOptions$normalize <- normalize
  qgraphObject$plotOptions$plot <- plot
  qgraphObject$plotOptions$mar <- mar
  qgraphObject$plotOptions$GLratio <- GLratio
  qgraphObject$plotOptions$legend <- legend
  qgraphObject$plotOptions$legend.cex <- legend.cex
  qgraphObject$plotOptions$pty <- pty
  qgraphObject$plotOptions$XKCD <- XKCD
  qgraphObject$plotOptions$residuals <- residuals
  qgraphObject$plotOptions$residScale <- residScale
  qgraphObject$plotOptions$arrows <- arrows
  qgraphObject$plotOptions$arrowAngle <- arrowAngle
  qgraphObject$plotOptions$open <- open
  qgraphObject$plotOptions$curvePivot <- curvePivot
  qgraphObject$plotOptions$curveShape <- curveShape
  qgraphObject$plotOptions$curveScale <- curveScale
  qgraphObject$plotOptions$curveScaleNodeCorrection <- curveScaleNodeCorrection
  qgraphObject$plotOptions$curvePivotShape <- curvePivotShape
  qgraphObject$plotOptions$label.scale <- label.scale
  qgraphObject$plotOptions$label.scale.equal <- label.scale.equal
  qgraphObject$plotOptions$label.fill.vertical <- label.fill.vertical
  qgraphObject$plotOptions$label.fill.horizontal <- label.fill.horizontal
  qgraphObject$plotOptions$label.prop <- label.prop
  qgraphObject$plotOptions$label.norm <- label.norm
  # qgraphObject$plotOptions$overlay <- overlay
  qgraphObject$plotOptions$details <- details
  qgraphObject$plotOptions$title <- title
  qgraphObject$plotOptions$title.cex <- title.cex
  qgraphObject$plotOptions$preExpression <- preExpression
  qgraphObject$plotOptions$postExpression <- postExpression
  qgraphObject$plotOptions$legend.mode <- legend.mode
  qgraphObject$plotOptions$srt <- srt
  qgraphObject$plotOptions$gray <- gray
  # qgraphObject$plotOptions$overlaySize <- overlaySize
  qgraphObject$plotOptions$plotELBG <- plotELBG
  qgraphObject$plotOptions$alpha <- alpha
  qgraphObject$plotOptions$width <- width
  qgraphObject$plotOptions$height <- height
  qgraphObject$plotOptions$aspect <- aspect
  qgraphObject$plotOptions$rescale <- rescale
  qgraphObject$plotOptions$barsAtSide <- barsAtSide
  qgraphObject$plotOptions$bgres <- bgres
  qgraphObject$plotOptions$bgcontrol <- bgcontrol
  qgraphObject$plotOptions$resolution <- res
  qgraphObject$plotOptions$subpars <- subpars
  qgraphObject$plotOptions$subplotbg <- subplotbg
  qgraphObject$plotOptions$usePCH <- usePCH
  qgraphObject$plotOptions$node.resolution <- node.resolution
  qgraphObject$plotOptions$noPar <- noPar
  qgraphObject$plotOptions$meanRange <- meanRange
  qgraphObject$plotOptions$drawPies <- drawPies
  qgraphObject$plotOptions$pieRadius <- pieRadius
  qgraphObject$plotOptions$pastel <- pastel
  qgraphObject$plotOptions$piePastel <- piePastel
  
  qgraphObject$plotOptions$rainbowStart <- rainbowStart
  qgraphObject$plotOptions$pieCIs <- pieCIs 
  
  return(qgraphObject)
}