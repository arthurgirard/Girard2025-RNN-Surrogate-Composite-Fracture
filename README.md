 # Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites

This repository contains the Abaqus VUMAT subroutine and validation files for the paper:

> Girard, A., & Mohr, D. (2025). Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites. *International Journal of Solids and Structures*. (Manuscript No. IJSS-D-25-01338). 
> https://doi.org/10.1016/j.ijsolstr.2025.113703

**Keywords:** `Abaqus`, `VUMAT`, `Fortran`, `RNN`, `Recurrent Neural Network`, `Surrogate Modeling`, `Fiber-Reinforced Composites`, `Fracture Initiation`, `Elasto-Plasticity`, `Computational Mechanics`

## Introduction

This VUMAT subroutine is the implementation of a extended Minimal State Cell (MSC) Recurrent Neural Network (RNN) as a surrogate model. 
It predicts the homogenized elasto-plastic stress-strain response and the matrix fracture initiation (when the fracture indicator $D=1$) of a Reduced Volume Element (RVE) representative of a UD carbon fiber-reinforced composites.

The model formulation is detailed in Section 4.1 of the paper. 
The VUMAT contains around 6500 trainable parameters (additional include of the subroutine). Those trainable parameters are found during the training and fixed
The VUMAT features 5 states variables that are used by the network as latent space to store any time-dependant information. At each call of the subroutine, the previous state variable is used as input of the network this state variable is updated. The evolution of each of the 5 states variable can be accessed as history output in the .odb file. 

This VUMAT implementation was used to generate the results for the structural validation (3-point bending problem) presented in Section 5.6 of the paper. 

## How to Use 

Loading modules on Euler (ETH) Cluster: 

```module load stack/2024-06 intel-oneapi-compilers/2023.2.0 abaqus/2023 libjpeg-turbo/3.0.0```


Run the .inp file in the folder 3ptbending_inputfile

Example command on Euler Cluster

```sbatch --ntasks=6  --time=4:00:00 --mem-per-cpu=6G --tmp=2G --wrap "unset SLURM_GTIDS; abaqus job=Job.inp user=VUMAT double=both cpus=6 scratch=\$TMPDIR" ```


Field Output request: 
```
*Output, field, number interval=50
*Element Output, directions=YES
E, LE, S, SDV
**
```
S : Stress components returned by the RNN
SDV : States variables


The history of the reaction forces (Plot in fig. XX) are requested

```
*Output, history
*Node Output, nset=Set-RP-Encastre-left
RF1, RF2, RF3, RM1, RM2, RM3
```

The role of each state variable is detailed in parenthesis below: 
```
*DEPVAR, DELETE=15 (Numner of the state variable controlling the element deletion)
**Depvar
     15, (number of states variables)
1,  INCEPS1,    IncrementSrain 1 (input of the RNN)
2,  INCEPS2,    IncrementSrain 2 (input of the RNN)
3,  INCEPS3,    IncrementSrain 3 (input of the RNN)
4,  MEM1,    LMSC  memory state 1 (State variable as latent space of the RNN)
5,  MEM2,    LMSC  memory state 2 (State variable as latent space of the RNN)
6,  MEM3,    LMSC  memory state 3 (State variable as latent space of the RNN)
7,  MEM4,    LMSC  memory state 4 (State variable as latent space of the RNN)
8,  MEM5,    LMSC  memory state 5 (State variable as latent space of the RNN)
9,  NORM,    Increment_Norm (used to normalize the inputs)
10, Frac_ini,    Fracture_initiation (Prediction of the fracture initiation, output)
11, Damp_1,    Damp_Strain_1 (Damping applied on the Stress output S11)
12, Damp_2,    Damp_Strain_2 (Damping applied on the Stress output S22)
13, Damp_3,    Damp_Strain_3 (Damping applied on the Stress output S33)
14, Damp_4,    Damp_Strain_4 (Damping applied on the Stress output S12)
15, ElmDEL,    ElmDEL (State variable controlling the Element deletion)
```

## How to Cite

If you use this code or model in your research, please cite the original paper.

```bibtex
@article{Girard2025,
  title   = {Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites},
  author  = {Girard, Arthur and Mohr, Dirk},
  journal = {International Journal of Solids and Structures},
  year    = {2025},
  note    = {Manuscript No. IJSS-D-25-01338} 
}
```

## I'm open for collaboations
Let's connect 
> https://www.linkedin.com/in/arthur-girard/
