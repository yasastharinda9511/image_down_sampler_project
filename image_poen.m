A = imread('Mars2.jpg');
imshow(A);
SendData=serial('COM7','BaudRate',9600);
fopen(SendData);
[rows,columns,bands]=size(A);
disp(size(A));

new_image=zeros(256,256,'uint8')

for i=1:rows
    for j=1:columns
        fwrite(SendData,A(i,j,1));
        
        %fwrite(SendData,200);
    end
   disp(i);
end
  fclose(SendData);
  delete(SendData);
  clear SendData;
  
recData=serial('COM7','BaudRate',9600);
recData.InputBufferSize=1;
fopen(recData);

while(1)
    for i=1:128
        for j=1:128
            %Input1=char(Input1);                 
            %Input1=sscanf(Input1, '%d')
            Input1=fread(recData);
            new_image(i,j,1)=Input1;
        end
        disp(i);
    end
    if(i==128 & j==128)
        break;
    end
end
subplot(1,2,1);  
imshow(A);
subplot(1,2,2);
imshow(new_image);

disp(new_image);

fclose(recData);
delete(recData);
clear recData;