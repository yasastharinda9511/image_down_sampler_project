# image_down_sampler_project

# Introduction
  
  The main purpose of mainting this reprository is to build a custom CISC based processor which is able to perform few arithmatic operations to 
  down sample a **256*256** size of a image. this processor id able to perform 16 different operations. The image is downloaded through the UART communication 
  and stored in the 2MB sram module embedded inside the intel ```Altera DE2-115 Development and Education Board```. Then image is downsampled by applying ``` Gaussianfilter.```
  The final size of the image is 128*128.
  
  # Processor Architecture
  
   1. 5 general purpose :R1,R2,R3,R4,R5 {16 bit register }
   2. 1 temperary register : TR{16 bitsie}
   3. 1 address register: AR {19:0}
   4: 1 instruction register: IR {19:0}
   5: 1 Data register : DR {15:0}
   6. SRAM controller : To store the downloaded image (Interfacing module to the SRAM inside the altera board )
   
   
