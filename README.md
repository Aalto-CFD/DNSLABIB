# DNSLABIB
[DNSLABIB](https://github.com/Aalto-CFD/DNSLABIB) is a tool for Computational Fluid Dynamics (CFD), implementing the incompressible Navier-Stokes equations with a passive
scalar transport equation and Lagrangian particle tracking in MATLAB both on a GPU and CPU.

## Table of contents
* [Description](#description)
* [Dependencies](#dependencies)
* [Validation](#validation)
* [How to use](#how-to-use)
* [Authors](#authors)
* [References](#references)

## Description

**DNSLABIB** is a CFD tool which solves the incompressible Navier-Stokes equations in MATLAB. DNSLABIB also implements a passive scalar transport equation and Lagrangian particle tracking.
The numerical implementation is based on a modified Chorin-Temam projection method, where finite differences are utilized for the momentum equation and spectral methods
are employed in the pressure equation for an improved accuracy in the pressure solution. The explicit 4th order Runge-Kutta method is applied for time discretization.
Furthermore, hard walls and obstacles are implemented with the Immersed Boundary Method (IBM).

The code runs on a GPU (and CPU), making it ideal for rapidly solving large systems, such as scale-resolved ventilation flow simulations in a
large indoor space. The favorable performance profile of the software in such cases in comparison to OpenFOAM is detailed in [[1]](#1).

## Dependencies
**DNSLABIB** has been developed on the standard installation of [`MATLAB R2021a`](https://se.mathworks.com/products/new_products/release2021a.html).
The software has been successfully tested with MATLAB R2021b and R2022a as well.

## Validation
The software has been validated in two canonical reference flow cases: the pressure-driven channel flow and a channel flow with a cubic obstacle.
The software has also been validated against a similar OpenFOAM case in a more realistic indoor ventilation setup.

For more details, please refer to [[1]](#1).

## How to use
The code has three indoor ventilation cases provided as tutorials which are documented in [[1]](#1). The user can initiate a simulation by entering
the respective tutorial case folder and running `runscript.m`. The fluid properties and parameters as well as outputting settings can be accessed
by modifying `SetParameters.m` in each case and the flow geometry can be altered in `CreateGeometry.m`. The momentum sinks and sources, necessary
for inducing velocity-controlled flows, are controlled in `CreateSourceMasks.m` and `CreateFields.m` and have to be updated in `ConstructVelocityIncrement.m`
and `ConstructScalarIncrement.m` as well when modified.

## Authors
The open-source library is a property of [Aalto-CFD](https://github.com/Aalto-CFD) and it is developed and currently maintained by

- Marko Korhonen (marko.korhonen@aalto.fi)
- Ville Vuorinen (ville.vuorinen@aalto.fi)

## References

<a id="1">[1]</a> 
M. Korhonen, A. Laitinen, G. E. Isitman, J.L. Jimenez and V. Vuorinen. A GPU-accelerated computational fluid dynamics solver for assessing shear-driven indoor airflow and virus transmission by scale-resolved simulations. doi:[10.48550/arXiv.2204.02107](https://doi.org/10.48550/arXiv.2204.02107). (2022)
