module IRAM(address,word_out,clk);
	input [15:0] address;
	input clk;
	output [15:0] word_out;
	reg [15:0] memory [511:0];
	
	parameter ADD=6'd1,SUB=6'd2,MUL=6'd3,DIV=6'd4,NEGATION=6'd5, LEFT_SHIFT=6'd6, RIGHT_SHIFT =6'd7, BIT_AND =6'd8, BIT_OR =6'd9, CONSTANT2REG=6'd10,MERGE=6'd11; 
	parameter MEM_WRITE= 6'd12, MEM_READ = 6'd13, JUMPZ =6'd14, NJUMPZ =6'd15,OVER= 6'd16,JUMPG=6'd17;

	parameter PC =3'd1,DR =3'd2,R1 =3'd3,R2 =3'd4,R3 =3'd5,R4 =3'd6,R5 =3'd7;//RELATED TO THE A_BUS AND B_BUS
	
	parameter C_PC=4'd1,C_DR=4'd2,C_R1=4'd3,C_R2=4'd4,C_R3=4'd5,C_R4=4'd6,C_R5=4'd7,C_TR=4'd8,C_NO_DEST= 4'd0; //RELATED TO THE C_BUS
	
	parameter DCC= 6'bXXXXXX; //DONT_cARE_COSTANT
	
	parameter DCWR = 10'bXXXXXXXXXx; //DONT_cARE_WRITE_READ
	
	parameter DCTR=12'bxxxxxxxxxxxx;
	
	parameter count_address=20'b00011111111111111111;
	initial
		begin          //0123456789ABCDEF
			/*memory[0]={CONSTANT2REG,C_R1,DCC};
			memory[1]=16'd1235;
			memory[2]={CONSTANT2REG,C_R2,DCC};
			memory[3]=16'd25;
			memory[4]={CONSTANT2REG,C_R3,DCC};
			memory[5]=16'd0;
			memory[6]={CONSTANT2REG,C_DR,DCC};
			memory[7]=16'd25;
			memory[8]={CONSTANT2REG,C_TR,DCC};
			memory[9]=16'd0;
			memory[10]={MERGE,DCWR};
			memory[11]={ADD,R1,R3,C_DR};
		   	memory[12]={MEM_WRITE,DCWR};
			memory[13]={CONSTANT2REG,C_DR,DCC};
			memory[14]=16'd0;
			memory[15]={CONSTANT2REG,C_R1,DCC};
			memory[16]=16'd0;
			memory[17]={MEM_READ,DCWR};
			memory[18]={ADD,R3,DR,C_R1};
			memory[19]={OVER,DCWR};*/
			
			/*memory[0]={CONSTANT2REG,C_R1,DCC};//	R1=0
			memory[1]=16'd0;
			memory[2]={CONSTANT2REG,C_R2,DCC};//	R2=0
			memory[3]=16'd0;
			memory[4]={CONSTANT2REG,C_R3,DCC};//	R3=1
			memory[5]=16'd1;
			memory[6]={CONSTANT2REG,C_R4,DCC};//	R4=0
			memory[7]=16'd0;
			memory[8]={CONSTANT2REG,C_R5,DCC};//	R5=1000
			memory[9]=16'd100;
			memory[10]={CONSTANT2REG,C_DR,DCC};//	DR=0
			memory[11]=16'd0;
			memory[12]={CONSTANT2REG,C_TR,DCC};//	TR=0
			memory[13]={4'd0,DCTR};
			memory[14]={ADD,R1,R4,C_DR};//	DR=R1+R4
			memory[15]={MERGE,DCWR};
			memory[16]={MEM_WRITE,DCWR};
			memory[17]={ADD,R1,R3,C_R1};//	R1=R1+R3(R1=1+R1)
			memory[18]={NJUMPZ,R1,R5,C_NO_DEST};
			memory[19]=16'd14;
			
			memory[20]={CONSTANT2REG,C_R1,DCC};//	R1=0
			memory[21]=16'd0;
			memory[22]={ADD,R2,R4,C_DR};
			memory[23]={MERGE,DCWR};
			memory[24]={CONSTANT2REG,C_DR,DCC};//	DR=0
			memory[25]=16'd0;
			memory[26]={MEM_READ,DCWR};
			memory[27]={ADD,DR,R1,C_R1};
			memory[28]={ADD,R2,R3,C_R2};
			memory[29]={NJUMPZ,R2,R5,C_NO_DEST};
			memory[30]=16'd22;
			memory[31]={CONSTANT2REG,C_R2,DCC};//	R2=2
			memory[32]=16'd3;
			memory[33]={DIV,R1,R2,C_R1};
			memory[31]={CONSTANT2REG,C_R2,DCC};//	R2=2
			memory[32]=16'd255;
			
			memory[33]={JUMPG,R2,R1,C_NO_DEST}; // CHECK R1>255
			memory[34]=16'd37;
			
			memory[35]={CONSTANT2REG,C_R1,DCC};//	R1=0
			memory[36]=16'd65535;
			memory[37]={OVER,DCWR};*/
			
						/*			KERNAL=		  | 1| 2| 1|			MEMORY INDEXING VALUES FOR R3	=		  |(0,0): -257|(0,1):-256|(0,2):-255|
									       	   (1/16)*| 2| 4| 2|							                  |(1,0): -1  |(1,1):0   |(1,2):+1  |
											  | 1| 2| 1|							                  |(2,0):+255 |(2,1):+256|(2,2):+257|
									       						*/

			
			// downsampling algorithm
			memory[0]={CONSTANT2REG,C_R1,DCC};//	R1=257         INTIALIZE
			memory[1]=16'd257;
			
			memory[2]={CONSTANT2REG,C_R4,DCC};//	R4=0			 INTIALIZE
			memory[3]=16'd0;
			
			memory[4]={CONSTANT2REG,C_TR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[5]={4'd1,DCTR};				  // TR=4'd1
			memory[6]={CONSTANT2REG,C_DR,DCC}; // DR=16'D65335
			memory[7]=16'd65535;
			memory[8]={MERGE,DCWR};			  //AR=TR,DR (AR=20'b00011111111111111111)
			memory[9]={CONSTANT2REG,C_DR,DCC};//DR=0 (COUNT VALUE)
			memory[10]= 16'd0;
			memory[11]={MEM_WRITE,DCWR}; // DR=COUNT
			
			memory[12]={CONSTANT2REG,C_R2,DCC};//	R2=0 (SUMMING VARIABLE)INTIALIZE		STATRT OF THE LOOP RELATED TO THE 0-65281 PIXELS      ******************* NUMBER 5
			memory[13]=16'd0;
			
			memory[14]={CONSTANT2REG,C_TR,DCC}; //count read from memory
			memory[15]={4'd1,DCTR};					//TR=4'd1
			memory[16]={CONSTANT2REG,C_DR,DCC};	//TR=16'd65335
			memory[17]=16'd65535;
			memory[18]={MERGE,DCWR};				//AR=TR,DR (AR=20'b00011111111111111111)
			memory[19]={MEM_READ,DCWR};			//DR=COUNT
			
			memory[20]={CONSTANT2REG,C_R5,DCC};	// R5=1 count=count+1
			memory[21]=16'd1;
			memory[22]={ADD,DR,R5,C_DR}; // DR=DR+1
			memory[23]={MEM_WRITE,DCWR};	// count=count+1 WRITE TO THE MEMORY
			
			memory[24]={CONSTANT2REG,C_TR,DCC}; // TR=0
			memory[25]={4'd0,DCTR};
			
			memory[26]={CONSTANT2REG,C_R5,DCC};//	R5=128
			memory[27]=16'd128;
			
			
			memory[28]={JUMPZ,DR,R5,C_NO_DEST}; // IF (COUNT ==128) GOTO THE LINE 47  ELSE GOTO THE LINE 26	(NEXT LINE)
			memory[29]=16'd51;// GO TO LINE NUMBER 47         **number 2
			//(0:2)	PIXEL
			memory[30]={CONSTANT2REG,C_R3,DCC};//	R3=255  
			memory[31]=16'd255;
			memory[32]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[33]={MERGE,DCWR};	//AR=TR,DR
			memory[34]={MEM_READ,DCWR};// DR=MEMORY[AR] (PIXEL VALUE)
			memory[35]={ADD,R2,DR,C_R2};//R2=R2+DR
			//(1:2)	PIXEL 
			memory[36]={CONSTANT2REG,C_R3,DCC};//	R3=1 
			memory[37]=16'd1;
			memory[38]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[39]={MERGE,DCWR};    //AR=TR,DR
			memory[40]={MEM_READ,DCWR}; // DR= MEMORY[AR] (PIXEL VALUE)
			memory[41]={CONSTANT2REG,C_R5,DCC}; // R5=2
			memory[42]=16'd2;
			memory[43]={MUL,R5,DR,C_DR};// DR=2*DR
			memory[44]={ADD,R2,DR,C_R2};// R2= R2+DR
			
			//(2:2)  PIXEL
			memory[45]={CONSTANT2REG,C_R3,DCC};//	R3=257 
			memory[46]=16'd257;
			memory[47]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[48]={MERGE,DCWR};	//AR=TR,DR
			memory[49]={MEM_READ,DCWR};// DR= MEMORY[AR] (PIXEL VALUE)
			memory[50]={ADD,R2,DR,C_R2};//R2= R2+DR
			
			//(1:1) PIXEL
			memory[51]={CONSTANT2REG,C_R3,DCC};//	R3=0 		**number 2
			memory[52]=16'd0;
			memory[53]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[54]={MERGE,DCWR}; // AR=TR,DR
			memory[55]={MEM_READ,DCWR}; // DR=MEMORY[AR]
			memory[56]={CONSTANT2REG,C_R5,DCC};//	R1=4 KERNAL VALUE
			memory[57]=16'd4;
			memory[58]={MUL,R5,DR,C_DR}; //DR=R5*DR
			memory[59]={ADD,R2,DR,C_R2}; //R2=R2+DR
			
			// WEIGHT 2 PIXELS IN THE KERNAL
			memory[60]={CONSTANT2REG,C_R5,DCC};//	R5=2 (KERNAL VALUE=2)
			memory[61]=16'd2;
			
			//UPPER MIDDLE (0,1)	
			memory[62]={CONSTANT2REG,C_R3,DCC};//	R3=256
			memory[63]=16'd256;
			memory[64]={SUB,R1,R3,C_DR};//DR=R1+R3 
			memory[65]={MERGE,DCWR};  //AR=TR,DR
			memory[66]={MEM_READ,DCWR};//DR= MEMORY[AR]
			memory[67]={MUL,R5,DR,C_DR};//DR=R5*DR(DR=2*DR)
			memory[68]={ADD,R2,DR,C_R2};//R2=R2+DR
			
			//BOOTOM MIDLLE (2:1)
			memory[69]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[70]={MERGE,DCWR}; //AR=TR,DR
			memory[71]={MEM_READ,DCWR};//DR=MEMORY[AR]
			memory[72]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[73]={ADD,R2,DR,C_R2};// R2=R2+DR
			
			// LEFT MIDDLE (1:0)
			memory[74]={CONSTANT2REG,C_R3,DCC};//	R3=1  
			memory[75]=16'd1;
			memory[76]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[77]={MERGE,DCWR};//AR=TR,DR
			memory[78]={MEM_READ,DCWR};//DR=MEMORY[AR]
			memory[79]={MUL,R5,DR,C_DR};// DR=2*DR
			memory[80]={ADD,R2,DR,C_R2};// DR=R2+DR
			
			//DIAGONAL PIXEL LEFT COLUMN (0,0)
				
			memory[81]={CONSTANT2REG,C_R3,DCC};//	R3=257  
			memory[82]=16'd257;
			memory[83]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[84]={MERGE,DCWR};//AR=TR,DR
			memory[85]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[86]={ADD,R2,DR,C_R2};// DR=R2+DR
			
				//BOTTOM LEFT PIXEL (2:0)
			memory[87]={CONSTANT2REG,C_R3,DCC};//	R3=255  
			memory[88]=16'd255;
			memory[89]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[90]={MERGE,DCWR};//AR=TR,DR
			memory[91]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[92]={ADD,R2,DR,C_R2};// DR=R2+DR
			
				// AVERAGING
			memory[93]={CONSTANT2REG,C_R5,DCC};//	R5=16 (AVERAGING NUMBER)
			memory[94]=16'd16;
			memory[95]={DIV,R2,R5,C_R2};// R2=R2/16
			
			memory[96]={CONSTANT2REG,C_R5,DCC};//	R5=255 TO CHECK R2 IS GREATER THAN 255
			memory[97]=16'd255;
			
			memory[98]={JUMPG,R5,R2,C_NO_DEST}; // IF !(R5<R2) GOTO LINE 98
			memory[99]=16'd102;// NUMBER 3*********
			
			memory[100]={CONSTANT2REG,C_R2,DCC};//	R2=255 IF(R5<R2) IS TRUE THAT WILL BE EXCUTED 
			memory[101]=16'd255;
				//MEMORY WRITING
			memory[102]={CONSTANT2REG,C_TR,DCC};//	TR=1 NUMBER 3************
			memory[103]={4'd1,DCTR};
			
			memory[104]={CONSTANT2REG,C_R5,DCC};//	R5=0
			memory[105]=16'd0;
			memory[106]={ADD,R4,R5,C_DR};	//DR=R5+R4 (DR=R4)
			memory[107]={MERGE,DCWR}; // AR=TR,DR
			memory[108]={ADD,R2,R5,C_DR}; // DR=R2+R5 (DR=R2)
			
			memory[109]={MEM_WRITE,DCWR}; // NEW CALCULATED VALUE WRITE
			
			//IDEXING OF R4
			memory[110]={CONSTANT2REG,C_R5,DCC};//	R5=1 TO INCREMENT R4 BY 1
			memory[111]=16'd1;
			
			memory[112]={ADD,R4,R5,C_R4}; //R4=R5+R4 (R4=R4+1)
			
			// INDEXING R1
			memory[113]={CONSTANT2REG,C_TR,DCC}; //count read from memory
			memory[114]={4'd1,DCTR}; // TR=1
			memory[115]={CONSTANT2REG,C_DR,DCC};//DR=65535
			memory[116]=16'd65535;
			memory[117]={MERGE,DCWR};// AR=TR,DR
			memory[118]={MEM_READ,DCWR}; // DR=MEMORY[AR] (DR=COUNT)
			
			memory[119]={CONSTANT2REG,C_R5,DCC};//	R5=128
			memory[120]=16'd128;
			
			memory[121]={NJUMPZ,DR,R5,C_NO_DEST}; // IF(R5=!DR) GOTO LINE 126 ELSE GOTO LINE 118 (RELATED TO THE ONE RAW SKIP)
			memory[122]=16'd129;// ** number4
			memory[123]={CONSTANT2REG,C_R5,DCC}; // R5=256
			memory[124]=16'd256;
			memory[125]={ADD,R1,R5,C_R1}; // R1=R1+DR (R1=R1+256)
			memory[126]={CONSTANT2REG,C_DR,DCC}; // DR=0 (TO COUNT RESET)
			memory[127]=16'd0;
			memory[128]={MEM_WRITE,DCWR}; // COUNT=0
			
			memory[129]={CONSTANT2REG,C_R5,DCC};//	R5=2 // ** number4
			memory[130]=16'd2;
			memory[131]={ADD,R1,R5,C_R1};// R1=R1+R5 (R1=R1+2)
			
			
			memory[132]={CONSTANT2REG,C_R5,DCC};//	R5= 65282
			memory[133]=16'd65281;
			memory[134]={NJUMPZ,R5,R1,C_NO_DEST}; // IF(R1!= 65282) GOTO LINE 12 ELSE GOTO LINE 131
			memory[135]=16'd12;//***********NUMBER 5
			////////////////////////////MARGIN ROW /////////////////////
			
			memory[136]={CONSTANT2REG,C_R2,DCC};//	R2=0 ////////////////NUYMBER 6YYYYYYYYYYYYYYYY
			memory[137]=16'd0;
			
			memory[138]={CONSTANT2REG,C_TR,DCC}; // TR=0
			memory[139]={4'd0,DCTR};	
			
			// MIDDLE PIXEL (1:1)
			memory[140]={CONSTANT2REG,C_R3,DCC};//	R3=0 
			memory[141]=16'd0;
			memory[142]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[143]={MERGE,DCWR}; // AR=TR,DR
			memory[144]={MEM_READ,DCWR}; //DR=MEMORY[AR]
			memory[145]={CONSTANT2REG,C_R5,DCC};//	R5=4
			memory[146]=16'd4;
			memory[147]={MUL,R5,DR,C_DR}; // DR=R5*DR(DR=4*DR)
			memory[148]={ADD,R2,DR,C_R2}; // R2=DR+R2
			
			// WEIGHT 2 PIXEL
			memory[149]={CONSTANT2REG,C_R5,DCC};//	R5=2
			memory[150]=16'd2;
			
			//UPPER MIDDLE	(0,1)
			memory[151]={CONSTANT2REG,C_R3,DCC};//	R3=256
			memory[152]=16'd256;
			memory[153]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[154]={MERGE,DCWR}; // AR=TR,DR
			memory[155]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[156]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[157]={ADD,R2,DR,C_R2};// R2=DR+R2
			
			// LEFT MDDLE PIXEL(1,0)
			memory[158]={CONSTANT2REG,C_R3,DCC};//	R3=1
			memory[159]=16'd1;
			
			memory[160]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[161]={MERGE,DCWR}; // AR=TR,DR
			memory[162]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[163]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[164]={ADD,R2,DR,C_R2};// R2=DR+R2
			// RIGHT MIDDLE PIXEL (1,2)
			memory[165]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[166]={MERGE,DCWR};// AR=TR,DR
			memory[167]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[168]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[169]={ADD,R2,DR,C_R2};// R2=DR+R2
			
			// DIAGONAL PIXEL (0,0)
			memory[170]={CONSTANT2REG,C_R3,DCC};//	R3=257
			memory[171]=16'd257;
			memory[172]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[173]={MERGE,DCWR}; // AR=TR,DR
			memory[174]={MEM_READ,DCWR}; // DR=MEMORY[AR]
			memory[175]={ADD,R2,DR,C_R2}; // R2=DR+R2
			
			// PIXEL (0,2)
			memory[176]={CONSTANT2REG,C_R3,DCC};//	R3=255
			memory[177]=16'd255;
			memory[178]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[179]={MERGE,DCWR};// AR=TR,DR
			memory[180]={MEM_READ,DCWR}; // DR=MEMORY[AR]
			memory[181]={ADD,R2,DR,C_R2};// R2=DR+R2
			
				// AVERAGING
			memory[182]={CONSTANT2REG,C_R5,DCC};//	R1=16
			memory[183]=16'd16;
			memory[184]={DIV,R2,R5,C_R2}; // R2=R2/R5
			
			memory[185]={CONSTANT2REG,C_R5,DCC};//	R5=255
			memory[186]=16'd255;
			
			memory[187]={JUMPG,R5,R2,C_NO_DEST}; // IF !(R5<R2) GOTO LINE 186 ELSE LINE 184
			memory[188]=16'd191;// NUMBER XX ****
			
			memory[189]={CONSTANT2REG,C_R2,DCC};//	R2=255
			memory[190]=16'd255;
			
				//MEMORY WRITING
			memory[191]={CONSTANT2REG,C_TR,DCC}; // TR=1 NUMBER XX ****
			memory[192]={4'd1,DCTR};
			
			memory[193]={CONSTANT2REG,C_R5,DCC};//	R5=0
			memory[194]=16'd0;
			memory[195]={ADD,R4,R5,C_DR};// DR=R4+R5 (DR=R4) 
			memory[196]={MERGE,DCWR}; //AR=TR,DR
			memory[197]={ADD,R2,R5,C_DR};// DR=R2+R5(DR=R2)
			
			memory[198]={MEM_WRITE,DCWR}; // NEW CALCULATED VALUE WRITE
			
			//INDEXING R4
			memory[199]={CONSTANT2REG,C_R5,DCC};//	R5=1
			memory[200]=16'd1;
			
			memory[201]={ADD,R4,R5,C_R4}; //R4=R4+R5(R4=R4+1)
			
			// INDEXING R1
			memory[202]={CONSTANT2REG,C_R5,DCC};//	R5=2
			memory[203]=16'd2;
			
			memory[204]={ADD,R1,R5,C_R1}; // R1=R1+R5(R1=R1+2)
			
			// LOPPING
			memory[205]={CONSTANT2REG,C_R5,DCC};//	R5=65535
			memory[206]=16'd65535;
			memory[207]={NJUMPZ,R5,R1,C_NO_DEST};// IF(R1!=R5) GOTO 
			memory[208]=16'd136; ///NUMBER 6YYYYYYYYYYYYYYYYYYYYY
			
			
			//FOR THE LAST PIXEL(65535)
			
			memory[209]={CONSTANT2REG,C_R2,DCC};//	R1=0
			memory[210]=16'd0;
			
			memory[211]={CONSTANT2REG,C_TR,DCC}; // TR=0
			memory[212]={4'd0,DCTR};
			
			// MIDDLE PIXEL (1,1)
			memory[213]={CONSTANT2REG,C_R3,DCC};//	R3=0 number 2******************
			memory[214]=16'd0;
			
			memory[215]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[216]={MERGE,DCWR};// AR=TR,DR
			memory[217]={MEM_READ,DCWR}; // DR=MEMORY[AR]
			memory[218]={CONSTANT2REG,C_R5,DCC};//	R5=4
			memory[219]=16'd4;
			memory[220]={MUL,R5,DR,C_DR}; // DR=R5*DR(DR=4*DR)
			memory[221]={ADD,R2,DR,C_R2}; // R2=R2+DR
			
			//WEIGHT 2 PIXELS
			memory[222]={CONSTANT2REG,C_R5,DCC};//	R5=2
			memory[223]=16'd2;
			
			// UPPER MIDDLE (0,1)
			memory[224]={CONSTANT2REG,C_R3,DCC};//	R3=256
			memory[225]=16'd256;
			memory[226]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[227]={MERGE,DCWR};// AR=TR,DR
			memory[228]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[229]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[230]={ADD,R2,DR,C_R2};// R2=R2+DR
			
			// LEFT PIXEL(1,0)
			memory[231]={CONSTANT2REG,C_R3,DCC};//	R3=256
			memory[232]=16'd1;
			
			memory[233]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[234]={MERGE,DCWR};// AR=TR,DR
			memory[235]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[236]={MUL,R5,DR,C_DR};// DR=R5*DR(DR=2*DR)
			memory[237]={ADD,R2,DR,C_R2};//R2=R2+DR
			
			// DIAGONAL (0,0)
			memory[238]={CONSTANT2REG,C_R3,DCC};//	R3=256
			memory[239]=16'd257;
			
			memory[240]={SUB,R1,R3,C_DR};//DR=R1-R3 
			memory[241]={MERGE,DCWR};// AR=TR,DR
			memory[242]={MEM_READ,DCWR};// DR=MEMORY[AR]
			memory[243]={ADD,R2,DR,C_R2};//R2=R2+DR
			
			//AVERAGING
			memory[244]={CONSTANT2REG,C_R5,DCC};//	R5=16
			memory[245]=16'd16;
			memory[246]={DIV,R2,R5,C_R2};// R2=R2/R5 (R2=R2/16)
			
			memory[247]={CONSTANT2REG,C_R5,DCC};//	R5=255
			memory[248]=16'd255;
			
			memory[249]={JUMPG,R5,R2,C_NO_DEST}; //IF !(R5<R2) GOTO LINE 186 ELSE LINE 184
			memory[250]=16'd253;// NUMBER XXXXXXXXXXXXXXX *********
			
			memory[251]={CONSTANT2REG,C_R2,DCC};//	R2=255
			memory[252]=16'd255;
			
				//MEMORY WRITING
			memory[253]={CONSTANT2REG,C_TR,DCC};//  TR=1  NUMBER XXXXXXXXXXXXXX *******
			memory[254]={4'd1,DCTR};
			
			memory[255]={CONSTANT2REG,C_R5,DCC};//	R5=0
			memory[256]=16'd0;
			memory[257]={ADD,R4,R5,C_DR}; // DR=R4+R5
			memory[258]={MERGE,DCWR};//AR=TR,DR
			memory[259]={ADD,R2,R5,C_DR};// DR=R5+R2(DR=R2)
			
			memory[260]={MEM_WRITE,DCWR}; // NEW CALCULATED VALUE WRITE
			//////////////////////////////FINISH//////////////////////////////////////
			memory[261]={OVER,DCWR};
			
			//////////////////////////end of algorithm///////////////////////////
			
			/////////////////////////////////uart testing/////////////////////////////////////////////
		
			
			
			/*memory[0]={CONSTANT2REG,C_R2,DCC};
			memory[1]=16'd0;
			
			memory[2]={CONSTANT2REG,C_R3,DCC};
			memory[3]=16'd0;
			
			memory[4]={CONSTANT2REG,C_TR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[5]={4'd0,DCTR};
			
			memory[6]={CONSTANT2REG,C_R5,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[7]= 16'd0;
			
			memory[8]={ADD,R2,R5,C_DR};
			
			memory[9]={MERGE,DCWR};// AR=TR,DR
			memory[10]={MEM_READ,DCWR};
		
			memory[11]={ADD,R5,DR,C_R1};
			
			memory[12]={ADD,R3,DR,C_DR};
			
			memory[13]={CONSTANT2REG,C_R5,DCC};//	R5=255
			memory[14]=16'd255;
			
			memory[15]={JUMPG,R5,DR,C_NO_DEST}; //IF !(R5<R2) GOTO LINE 186 ELSE LINE 184
			memory[16]=16'd19;// NUMBER XXXXXXXXXXXXXXX *********
			
			memory[17]={CONSTANT2REG,C_DR,DCC};//	R2=255
			memory[18]=16'd0;
			
			memory[19]={CONSTANT2REG,C_TR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[20]={4'd1,DCTR};
			
			memory[21]={MERGE,DCWR};
			
			memory[22]={MEM_WRITE,DCWR};
			
			memory[23]={CONSTANT2REG,C_R5,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[24]= 16'd1;
			
			memory[25]={ADD,R2,R5,C_R2};
			
			memory[26]={CONSTANT2REG,C_R5,DCC};//	R5=65535
			memory[27]=16'd65536;
			memory[28]={NJUMPZ,R5,R2,C_NO_DEST};// IF(R1!=R5) GOTO 
			memory[29]=16'd4;
			
			memory[30]={OVER,DCWR};*/
			
			/////////////////////////////////end of uart testing/////////////////////////////////////////////
			
			/*memory[0]={4'd0,DCTR};	
			memory[1]={CONSTANT2REG,C_DR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[2]= 16'd0;
			memory[3]={MERGE,DCWR};// AR=TR,DR
			memory[4]={CONSTANT2REG,C_DR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[5]= 16'b1010101010101010;
			memory[6]= {MEM_WRITE,DCWR};
			
			
			memory[7]={CONSTANT2REG,C_DR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[8]= 16'd0;
			
			memory[9]={MEM_READ,DCWR};
			
			memory[10]={CONSTANT2REG,C_R1,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[11]= 16'd0;
			
			memory[12]={ADD,R1,DR,C_R1};// R2=R2+DR
			memory[13]={OVER,DCWR};*/
			
			
			
			/*memory[0]={CONSTANT2REG,C_R1,DCC};//	R1=257         INTIALIZE
			memory[1]=16'd257;
			
			memory[2]={CONSTANT2REG,C_R4,DCC};//	R4=0			 INTIALIZE
			memory[3]=16'd0;
			
			memory[4]={CONSTANT2REG,C_TR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[5]={4'd1,DCTR};				  // TR=4'd1
			memory[6]={CONSTANT2REG,C_DR,DCC}; // DR=16'D65335
			memory[7]=16'd65535;
			memory[8]={MERGE,DCWR};			  //AR=TR,DR (AR=20'b00011111111111111111)
			memory[9]={CONSTANT2REG,C_DR,DCC};//DR=0 (COUNT VALUE)
			memory[10]= 16'd0;
			memory[11]={MEM_WRITE,DCWR}; // DR=COUNT
			
			memory[12]={CONSTANT2REG,C_R2,DCC};//	R2=0 (SUMMING VARIABLE)INTIALIZE		STATRT OF THE LOOP RELATED TO THE 0-65281 PIXELS      ******************* NUMBER 5
			memory[13]=16'd0;
			
			memory[14]={CONSTANT2REG,C_TR,DCC}; // count = 0 //MEMORY LOCATION:20'b00011111111111111111  INTIALIZE
			memory[15]={4'd0,DCTR};
			memory[16]={CONSTANT2REG,C_R3,DCC};//	R3=0 		**number 2
			memory[17]=16'd0;
			memory[18]={ADD,R1,R3,C_DR};//DR=R1+R3 
			memory[19]={MERGE,DCWR}; // AR=TR,DR
			memory[20]={MEM_READ,DCWR}; // DR=MEMORY[AR]
			memory[21]={ADD,R2,DR,C_R2}; //R2=R2+DR
			
			memory[22]={CONSTANT2REG,C_TR,DCC};//  TR=0 NUMBER XXXXXXXXXXXXXX *******
			memory[23]={4'd0,DCTR};
			
			memory[24]={CONSTANT2REG,C_R5,DCC};//	R5=0
			memory[25]=16'd0;
			memory[26]={ADD,R4,R5,C_DR}; // DR=R4+R5
			memory[27]={MERGE,DCWR};//AR=TR,DR
			memory[28]={ADD,R2,R5,C_DR};
			
			memory[29]={MEM_WRITE,DCWR}; // NEW CALCULATED VALUE WRITE
			
			memory[30]={CONSTANT2REG,C_R5,DCC};//	R5=1 TO INCREMENT R4 BY 1
			memory[31]=16'd1;
			
			memory[32]={ADD,R4,R5,C_R4};
			
			memory[33]={CONSTANT2REG,C_TR,DCC}; //count read from memory
			memory[34]={4'd1,DCTR}; // TR=1
			memory[35]={CONSTANT2REG,C_DR,DCC};//DR=65535
			memory[36]=16'd65535;
			memory[37]={MERGE,DCWR};// AR=TR,DR
			memory[38]={MEM_READ,DCWR}; // DR=MEMORY[AR] (DR=COUNT)
			
			memory[39]={CONSTANT2REG,C_R5,DCC};//	R5=128
			memory[40]=16'd128;
			
			memory[41]={NJUMPZ,DR,R5,C_NO_DEST}; // IF(R5=!DR) GOTO LINE 126 ELSE GOTO LINE 118 (RELATED TO THE ONE RAW SKIP)
			memory[42]=16'd49;// ** number4
			memory[43]={CONSTANT2REG,C_R5,DCC}; // R5=256
			memory[44]=16'd256;
			memory[45]={ADD,R1,R5,C_R1}; // R1=R1+DR (R1=R1+256)
			memory[46]={CONSTANT2REG,C_DR,DCC}; // DR=0 (TO COUNT RESET)
			memory[47]=16'd0;
			memory[48]={MEM_WRITE,DCWR}; // COUNT=0
			
			memory[49]={CONSTANT2REG,C_R5,DCC};//	R5=2 // ** number4
			memory[50]=16'd2;
			memory[51]={ADD,R1,R5,C_R1};// R1=R1+R5 (R1=R1+2)
			
			memory[52]={CONSTANT2REG,C_R5,DCC};//	R5=65535
			memory[53]=16'd65535;
			memory[54]={NJUMPZ,R5,R1,C_NO_DEST};// IF(R1!=R5) GOTO 
			memory[55]=16'd12; ///NUMBER 6YYYYYYYYYYYYYYYYYYYYY
			
			memory[56]={OVER,DCWR};*/
		end
	assign word_out=memory[address];
endmodule


/*				a_flag	/b_flag												  c_decorder
 				3'd1 : A_bus = PC;										     	  PC= 4'd1
				3'd2 : A_bus = DR;											  DR= 4'd2
				3'd3 : A_bus = R1;											  R1= 4'd3
				3'd4 : A_bus = R2;											  R2= 4'd4
				3'd5 : A_bus = R3;											  R3= 4'd5
				3'd6 : A_bus = R4;											  R4= 4'd6
				3'd7 : A_bus = R5;                                   							  R5= 4'd7
																					  TR= 4'd8 */
