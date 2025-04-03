# Synthetic-fMRI

**Author:** Igor Fabian Tellez Ceja  
**Mail:** igor.tellez@gmail.com 
 
---

## Project Overview

**Synthetic-fMRI** is a research-grade Python toolkit to generate simulated functional MRI (fMRI) 4D datasets designed to evaluate and benchmark spatial denoising methods under tightly controlled conditions.

This repository was developed as part of my doctoral research on precision fMRI at 7 Tesla and supports systematic investigations into how different noise sources and denoising filters affect spatial signal recovery and statistical reliability. The approach is inspired by methods used in high-field neuroimaging.

> 📘 Reference publication:  
> Tellez Ceja, I.F. et al., *Precision fMRI and Cluster-Failure in the Individual Brain*, Human Brain Mapping, 2024.  
> [PMC11345700](https://pmc.ncbi.nlm.nih.gov/articles/PMC11345700/)

---

## Features

- **Reproducible pipeline**: Generates synthetic fMRI datasets based on real brain masks and design matrices using **FSL**, **Python/Numpy**, and **Bash**.
- **Denoising evaluation**: Supports benchmarking of Gaussian filters and the **AWSOM** (Adaptive Weighted Spatial Optimized Model) filter.
- **Quantitative metrics**: Enables direct comparison of **signal-to-noise ratio**, **spatial specificity**, and **false positive rates** under different processing conditions.
- **Modular dataset generation**: Allows for simulation of activation patterns at different resolutions and signal amplitudes, ideal for evaluating ML-based preprocessing.

---

## Why It Matters for ML/Medical Imaging

Synthetic-fMRI enables:

- Testing ML models and preprocessing pipelines before applying them to real patient data.
- Benchmarking denoising methods under known ground truth conditions.
- Enhancing statistical confidence and reproducibility in neuroimaging pipelines.

---

## Technologies Used

- **Python** (NumPy, NiBabel)
- **FSL** (FEAT, BET, FLIRT)
- **Matlab** (SPM, CAT12 toolbox for SANLM filter)
- **Bash scripting**
- Compatible with **Grid Engine** and **Slurm** for HPC environments

---
