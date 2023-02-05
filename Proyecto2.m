cam = ipcam('http://192.168.5.31:8080/videofeed');
preview(cam);
wb = waitbar(0,"-","name", "Espera..","CreateCancelBtn","delete(gcbf)");%% Se crea uan interfaz
i=0;
while true
    img0=snapshot(cam);
    
    img=imsubtract(img0(:,:,1),rgb2gray(img0));%%Rojo
    bw=im2bw(img,0.13);
    bw=medfilt2(bw);
    bw=imopen(bw,strel('disk',1));
    bw=bwareaopen(bw,3000);%elimina area menor a 3000px
    bw=imfill(bw,'holes');
    [L,N]=bwlabel(bw);
   
    img2=imsubtract(img0(:,:,2),rgb2gray(img0));%%Verde
    bw2=im2bw(img2,0.13);
    bw2=medfilt2(bw2);
    bw2=imopen(bw2,strel('disk',2));
    bw2=bwareaopen(bw2,3000);%elimina area menor a 3000px<
    bw2=imfill(bw2,'holes');
    [D,E]=bwlabel(bw2);
    
    img3=imsubtract(img0(:,:,3),rgb2gray(img0));%%Azul
    bw3=im2bw(img3,0.13);
    bw3=medfilt2(bw3);
    bw3=imopen(bw3,strel('disk',3));
    bw3=bwareaopen(bw3,3000);%elimina area menor a 3000px
    bw3=imfill(bw3,'holes');
    [A,B]=bwlabel(bw3);
  
    
    
    %%regionprops
    prop=regionprops(L);
    prop1=regionprops(D);
    prop2=regionprops(A);
    
    
    %%stats que nos ayudara en la altura de la tapa escaneada 
    
    stats = prop;
    stats2=prop1;
    stats3=prop2;
    
    %%fprintf('\nheight=%.1f\n',stats(1).BoundingBox(4));

    
    imshow(img0);
    
    
  
    
  
    for n=1:N
        %%c=round('\nheight=%.1f\n',stats(1).BoundingBox(4));
        c=round(prop(n).Centroid); % obtener centroide
        rectangle('Position',prop(n).BoundingBox,'EdgeColor','r','LineWidth',2); % dibujar rectangulo
        %%rectangle('Position',prop(n).BoundingBox,'EdgeColor','r','LineWidth',2); % dibujar rectangulo
        %text(0.5,0.5, '{first line \newlinesecond line}')
        text(c(1),c(2),strcat('X:',num2str(c(1)),' \newline',' Y:',num2str(c(2))),'Color','green');%agregar coordenada
        line([640/2 640/2], [0 480],'Color','red','LineWidth',2);%dibujo linea vertical
        line([0 640], [480/2 480/2],'Color','red','LineWidth',2);%dibujo linea hrtl
        disp('La tapa tiene marca de colombiana, cocacola y jugo hit')
        
    end
    
     for f=1:E
        ca=round(prop1(f).Centroid); % obtener centroide
        rectangle('Position',prop1(f).BoundingBox,'EdgeColor','g','LineWidth',2); % dibujar rectangulo
        %text(0.5,0.5, '{first line \newlinesecond line}')
        text(ca(1),ca(2),strcat('X:',num2str(ca(1)),' \newline',' Y:',num2str(ca(2))),'Color','green');%agregar coordenada
        line([640/2 640/2], [0 480],'Color','red','LineWidth',2);%dibujo linea vertical
        line([0 640], [480/2 480/2],'Color','red','LineWidth',2);%dibujo linea hrtl
        disp('La tapa tiene marca sprite o 7up')
     end
     
     for z=1:B
        cb=round(prop2(z).Centroid); % obtener centroide
        rectangle('Position',prop2(z).BoundingBox,'EdgeColor','b','LineWidth',2); % dibujar rectangulo
        %text(0.5,0.5, '{first line \newlinesecond line}')
        text(cb(1),cb(2),strcat('X:',num2str(cb(1)),' \newline',' Y:',num2str(cb(2))),'Color','green');%agregar coordenada
        line([640/2 640/2], [0 480],'Color','red','LineWidth',2);%dibujo linea vertical
        line([0 640], [480/2 480/2],'Color','red','LineWidth',2);%dibujo linea hrtl
        disp('La tapa no tiene marca')
    end
    
  
    
    
    
    if ~ishandle(wb)
        break
    else
        waitbar(i/10,wb,["num:" num2str(i)]);
    end
    
    i=i+1;
    pause(0.001);
    
end
clear cam;