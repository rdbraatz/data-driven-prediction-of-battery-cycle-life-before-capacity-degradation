# data-driven-prediction-of-battery-cycle-life-before-capacity-degradation

**NOTE: For access to the modeling code, please contact Richard Braatz at braatz@mit.edu for the academic license. Only the data processing code is available without agreeing to a license.**

The code in this repository shows how to load the data associated with the paper ['Data driven prediciton of battery cycle life before capacity degradation' by K.A. Severson, P.M. Attia, et al](https://www.nature.com/articles/s41560-019-0356-8). The data is available at [https://data.matr.io/1/](https://data.matr.io/1/). There you can also find more details about the data.

This analysis was originally performed in MATLAB, but here we also provide access information in python. In the MATLAB files (.mat), this data is stored in a struct. In the python files (.pkl), this data is stored in nested dictionaries.

To execute the python code, we recommended setting up a new python environment with packages matching the requirements.txt file. You can do this with conda: conda create --name <env> --file requirements.txt

The data associated with each battery (cell) can be grouped into one of three categories: descriptors, summary, and cycle.
- **Descriptors** for each battery include charging policy, cycle life, barcode and channel. Note that barcode and channel are currently not available in the pkl files).
- **Summary data** include information on a per cycle basis, including cycle number, discharge capacity, charge capacity, internal resistance, maximum temperature, average temperature, minimum temperature, and chargetime.
- **Cycle data** include information within a cycle, including time, charge capacity, current, voltage, temperature, discharge capacity. We also include derived vectors of discharge dQ/dV, linearly interpolated discharge capacity (i.e. `Qdlin`) and linearly interpolated temperature (i.e. `Tdlin`).

The `LoadData` files show how the data can be loaded and which cells were used for analysis in the paper.
