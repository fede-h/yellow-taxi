Comparación de modelos lineales con complejidad creciente:

## Modelo 0

```
Call:
lm(formula = fare_amount ~ trip_distance, data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-91.047  -1.727  -0.626   1.039 127.281 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)   5.040838   0.008039   627.1   <2e-16 ***
trip_distance 4.365038   0.003486  1252.3   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.038 on 399998 degrees of freedom
Multiple R-squared:  0.7968,	Adjusted R-squared:  0.7968 
F-statistic: 1.568e+06 on 1 and 399998 DF,  p-value: < 2.2e-16
```

## Modelo 1

```
Call:
lm(formula = fare_amount ~ trip_distance + trip_duration, data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-68.795  -0.406  -0.016   0.367 124.147 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)   2.7131447  0.0052180   520.0   <2e-16 ***
trip_distance 2.4439727  0.0028791   848.9   <2e-16 ***
trip_duration 0.5092969  0.0005548   918.0   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.724 on 399997 degrees of freedom
Multiple R-squared:  0.9346,	Adjusted R-squared:  0.9346 
F-statistic: 2.858e+06 on 2 and 399997 DF,  p-value: < 2.2e-16
```

## Modelo 2

```
Call:
lm(formula = fare_amount ~ trip_distance + trip_duration + PUBorough, 
    data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-68.615  -0.402  -0.011   0.372 123.525 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)         3.3396136  0.0588988   56.70   <2e-16 ***
trip_distance       2.4359979  0.0028750  847.31   <2e-16 ***
trip_duration       0.5103512  0.0005535  922.02   <2e-16 ***
PUBoroughManhattan -0.6313317  0.0587650  -10.74   <2e-16 ***
PUBoroughQueens     2.1854003  0.0828831   26.37   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.718 on 399995 degrees of freedom
Multiple R-squared:  0.935,	Adjusted R-squared:  0.935 
F-statistic: 1.438e+06 on 4 and 399995 DF,  p-value: < 2.2e-16
```

## Modelo 3

```
Call:
lm(formula = fare_amount ~ trip_distance + trip_duration + PUBorough + 
    factor(hour), data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-69.307  -0.405  -0.011   0.379 123.655 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)         3.2028810  0.0607980  52.681  < 2e-16 ***
trip_distance       2.4741695  0.0029701 833.032  < 2e-16 ***
trip_duration       0.5024434  0.0005758 872.673  < 2e-16 ***
PUBoroughManhattan -0.6796302  0.0585140 -11.615  < 2e-16 ***
PUBoroughQueens     2.1106683  0.0825246  25.576  < 2e-16 ***
factor(hour)1      -0.4069671  0.0263953 -15.418  < 2e-16 ***
factor(hour)2       0.0630546  0.0310061   2.034  0.04199 *  
factor(hour)3       0.0286666  0.0346463   0.827  0.40801    
factor(hour)4       0.2356460  0.0446564   5.277 1.31e-07 ***
factor(hour)5       0.2262188  0.0475752   4.755 1.99e-06 ***
...                                                       ***
factor(hour)18      0.1719038  0.0194653   8.831  < 2e-16 ***
factor(hour)19      0.0581443  0.0198561   2.928  0.00341 ** 
factor(hour)20     -0.0042762  0.0200096  -0.214  0.83078    
factor(hour)21      0.0291795  0.0200672   1.454  0.14592    
factor(hour)22      0.0628285  0.0205673   3.055  0.00225 ** 
factor(hour)23      0.0229156  0.0219964   1.042  0.29751    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.711 on 399972 degrees of freedom
Multiple R-squared:  0.9356,	Adjusted R-squared:  0.9356 
F-statistic: 2.151e+05 on 27 and 399972 DF,  p-value: < 2.2e-16
```

## ANOVA

```
Analysis of Variance Table

Model 1: fare_amount ~ trip_distance
Model 2: fare_amount ~ trip_distance + trip_duration
Model 3: fare_amount ~ trip_distance + trip_duration + PUBorough
Model 4: fare_amount ~ trip_distance + trip_duration + PUBorough + factor(hour)
  Res.Df     RSS Df Sum of Sq         F    Pr(>F)    
1 399998 8491740                                     
2 399997 4947484  1   3544256 304498.17 < 2.2e-16 ***
3 399995 4905142  2     42342   1818.85 < 2.2e-16 ***
4 399972 4655539 23    249603    932.36 < 2.2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

