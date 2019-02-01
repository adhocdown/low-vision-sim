# Immersive Low Vision Simulation
<p><b> Note: </b> I need to tidy that document and add options for more current displays.</p>
<p><b> Note: </b> Add Python scripts folder. Explain processing in more detail</p>
<p><b> Note: </b> Consider adding figures for clarity </p>
<p><b> Note: </b> See link for how to structure license and copyright disclaimers when make public: https://github.com/guillaume-chevalier/LSTM-Human-Activity-Recognition <p>


Visual impairments interfere with normal, daily activities such as driving, reading, and walking. By simulating impairments we may better understand how those afflicted perceive and interact with their environment. Virtual 
reality (VR) provides a unique opportunity for normally sighted people to experience visual impairments in first person. Accordingly, we have created an immersive simulation that maps patient data from a Humphrey Visual Field Analyzer (HVFA) to the field of view of a head-mounted display. I developed this simulation in 2017 with Unity, C#, Python, and Cg/HLSL. This version of the simulation contains no actual patient data to ensure privacy.

<h3>Visual Impairments</h3>
<p>An estimated 2.9 million Americans are diagnosed with low vision, in which vision is impaired to the degree that it cannot be corrected with glasses alone [1]. The visual impairments expressed by low vision conditions are heterogenous and may therefore vary widely between conditions and even between patients with the same condition. There are several types of visual field loss to consider for simulation:
</p>
<ul>
  <li> <b>Scotoma —</b> a partial loss of vision or a blind spot, surrounded by normal vision (e.g. diabetic retinopathy) </li>
  <li> <b>Central Scotoma —</b> loss of central vision (e.g. age-related macular degeneration, optic neuropathy) </li>
  <li> <b>Peripheral Scotoma —</b> loss of peripheral vision (e.g. glaucoma, retinal detachment)  </li>
  <li> <b>Hemianopic Scotoma (Hemianopia) —</b>  binocular vision loss in each eye’s hemifield (e.g. optic nerve damage) 
    <ul>
      <li> <b>Homonymous —</b> loss of half of vision on the same side in both eyes (left or right) </li>
      <li> <b>Heteronymous —</b> loss of half of vision on different sides in both eyes (binasal or bitemporal) </li>
    </ul>
  </li>
</ul>
![HVFA Data Example](LowVisionFigures/hvfa.png)


<h1>Data Processing</h1>
The Humphrey Visual Field Analyzer (HVFA)  measures retinal sensitivity at specific points in a patient’s field of view. Our simulation processes raw values from the 30-2 protocol, which measures 30° temporally and nasally with 76 points. Data processing was conducted in Python. 


<h3>Retinal Sensitivity Conversion</h3>
Retinal sensitivity values, measured in decibels, are converted to linear scale and normalized in the range of [0-1]. Sensx corresponds to the current sensitivity value and SensV is the maximum sensitivity value. 

<h3>Interpolation</h3>
The data points are plotted with gaussian interpolation in order to produce an intensity map. 

<h3>Visual Field Match</h3>
<p> The intensity map is scaled to match the field of view (FOV) and pixel density of the head-mounted display. Edge values of the map are extended outward to complete the periphery. </p>

<p>The simulation uses the known screen dimensions and approximate fields of view of stereoscopic display devices to map patient data to left and right eye screen shaders. The simulation explicitly supports the following VR head-mounted displays:</p>
<ul>
  <li> Oculus Rift CV1
  <li> Oculus Gear ft. Samsung Galaxy S7
  <li> Oculus Rift DK2
  <li> HTC Vive
</ul>
<p> Otherwise, the simulation assumes 960 x 1080 screen dimension and 94 x 104 degree FOV, which matches the specs of the Oculus Rift DK2. See <b> PlatformDefines.cs</b> for more. </p>



<h1>Graphical Results</h1>
The generated map informs two screen shaders, which render directly to the display. Left and right eye information are processed separately. 




<h2>Acknowledgments</h2>
This material is based upon work supported the National Science Foundation under grant 1526448 and Vanderbilt University’s IBM Graduate Fellowship.


<h2>References</h2>

[1] Prevent Blindness America and National Eye Institute. Vision Problems in the U.S. 2012. 

[2] Thomas R & George R. Interpreting automated perimetry. Indian J Ophthalmol. 2001.

[3] Haojie Wu, Daniel Ashmead, Haley Adams, & Bobby Bodenheimer. Simulating Macular Degeneration with Virtual Reality: A Street Crossing Study in a Roundabout Environment. Frontiers in Virtual Environments. 2018.
