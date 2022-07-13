# Estimating Inequality with Missing Incomes

Codes and data that complement Brunori, P., Salas-Rojo, P. and Verme, P. (2022) Estimating Inequality with Missing Incomes.

We include three files:

nids.csv: Database with 7199 observations used in the paper.

mcar_example: Mocking example to generate a MCAR pattern and correct it with a parametric imputation. 
This R code can be easily modified to generate other missing patterns (MAR, MNAR) and imputation/correction techniques. 

mar_weights: Vector of probabilities used to generate the MAR pattern. More details regarding these probabilities can be obtained upon request.
