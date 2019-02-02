# Immersive Low Vision Simulation
Visual impairments interfere with normal, daily activities such as driving, reading, and walking. By simulating impairments we may better understand how those afflicted perceive and interact with their environment. Virtual 
reality (VR) provides a unique opportunity for normally sighted people to experience visual impairments in first person. Accordingly, we have created an immersive simulation that maps patient data from a Humphrey Visual Field Analyzer (HVFA) to the field of view of a head-mounted display. I developed this simulation in 2017 with Unity, C#, Python, and Cg/HLSL. This version of the simulation contains no actual patient data to ensure privacy and anonymity.

<b> Code Notes: </b> I need to tidy that document and add options for more current displays.

<b> GitHub Notes: </b> Add Python scripts folder. Explain processing in more detail.  See link for how to structure license and copyright disclaimers when make public: https://github.com/guillaume-chevalier/LSTM-Human-Activity-Recognition 


### Visual Impairments
An estimated 2.9 million Americans are diagnosed with low vision, in which vision is impaired to the degree that it cannot be corrected with glasses alone [1]. The visual impairments expressed by low vision conditions are heterogenous and may therefore vary widely between conditions and even between patients with the same condition. There are several types of visual field loss to consider for simulation:

<ol type="A">
  <li> <b>Scotoma —</b> a partial loss of vision or a blind spot, surrounded by normal vision (e.g. diabetic retinopathy) </li>
  <li> <b>Central Scotoma —</b> loss of central vision (e.g. age-related macular degeneration, optic neuropathy) </li>
  <li> <b>Peripheral Scotoma —</b> loss of peripheral vision (e.g. glaucoma, retinal detachment)  </li>
  <li> <b>Hemianopic Scotoma (Hemianopia) —</b>  binocular vision loss in each eye’s hemifield (e.g. optic nerve damage) 
    <ol>
      <li> <b>Homonymous —</b> loss of half of vision on the same side in both eyes (left or right) </li>
      <li> <b>Heteronymous —</b> loss of half of vision on different sides in both eyes (binasal or bitemporal) </li>
    </ol>
  </li>
</ol>

<p align="center">
  <img width="600" src="LowVisionFigures/TypesOfVisionImpairments.png" alt="Low vision conditions illustrated"> 
</p>


# Data Processing
The Humphrey Visual Field Analyzer (HVFA)  measures retinal sensitivity at specific points in a patient’s field of view. Our simulation processes raw values from the 30-2 protocol, which measures 30° temporally and nasally with 76 points. Data processing was conducted in Python. 

<p align="center">
<img width="400" src="LowVisionFigures/hvfa.png" alt="Example: 30-2 protocol HVFA data for the right eye [2]"> <br>
Example: 30-2 protocol HVFA data for the right eye [2].
</p>


### Retinal Sensitivity Conversion
Retinal sensitivity values, measured in decibels, are converted to linear scale and normalized in the range of [0-1]. Sensx corresponds to the current sensitivity value and SensV is the maximum sensitivity value. 

<p align="center">
  <img width="200" src="LowVisionFigures/Sens_Lin_Form.png" alt="Formula for Retinal Sensitivity"> 
</p>


### Interpolation
The data points are plotted with gaussian interpolation in order to produce an intensity map. 

<p align="center">
  <img width="600" src="LowVisionFigures/SensitivityMap.PNG" alt="Normalized sensitivity values and corresponding intensity map"> 
</p>


### Visual Field Match
The intensity map is scaled to match the field of view (FOV) and pixel density of the head-mounted display. Edge values of the map are extended outward to complete the periphery.

<p align="center">
  <img width="600" src="LowVisionFigures/FOVMap.PNG" alt="Mapping of the HVFA data to the Oculus Rift CV1 pixel resolution and FOV."> 
</p>

The simulation uses the known screen dimensions and approximate fields of view of stereoscopic display devices to map patient data to left and right eye screen shaders. The simulation explicitly supports the following VR head-mounted displays:

  - Oculus Rift CV1
  - Oculus Gear ft. Samsung Galaxy S7
  - Oculus Rift DK2
  - HTC Vive

Otherwise, the simulation assumes 960 x 1080 screen dimension and 94 x 104 degree FOV, which matches the specs of the Oculus Rift DK2. See <b> PlatformDefines.cs</b> for more.



# Graphical Results
The generated map informs two screen shaders, which render directly to the display. Left and right eye information are processed separately. 

<p align="center">
  <img width="800" src="LowVisionFigures/LowVisionSimResults.PNG" alt="Graphical results display no scotoma, opacity, and blur fields for left and right eyes"> 
</p>

## Discussion

We have computationally modeled visual impairments for immersive simulation, which may allow us to better understand both the experience of those with vision loss and vision loss itself. Additionally, the presented work provides an approach to vision loss simulation in which patient data from a perimetry test is leveraged to better represent the heterogeneity of human vision.  

While low vision simulations exist, most are based on the general symptoms of eye diseases [3] and are unable to produce the irregular scotomas that individuals experience in reality. At present, there are few empirical evaluations of visual impairment simulations and no simulation has been implemented in real time with eye tracking. We intend to address both of these concerns in future work. 


## Citation
Copyright (c) 2019 Haley Adams ? Vanderbilt University ? LiVE Lab?  Cite my publication, if Bobby ever gives me the green light to publish something with this *cries*


### Stay Connected

- [Website](https://adhocdown.github.io/index.html)
- [LinkedIn](https://www.linkedin.com/in/haley-alexander-adams/)
- [ResearchGate](https://www.researchgate.net/profile/Haley_Adams7)


## References

[1] [Prevent Blindness America and National Eye Institute. Vision Problems in the U.S. 2012.](https://nei.nih.gov/eyedata) 

[2] [Thomas R & George R. Interpreting automated perimetry. Indian J Ophthalmol. 2001.](https://www.ncbi.nlm.nih.gov/pubmed/15884520)

[3] [Haojie Wu, Daniel Ashmead, Haley Adams, & Bobby Bodenheimer. Simulating Macular Degeneration with Virtual Reality: A Street Crossing Study in a Roundabout Environment. Frontiers in Virtual Environments. 2018.](https://www.frontiersin.org/articles/10.3389/fict.2018.00027/full)
