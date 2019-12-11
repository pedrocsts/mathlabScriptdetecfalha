Vth = 13800/ sqrt (3); % Fonte de tensao do equivalente de Thevenin do no da subestacao
Zth = ( Vth ^2)/((((1/3)*10E8)*(cos((80/180)*pi)+(1i*sin((80/180)*pi)))));% Impedância equivalente do Thevenin do no da subestacao
Ith = Vth / Zth ; % Fonte de corrente do equivalente de Norton do no da subestacao
Rmax = 10; % Valor máximo da resistencia de falta
% Dados de topologia
%<Barra pai><Barra filho><Comprimento [m]><Raa ohms/m><Xaa ohms/m><Rab ohms/m><Xab ohms/m><Rac ohms/m><Xac ohms/m><Rba ohms/m><Xba ohms/m><Rbb ohms/m><Xbb ohms/m><Rbc ohms/m><Xbc ohms/m><Rca ohms/m><Xca ohms/m><Rcb ohms/m><Xcb ohms/m><Rcc ohms/m><Xcc ohms/m>
TOP034 ;
% Dados das cargas
%<Barra de carga><P trifásico [kW]><cosfi (indutivo)>
CAR034 ;
% Dados das tensões medidas no no da subestação para curtos - circuitos em pontos desconhecidos
% <número do caso><Van real [V]><Van imaginário [V]><Vbn real [V]><Vbn imaginário [V]><Vcn real [V]><Vcn imaginário [V]>
VOL034 ;

%checando se o analise sera monofasica ou trifasica

for contcasos =1:10;
    for contador=1:((size(Emedido)(2)-1)/2)
    if (contador == 1)
      E10means = [Emedido(contcasos,contador+1)+1i*Emedido(contcasos,contador+2)];
  else
      E10means = [E10means ; Emedido(contcasos,contador+1)+1i*Emedido(contcasos,contador+2)];
    end
end

    Zth = eye(size(E10means)(1),size(E10means)(1))*Zth; %matriz de impedancia
    


    
 for cont = 1 :(size(topologia)(1))
   funcao = inf;
    for rf =0.1:1: Rmax % Laco for que testa todos as distancias com passo de 1[m]
      
      for x =1:10: topologia (1 ,3) -1 % Laço for que testa resistencias de 0.1 a Rmax [ ohms ] com passo de 0.1 [ ohm ]
        Ybus=0;
        

        for laco=1:(size(topologia)(1)) %laco para criar as matrizes de impedancia das linhas
          if (laco==cont) %local da falha
           paiaux=topologia(laco,1)/10;
           filhoaux =size(topologia)(1)+2;
           Zaux = topologia(laco,4:end)*x;
           for linhaz =1:(size(Zaux)(2)/6)
              Zaux2(linhaz,1) = Zaux(linhaz)+(1i*Zaux(linhaz+1));
              Zaux2(linhaz,2) = Zaux(linhaz+2)+(1i*Zaux(linhaz+3));
              Zaux2(linhaz,3) = Zaux(linhaz+4)+(1i*Zaux(linhaz+5));
            end
            
           Yaux = inv(Zaux2);
           
           for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,paiaux+int2) = Yaux(int+1,int2+1);
           end
         end
          
          for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,filhoaux+int2) = -Yaux(int+1,int2+1);
           end
         end         
           
           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,paiaux+int2) = -Yaux(int+1,int2+1);
           end
         end   
           
           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,filhoaux+int2) = Yaux(int+1,int2+1);
           end
         end
         
           Ybus = Ybus+Ybusaux;
           Ybusaux=Ybusaux*0;
           %termino do caso no pai - F
           
           %inicio do caso F- Filho
           
           paiaux=size(topologia)(1)+2;
           filhoaux =topologia(laco,2)/10;
           Zaux = topologia(laco,4:end)*(topologia(laco,3)-x);
           
           for linhaz =1:(size(Zaux)(2)/6)
              Zaux2(linhaz,1) = Zaux(linhaz)+(1i*Zaux(linhaz+1));
              Zaux2(linhaz,2) = Zaux(linhaz+2)+(1i*Zaux(linhaz+3));
              Zaux2(linhaz,3) = Zaux(linhaz+4)+(1i*Zaux(linhaz+5));
              end
              
           Yaux = inv(Zaux2);
          
          for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,paiaux+int2) = Yaux(int+1,int2+1);
           end
         end
          
          for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,filhoaux+int2) = -Yaux(int+1,int2+1);
           end
         end         
           
           
           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,paiaux+int2) = -Yaux(int+1,int2+1);
           end
         end   

           
           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,filhoaux+int2) = Yaux(int+1,int2+1);
           end
         end
           Ybus = Ybus+Ybusaux;
           Ybusaux=Ybusaux*0;
         
           
           
            
          else
           paiaux=topologia(laco,1)/10;
           filhoaux =topologia(laco,2)/10;
           Zaux = topologia(laco,4:end)*topologia(laco,3);
           for linhaz =1:(size(Zaux)(2)/6)
              Zaux2(linhaz,1) = Zaux(linhaz)+(1i*Zaux(linhaz+1));
              Zaux2(linhaz,2) = Zaux(linhaz+2)+(1i*Zaux(linhaz+3));
              Zaux2(linhaz,3) = Zaux(linhaz+4)+(1i*Zaux(linhaz+5));
              end
              
           Yaux = inv(Zaux2);
           for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,paiaux+int2) = Yaux(int+1,int2+1);
           end
         end
          
          for int =0:2
             for int2 =0:2
             Ybusaux(paiaux+int,filhoaux+int2) = -Yaux(int+1,int2+1);
           end
         end         
           
           
           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,paiaux+int2) = -Yaux(int+1,int2+1);
           end
         end   

           for int =0:2
             for int2 =0:2
             Ybusaux(filhoaux+int,filhoaux+int2) = Yaux(int+1,int2+1);
           end
         end
           Ybus = Ybus+Ybusaux;
           Ybusaux=Ybusaux*0;    
 end
end
  
% Calculo das impedancias das cargas
    for aux =1: size( cargas)(1)
    Zcarga ( aux ) = (13800^2) /(1000*( cargas ( aux ,2) - 1i* cargas ( aux ,2)  .* tan( acos ( cargas ( aux ,3) ))));
    Zcargaaux = eye(size(E10means)(1),size(E10means)(1))*Zcarga(aux);
    Ycargaaux = inv(Zcargaaux);
    paiaux=cargas(aux,1)/10;
    for int=0:2
      for int2=0:2
        Ybusaux(paiaux+int, paiaux+int2)  = Ycargaaux(int+1,int2+1);
    end
  end
  Ybus = Ybus+Ybusaux;
  Ybusaux=0*Ybusaux;
  end
  
  Zfalha = eye(size(E10means)(1),size(E10means)(1))*rf;
  Yfalha = inv(Zfalha);
    for int=0:2
      for int2=0:2
        Ybusaux(size(topologia)(1)+2+int, size(topologia)(1)+2+int2)  = Yfalha(int+1,int2+1);
    end
  end
  Ybus = Ybus+Ybusaux;
  Ybusaux=0*Ybusaux;
  
  
 
 % impedancias te thevenin
 
 %impedcias de thevenin
  Yth = inv(Zth);
    for int=0:2
      for int2=0:2
        Ybusaux(1+int,1+int2)  = Yth(int+1,int2+1);
    end
  end
  
    for int=0:2
      for int2=0:2
        Ybus(1+int,int2+1)  = Ybus(1+int,int2+1)+Yth(int+1,int2+1);
    end
  end 
  
  %Calculo das tensoes nodais
  
  Ithaux= zeros(size(Ybus)(1),1);
  Ithaux(1)=Ith;
  Ithaux(2)=Ith;
  Ithaux(3)=Ith;


  E = inv(Ybus)*Ithaux;
  
  E10calc = E(1:3);
  
  
  funcao_old =0;
  for ei =1:3
    funcao_old = funcao_old+(abs((E10means(ei)-E10calc(ei))/E10means(ei)));
   end
   
   if(funcao_old<funcao)   
     xcalc =x;
     rcalc = rf;
     funcao=funcao_old;
     nopai = topologia(cont,1);
     nofilho = topologia(cont,2);
   end
   end
 end

 % fprintf (’ Trecho 1 - f: %2.4 f\t - rf: %2.4 f\t - x: %d\n’,funcao ,rcalc , xcalc );
fprintf ("%02.f ,%03.f ,%03.f ,%03.f ,%2.1f ,%2.3f \n", contcasos , nopai ,nofilho, xcalc , rcalc , funcao );

 
 end
end


diary REL034.CVS;
diary OUT034.CVS;
