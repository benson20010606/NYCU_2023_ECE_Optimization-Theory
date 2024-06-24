# NYCU_2023_ECE_Optimization Theory

## HW1: Implement steepest descent method and Newton's method to find out minimum then comapre the result.  　　
1. Given the Rosenbrock function $$f(x) = 100 (x_2 - x_1^2)^2 + (1-x_1) ^2$$ , whose minimizer is at $\[1.0,1.0]\^T$ .
    
   (a) Implement the steepest descent method with the line search algorithm from $\(x_1^{(0)},x_2^{(0)}\) = \[-1.2,1.0]\^T$ . Please plot the trace $\(x_1^{(k)},x_2^{(k)}\)$.
   (b) Implement Newton’s method with the line search algorithm from  $\(x_1^{(0)},x_2^{(0)}\) = \[-1.2,1.0]\^T$ . Please plot the trace $\(x_1^{(k)},x_2^{(k)}\)$ and compare the result with (a).  
   
## HW2: Implement Genetic Algorithm 、Particle Swarm Optimization and Cuckoo Algorithm to find out minimum then comapre the result.  
1. Given the Rosenbrock function $$f(x) = 100 (x_2 - x_1^2)^2 + (1-x_1) ^2$$ , whose minimizer is at $\[1.0,1.0]\^T$ .

   (a) Implement the Genetic Algorithm to find the minimizer.  
   (b) Implement the Particle Swarm Optimization to find the minimizer.  
   (c) Implement the Cuckoo Algorithm to find the minimizer.  
   (d) Compare the results obtained from (a)-(c).


| parameter  | PSO  | CS  | GA  |
|------------|------|-----|-----|
|w           |0.729844  |NaN   |NaN|
|$C_1$|1.496180|NaN|NaN|
|$C_2$|1.496180|NaN|NaN|
|$P_a$|NaN|0.25|NaN|
|Crossover rate|NaN|NaN|0.8|
|Mutation rate|NaN|NaN|0.03|
|Bit size|NaN|NaN|32|
|Best f(x)|4.89272e-22|0.00010862|0.0163778|  

In this experiment, the implementation difficulty is arranged from low to high as PSO,
CS, GA. However, due to the low-dimensional and simple nature of the test functions
used, it is challenging to discern whether GA possesses superior capabilities in finding
solutions for multivariate test functions or functions with numerous local extrema.
Additionally, the number of bits significantly affects computation time and solution
accuracy. Therefore, for low-dimensional test functions, using PSO and CS for solution
search is a better choice." (The initial values for testing in all three methods are
identical.)
