# image_down_sampler_project

# Introduction
  
  The main purpose of mainting this reprository is to build a custom CISC based processor which is able to perform few arithmatic operations to 
  down sample a **256*256** size of a image. this processor id able to perform 16 different operations. The image is downloaded through the UART communication 
  and stored in the 2MB sram module embedded inside the intel ```Altera DE2-115 Development and Education Board```. Then image is downsampled by applying ``` Gaussianfilter.```
  The final size of the image is 128*128.
  
  # Processor Architecture
  
   1. 5 general purpose :R1,R2,R3,R4,R5 {16 bit register }
   2. 1 temperary register : TR{16 bitsize}
   3. 1 address register: AR {19:0}
   4: 1 instruction register: IR {19:0}
   5: 1 Data register : DR {15:0}
   6. SRAM controller : To store the downloaded image (Interfacing module to the SRAM inside the altera board )
  
![Screenshot (503)](https://user-images.githubusercontent.com/37435024/99287186-f0aff680-285f-11eb-9220-f559fed2df73.png)  

#  Instructions

****[x : y]: Ignore x to y bits 

|Instruction|Opcode|Size|ISA|Description|
|----|-----|-----|------|-------|
|ADD|```0b000001```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA+RB|
|SUB|```0b000010```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA-RB|
|MUL|```0b000011```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA*RB|
|DIV|```0b0000100```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA/RB|
|NOT|```0b0000101```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/****[6:4]/destination_C_bus[3:0]```|Rc<---~RA|
|LEFT_SHIFT|```0b000110```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA<<RB|
|RIGHT_SHIFT|```0b000111```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA>>RB|
|BIT_AND|```0b001000```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA & RB|
|BIT_OR|```0b001001```|16 bit|```opcode[15:10]/src_A_Bus[9:7]/src_B_bus[6:4]/destination_C_bus[3:0]```|Rc<---RA OR RB|
|CONST2REG|```0b001010```|32 bit|```opcode[31:26]/src_C_Bus[25:22]/****[22:16]/Value[15:0]```|Rc<---Value|
|MEM_WRITE|```0b001011```|16 bit|```opcode[15:10]/****[9:0]```|DR---->M[AR]|
|MEM_READ|```0b001100```|16 bit|```opcode[15:10]/****[9:0]```|DR<---M[AR]|
|JUMPZ|```0b001101```|32 bit|```opcode[31:26]/****[9:0]/WHERE_TO_JUMP[15:0]```|(z==1)? PC<--WHERE_TO_JUMP[15:0] : PC=PC+1 |
|NJUMPZ|```0b001110```|32 bit|```opcode[31:26]/****[9:0]/WHERE_TO_JUMP[15:0]```|(z==0)?PC<--WHERE_TO_JUMP[15:0] : PC=PC+1|
|OVER|```0b001111```|16 bit|```opcode[15:10]/****[9:0]```|Indicates Code is over|

# Sample Outputs

## OUTPUT_1

![Screenshot (73)](https://user-images.githubusercontent.com/37435024/99291223-76827080-2865-11eb-954d-ac13c843ae90.png)

## OUTPUT_2

![Screenshot (74)](https://user-images.githubusercontent.com/37435024/99291542-ff011100-2865-11eb-9ce4-21b82b72f0e3.png)

## Algorithm

Gaussian Kernel is used.
![YAsas123](https://user-images.githubusercontent.com/37435024/101189439-0fdebe80-367d-11eb-8363-2ac306d62bbc.jpg)

This [link](https://www.google.com/search?client=firefox-b-d&q=gaussian+filter+for+image+processing) provides how Gaussian Filters suitable for this down sample process

[Our implementation of gaussian filter using this custom ISA](https://github.com/yasastharinda9511/image_down_sampler_project/blob/master/IRAM.v)



