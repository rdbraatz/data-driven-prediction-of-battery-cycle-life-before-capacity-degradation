# data-driven-prediction-of-battery-cycle-life-before-capacity-degradation

The code in this repository shows how to load the data associated with the paper 'Data driven prediciton of battery cycle life before capacity degradation' by K.A. Severson, P.M. Attia, et al. To access the data, please go to <link>. 

The data associated with each battery (cell) can be grouped into one of three categories: descriptors, summary, and cycle. The descriptors for each battery include: charging policy, cycle life, barcode and channel (note that current in the pkl files, barcode and channel are not available). Summary data include information that is stored on a per cycle basis and includes: cycle number, discharge capacity, charge capacity, internal resistance, maximum temperature, average temperature, minimum temperature, and chargetime. Cycle data include information within a cycle and includes: time, charge capacity, current, voltage, temperature, discharge capacity, as well as derived vectors of discharge dQdV, linearly interpolated discharge capacity and linearly interpolated temperature. In the .mat files, this data is stored in a struct and in the .pkl files, this data is stored in nested dictionaries.

The `Load_data` files show how the data can be loaded and which cells were used for analysis in the paper. 
