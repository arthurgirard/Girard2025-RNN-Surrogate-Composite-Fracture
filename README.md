 # Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites

This repository contains the Abaqus VUMAT subroutine and validation files for the paper:

> Girard, A., & Mohr, D. (2025). Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites. *International Journal of Solids and Structures*. (Manuscript No. IJSS-D-25-01338). 
> https://doi.org/10.1016/j.ijsolstr.2025.113703

**Keywords:** `Abaqus`, `VUMAT`, `Fortran`, `RNN`, `Recurrent Neural Network`, `Surrogate Modeling`, `Fiber-Reinforced Composites`, `Matrix Fracture`, `Elasto-Plasticity`, `Computational Mechanics`

## Introduction

This VUMAT subroutine is the implementation of a extended Minimal State Cell (MSC) Recurrent Neural Network (RNN) as a surrogate model. 
It predicts the homogenized elasto-plastic stress-strain response and the matrix fracture initiation (when the fracture indicator $D=1$) of a Reduced Volume Element (RVE) representative of a UD carbon fiber-reinforced composites.

The model formulation is detailed in Section 4.1 of the paper. 
The VUMAT contains around 6500 trainable parameters (additional include of the subroutine). Those trainable parameters are found during the training and fixed
The VUMAT features 5 states variables that are used by the network as latent space to store any time-dependant information. At each call of the subroutine, the previous state variable is used as input of the network this state variable is updated. The evolution of each of the 5 states variable can be accessed as history output in the .odb file. 

This VUMAT implementation was used to generate the results for the structural validation (3-point bending problem) presented in Section 5.6 of the paper. 

## How to Use 
Run the .inp file in the folder 3ptbending_inputfile

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


## How to Explore results


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
