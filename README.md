<div align="center">
  <img src="https://github.com/user-attachments/assets/646bc29b-e5ef-4673-a8b0-32d91895943d" width="500" alt="Skybox_Early"/>
</div>

# Stylized-Skybox
![Unity Version](https://img.shields.io/badge/Unity-2022.3.20%20LTS%2B-blueviolet?logo=unity)
![Unity Pipeline Support (Built-In)](https://img.shields.io/badge/BiRP_❌-darkgreen?logo=unity)
![Unity Pipeline Support (URP)](https://img.shields.io/badge/URP_✔️-blue?logo=unity)
![Unity Pipeline Support (HDRP)](https://img.shields.io/badge/HDRP_❌-darkred?logo=unity)

A Stylized skybox shader for Unity URP (2022.3.20f1) as part of my self study on shader programming. 
Some parts of the shader code could work for built-in but is untested and may require some modifications. 
The code is based on MinionsArts' Stylized skybox shader tutorial for Built-In, but has been re-adapted to work properly on Unity 2022 URP.

## Features
- Fully customizable skybox
- Procedural Day/Night cycle
    - Sunsets and sunrises
- Stars at night
- Customizable horizons
- Customizable Clouds
- Customizable Sun and Moon

## Installation
1. Clone repo or download the asset folder and load it into an unity project.
2. If you didn't use the provided one or had made a skybox material, create a material with the skybox's shader.
3. Go to lighting settings, replace the current skybox material with the stylized skybox material.
4. Load the noise images (the ones provided or custom one) for the clouds and/or a star background image for the stars if you want to use those features.
5. Adjust values of the skybox material to edit how your skybox looks.
    
## Cresits/Assets used
 - [Stylized Skybox Shader](https://www.patreon.com/posts/27402644) by MinionsArts. Licensed under MinionsArts's license - See [THIRD PARTY LICENSES](THIRD_PARTY_LICENSES) for details.
 - "[Blue Archive]Kasumizawa Miyu" (https://skfb.ly/oyBXP) by MOMO_RUI is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
 - "Japanese Vending Machine" (https://skfb.ly/6ZCEz) by filadog is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
 - Musemi by Occosoftware. Used for presentation purposes only.
 - Magica Cloth 2 by Magica Soft for hair & cloth physics. Used for presentation purposes only.