# Code for: Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites

This repository contains the Abaqus VUMAT subroutine and validation files for the paper:

> Girard, A., & Mohr, D. (2025). Recurrent Neural Network Model Predicting Elasto-Plasticity and Matrix Fracture in Fiber-Reinforced Composites. *International Journal of Solids and Structures*. (Manuscript No. IJSS-D-25-01338). 
> [DOI: 10.XXXX/XXXXX]

**Keywords:** `Abaqus`, `VUMAT`, `Fortran`, `RNN`, `Recurrent Neural Network`, `Surrogate Modeling`, `Fiber-Reinforced Composites`, `Matrix Fracture`, `Elasto-Plasticity`, `Computational Mechanics`

## Introduction

This VUMAT subroutine implements an **extended Minimal State Cell (MSC) Recurrent Neural Network (RNN)** as a surrogate model. It is designed to predict the homogenized elasto-plastic stress-strain response and the **matrix fracture initiation** (when the fracture indicator $D=1$) in fiber-reinforced composites.

The model formulation is detailed in **Section 4.1** of the paper. This VUMAT implementation was used to generate the "Homogeneous FE with RNN" results for the structural validation (3-point bending problem) presented in **Section 5.6**.

## How to Use 

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
