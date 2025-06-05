Comparación de modelos lineales con complejidad creciente:

## Modelo 2

```
Call:
lm(formula = total_amount ~ trip_distance, data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-92.398  -2.532  -0.557   1.884 161.951 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)   12.426497   0.011265    1103   <2e-16 ***
trip_distance  4.753340   0.004409    1078   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.608 on 399998 degrees of freedom
Multiple R-squared:  0.744,	Adjusted R-squared:  0.744 
F-statistic: 1.162e+06 on 1 and 399998 DF,  p-value: < 2.2e-16
```

## Modelo 1

```
Call:
lm(formula = total_amount ~ trip_distance + trip_duration, data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-75.940  -1.490   0.012   1.331 162.890 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)   9.262353   0.010434   887.7   <2e-16 ***
trip_distance 2.955149   0.004755   621.5   <2e-16 ***
trip_duration 0.569794   0.001064   535.3   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.517 on 399997 degrees of freedom
Multiple R-squared:  0.8508,	Adjusted R-squared:  0.8508 
F-statistic: 1.141e+06 on 2 and 399997 DF,  p-value: < 2.2e-16
```

## Modelo 2

```
Call:
lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough, 
    data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-72.618  -1.480   0.026   1.352 162.784 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)        6.227025   0.120523   51.67   <2e-16 ***
trip_distance      2.819340   0.005402  521.87   <2e-16 ***
trip_duration      0.584639   0.001097  532.97   <2e-16 ***
PUBoroughManhattan 3.085681   0.120256   25.66   <2e-16 ***
PUBoroughQueens    5.522086   0.128346   43.02   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.502 on 399995 degrees of freedom
Multiple R-squared:  0.8521,	Adjusted R-squared:  0.8521 
F-statistic: 5.762e+05 on 4 and 399995 DF,  p-value: < 2.2e-16
```

## Modelo 3

```
Call:
lm(formula = total_amount ~ trip_distance + trip_duration + PUBorough + 
    factor(hour), data = taxis)

Residuals:
    Min      1Q  Median      3Q     Max 
-72.358  -1.429   0.220   1.323 161.591 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)         6.264699   0.121502  51.560  < 2e-16 ***
trip_distance       2.791171   0.005443 512.766  < 2e-16 ***
trip_duration       0.591638   0.001114 530.924  < 2e-16 ***
PUBoroughManhattan  3.117606   0.117201  26.600  < 2e-16 ***
PUBoroughQueens     5.658910   0.125191  45.202  < 2e-16 ***
factor(hour)1      -0.447018   0.052019  -8.593  < 2e-16 ***
factor(hour)2      -0.063718   0.061426  -1.037   0.2996    
factor(hour)3      -0.104430   0.070055  -1.491   0.1360    
factor(hour)4       0.119794   0.088789   1.349   0.1773    
factor(hour)5       0.420332   0.091323   4.603 4.17e-06 ***
factor(hour)6      -1.161724   0.062156 -18.691  < 2e-16 ***
...
factor(hour)19      0.880775   0.039335  22.392  < 2e-16 ***
factor(hour)20      0.067764   0.039657   1.709   0.0875 .  
factor(hour)21      0.094889   0.039732   2.388   0.0169 *  
factor(hour)22      0.111459   0.040726   2.737   0.0062 ** 
factor(hour)23      0.040213   0.043729   0.920   0.3578    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3.412 on 399972 degrees of freedom
Multiple R-squared:  0.8596,	Adjusted R-squared:  0.8596 
F-statistic: 9.073e+04 on 27 and 399972 DF,  p-value: < 2.2e-16
```

## ANOVA

```
Analysis of Variance Table

Model 1: total_amount ~ trip_distance
Model 2: total_amount ~ trip_distance + trip_duration
Model 3: total_amount ~ trip_distance + trip_duration + PUBorough
Model 4: total_amount ~ trip_distance + trip_duration + PUBorough + factor(hour)
  Res.Df     RSS Df Sum of Sq         F    Pr(>F)    
1 399998 8491740                                     
2 399997 4947484  1   3544256 304498.17 < 2.2e-16 ***
3 399995 4905142  2     42342   1818.85 < 2.2e-16 ***
4 399972 4655539 23    249603    932.36 < 2.2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

