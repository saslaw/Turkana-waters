# Local evaporation line model

# The function produces a plot-able data frame of d18O and dD values 
# representing isotope composition of evaporate water 
# given isotope values of input water and atmospheric conditions. 
# Formulas and relationships are defined in Gibson et al 2016 and Horita & Wesolowski 1994.

model.LEL <- function(env.input){
  
  # Celsius to Kelvin conversion
  TK <- env.input["TC"] + 273.15
  
  # liquid-vapor fractionation factors (Horita & Wesolowski 1994)
  aD <- exp( ((1158.8 * TK^3)/1e12) - ((1620.1 * TK^2)/1e9) + ((794.84 * TK)/1e6) - (161.04/1e3)  + (2.992e6/TK^3) )
  a18O <- exp( (-7.685e-3) + (6.7123 / TK) - (1.6664e3 / TK^2) + (0.35041e6 / TK^3) )
  
  # equilibrium isotopic separation (ibid.)
  eD <- (aD - 1) * 1000
  e18O <- (a18O - 1) * 1000
  
  # diffusion controlled fractionation (ibid.)
  ekD <- 12.5 * (1 - env.input["rh"])
  ek18O <- 14.2 * (1 - env.input["rh"])
  
  # atmospheric isotope ratios (Gibson et al 2016 eqn 18) 
  dDA <- (env.input["dDp"] - (env.input["k"] * eD)) / 
    (1 + (1e-3 * env.input["k"] * eD))
  d18OA <- (env.input["d18Op"] - (env.input["k"] * e18O)) / 
    (1 + (1e-3 * env.input["k"] * e18O))
  
  # limiting isotope ratios (Gibson et al 2016 eqn 7)
  dstarD <- ((env.input["rh"] * dDA) + ekD + (eD / aD)) / 
    (env.input["rh"] - (1e-3 * (ekD + (eD / aD))))
  dstar18O <- ((env.input["rh"] * d18OA) + ek18O + (e18O / a18O)) / 
    (env.input["rh"] - (1e-3 * (ek18O + (e18O / a18O))))
  
  # temporal enrichment slope (Gibson et al 2016 eqn 6)
  mD <- (env.input["rh"] - (1e-3 * (ekD + (eD / aD)))) /
    ((1 - env.input["rh"]) + (1e-3 * ekD))
  m18O <- (env.input["rh"] - (1e-3 * (ek18O + (e18O / a18O)))) / 
    ((1 - env.input["rh"]) + (1e-3 * ek18O))
  
  # create values for evaporation to inflow ratio (x = E / I) from 0 (no evaporation, lake growing) to 1 (fully evaporated lake)
  # adjust "by" param up or down to have fewer or more points on the model line
  x <- seq(from = 0, to = 1, by = 0.07) 
  
  # lake water isotopes for values of x (Gibson et al 2016 eqn 10) and vapor isotopes (eqn 3)
  dDL <- (env.input["dDi"]  + (mD * x * dstarD)) / (1 + mD * x)
  d18OL <- (env.input["d18Oi"] + (m18O * x * dstar18O)) / (1 + m18O * x)
  dDv <- (((dDL - eD) / aD) - (env.input["rh"] * dDA) - ekD) / (1 - env.input["rh"] + (1e-3 * ekD))
  d18Ov <- (((d18OL - e18O) / a18O) - (env.input["rh"] * d18OA) - ek18O) / (1 - env.input["rh"] + (1e-3 * ek18O))
  
  # combine modeled lake and vapor delta values in data frame for plotting
  dL <- as.data.frame(cbind("d18O" = d18OL, "dD" = dDL))
  dv <- as.data.frame(cbind("d18O" = d18Ov, "dD" = dDv))
  model.line <- as.data.frame(rbind(dL, dv))
  
  return(model.line)
}