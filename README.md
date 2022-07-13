# Estimating Inequality with Missing Incomes

Codes and data to replicate Brunori, P., Salas-Rojo, P. and Verme, P. (2022) Estimating Inequality with Missing Incomes.

This folder includes three files:

nids.csv: Database with 7199 observations used in the paper.

mcar_example: Mocking example to generate a MCAR pattern and correct it with single parametric imputation. 
This R code can be easily modified to generate other missing patterns (MAR, MNAR) that can be corrected with
other imputation/correction techniques. 

mar_weights: Vector of probabilities used to generate the MAR pattern. Details regarding this vector can be obtained upon request.
