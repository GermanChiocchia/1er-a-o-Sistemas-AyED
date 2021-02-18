{Trabajo practico N°2 Algoritmos y estructura de datos 2020-Chiocchia, Angelini}

{ Se aconseja ver la tabla resumen de procedimientos y funciones para mayor
claridad}

{ Se pueden utilizar los señaladores (GoTo bookmarks para
desplazarse a los distintos bloques)}

program TPN2;
uses crt;
const
     ce = 5;  {numero de provincias}
     es = 5;     {sintomas}
     we = 3;    {enfermedades}
type
     matriz = array[1..ce,1..2] of string;    {matrices de codigo-provincia}
     sint = array[1..es] of string;
     enfe = array[1..we] of string;
     enfsint = array[1..we,1..es]of integer;
var
    le,term,term1,term2,opc:char;
    cod_prov:matriz;
    sintomas,cod_sint,cod_enf,det_sint:sint;
    enf:enfe;
    matriz_enf_sint:enfsint;
    i,j,k,conteo_letra,ind,c1,c2,contador,suma:integer;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{----------------------------------------------------------------------------}
{ Bloque N°1: Visualizacion}


{procedimiento de pantalla}
procedure grilla(posx,posy,fil,col,tamx,tamy:integer);

begin
     for i:=1 to (col*tamx) do
         for j:=1 to (fil+1) do                         {la coordenada (posx,posy) indica el origen de la grilla}
                 begin                                  {las constantes fil y col indican respectivamente el nro de filas y columnas deseadas}
                      GotoXY(posx+i,posy+(j-1)*tamy);   {finalmente tamx y tamy respectivamente significan el ancho y la altura de cada celda a formar}
                      write('_');
                 end;
      for i:=1 to (fil*tamy) do
          for j:= 1 to (col+1) do
                 begin
                      GotoXY(posx+(j-1)*tamx,posy+i);
                      write('|');
                 end;
end;


{Muestra el menu de opciones}
procedure mostrar_menu;

begin
gotoxy(50,2);writeln('MENU PRINCIPAL');
gotoxy(7,6);writeln('- Opcion:       -1-          -2-          -3-           -4-         -5-           -6-        -0-');
gotoxy(7,8);writeln('- Descrip:   PROVINCIAS    SINTOMAS     ENFERMED     PACIENTES   H CLINICAS     ESTADIS     SALIR');
grilla(5,3,1,8,13,7);
gotoxy(5,12);
writeln('Seleccione una opcion por favor:');
end;


{cuadro orientativo de sintomas para el usuario}
procedure sintomas_tentativo;

begin
     gotoxy(88,3);writeln(' SINTOMAS SUGERIDOS');
     gotoxy(84,6);writeln(' 1  CAL        Calambres');
     gotoxy(84,7);writeln(' 2  CNA        Congestion nasal');
     gotoxy(84,8);writeln(' 3  CON        Conjuntivitis');
     gotoxy(84,9);writeln(' 4  DIA        Diarrea');
     gotoxy(84,10);writeln(' 5  DRE        Dif respiratoria');
     gotoxy(84,11);writeln(' 6  DAB        Dolor abdominal');
     gotoxy(84,12);writeln(' 7  DDC        Dolor de cabeza');
     gotoxy(84,13);writeln(' 8  DDG        Dolor de garganta');
     gotoxy(84,14);writeln(' 9  DMU        Dolor muscular');
     gotoxy(84,15);writeln('10  DDO        Dolor de ojos');
     gotoxy(84,16);writeln('11  FAT        Fatiga');
     gotoxy(84,17);writeln('12  FIE        Fiebre');
     gotoxy(84,18);writeln('13  INA        Inapetencia');
     gotoxy(84,19);writeln('14  INS        Insomnio');
     gotoxy(84,20);writeln('15  NAU        Nauseas');
     gotoxy(84,21);writeln('16  OAM        Ojos amarillos');
     gotoxy(84,22);writeln('17  PGU        Perdida gusto');
     gotoxy(84,23);writeln('18  SAR        Sarpullido');
     gotoxy(84,24);writeln('19  SOM        Somnoliencia');
     gotoxy(84,25);writeln('20  TSE        Tos seca');

     grilla(75,4,1,2,22,22);
     gotoxy(1,4);
end;

{----------------------------------------------------------------------------}
{ Bloque N°2: validacion}


{ Valida el ingreso de la opcion}
procedure validar_opc(var opc:char);
begin
     while (opc<'0') or (opc>'6') do
        begin
        ClrScr;
        writeln('Por favor ingrese una opcion entre 0 y 6 cuya finalidad esta descripta a continuacion: ');
        writeln();
        mostrar_menu;
	    readln(opc);
        end;
end;


{Validar codigo ISO para las provincias de la OPCION 1}
procedure validar_cod(var cod:string);
var
   l:integer;
   i:char;
          begin

               l:=0;
               while l=0 do
               begin
                     cod:=Upcase(cod);
                     for i:= 'A' to 'Z' do
                     begin
                         if (cod = i) and (cod<>'I') and (cod<>'O')then
                            l:=1;
                     end;
                         if l<>1 then
                             begin
                             writeln('El codigo ingresado no es correcto(ISO 3166-2:AR), del codigo solo debe ingresar la letra final:');
                             readln(cod);
                             end;
               end;
          end;


{Validar letra para el conteo de provincias en la OPCION 1}
procedure validar_letra(var le:char);    {validacion y tamizaje para conteo de letra}
    var
    l:integer;
    i:char;
          begin

               l:=0;
               le:=Upcase(le);
               while (l=0) and (le <>'Z') do
               begin
                    le:=Upcase(le);
                    for i:= 'A' to 'Y' do
                    begin
                         if le = i then
                         begin
                              if (le='C')or (le='E')or (le='F')or (le='J')or (le='L')or (le='M')or (le='N')or (le='P')or (le='R')or (le='S')or (le='T') then
                              l:=1;
                         end;
                    end;
                    if (l<>1) and (le<>'Z')then
                       begin
                       writeln('No hay provincias con esa letra, o el caracter no es valido, por favor intentelo de nuevo ("z" para finalizar): ');
                       readln(le);
                       end;
               end;
          end;

{Verifica si los sintomas ya se cargaron , para la OPCION 3}
procedure verif_carga_sint(sintomas,cod_sint:sint;var a:integer);
begin
     a:=0;
     for i:=1 to es do
     if (sintomas[i]<>'') and (cod_sint[i]<>'') then
        a:=1;
end;



{ Pasar palabras a mayuscula}
FUNCTION Mayus(S:string):string;
var
   aud:string;
   pos:integer;
begin
     aud:='';
     for pos:=1 to Length(S) do
         aud:= aud + upcase(S[pos]);
     Mayus:=aud;
end;


{ Indice para buscar nombre y descipcion a traves del codigo de sintoma}
function indice(cod:string): integer;
      begin
      indice:=0;
      for j:=1 to es do
      begin
           if cod_sint[j]=cod then
              indice:=j
      end;
end;
 
{ Validar ingreso de sintoma para la OPCION 3}
function validar_sint(cod:string):string;
begin
     cod:=Mayus(cod);
     ind:=indice(cod);
     while ind=0 do
     begin
          write('Ingrese un codigo correcto: ');
          readln(cod);
          cod:=Mayus(cod);
          ind:=indice(cod);
     end;
     validar_sint:=cod;
end;


{Validar el ingreso del DNI para la OPCION 4}
procedure validar_dni(var dni:string);
var
   r,s:integer;
   j:char;
begin
     r:=0;
     s:=length(dni);
     while (r<>s) or (s=0) do
     begin
          if s>0 then
          begin
               if s<9 then
               begin
                    for i:=1 to s do
                        for j:='0' to '9' do
                            if dni[i]=j then r:=r+1;
               end
               else
               begin
                    writeln('Debe ingresar un dni mas corto, max 8 numeros.');
               end;
          end
          else
              begin
                   writeln('Debe ingresar algun dni.');
              end;
          if (r<>s) or (s=0) then
             begin
                  writeln('Use solo caracteres numericos.');
                  readln(dni);
                  s:=length(dni);
                  r:=0;
             end;
     end;
end;


{Validar la edad para la OPCION 4}
procedure validar_edad(var edad:integer);
begin
          edad:=str(edad);
          while edad>122 do
          begin
                writeln('Ingrese una edad valida: ');
                readln(edad);
          end;
end;




{ Validar respuesta binaria}
function validar_S_N(resp_bool:char):char;
begin
     resp_bool:=upcase(resp_bool);
     while (resp_bool<>'S') AND (resp_bool<>'N') do
     begin
           write('Ingresar opcion correcta(S o N): ');
           readln(resp_bool);
           resp_bool:=upcase(resp_bool);
     end;
     validar_S_N:=resp_bool;
end;




{Valida la terminacion del programa}
procedure validar_termino(var termin:char);
begin
     termin:=upcase(termin);
     while (termin <> 'S') and (termin <> 'N') do
           begin
           write('Desea detener la ejecucion del programa? - Presione N para continuar, S para salir.');
           readln(termin);
           termin:=upcase(termin);
           end;
end;

{----------------------------------------------------------------------------}
{ Bloque N°3 Procedimientos de la OPCION 1}


{Crea una matriz vacia para la carga de datos}
procedure inicializar_matriz(var mat_1:matriz);
          begin
          for i:=1 to ce do
                 for j:=1 to 2 do
                     mat_1[i,j]:=('');
          end;



{carga y validacion del cod del arreglo provincias}
procedure carga_cod_prov(var p:matriz);
var
   w:string;
          begin
          writeln();
          for i:=1 to ce do
                 for j:=1 to 2 do
                 begin

                      if j=1 then
                         begin
                              writeln('Ingrese la ultima letra del codigo acorde a la norma iso: ');
                              readln(w);
                              validar_cod(w);
                              while length(w)>1 do
                              begin
                                    writeln('Ingresar una letra unicamente');
                                    validar_cod(w);
                              end;
                              p[i,j]:='AR-'+w;
                         end
                      else
                         begin
                              writeln('Ingrese su respectiva provincia: ');
                              readln(p[i,j]);
                         end;

                 end;
          end;


{cuenta la primer letra seleccionada por el usuario}
procedure contar_prov(q:matriz; var w:char; var cont:integer);
var
   aux2:string;

begin
     cont:=0;
     w:=Upcase(w);
     for i:=1 to ce do
         begin
          aux2:=q[i,2];
          aux2[1]:=Upcase(aux2[1]);
          if (aux2[1]= w) then
                       cont:=cont+1;
         end;
end;

{ordenamiento por criterios}
procedure orden_cod_prov(var r:integer; var p:matriz);

var
   k:integer;
   aux:string;

begin

          for i:=1 to (ce-1) do
              begin
              for k:=(i+1) to ce do
                  begin
                  if p[i,r] > p[k,r] then        {r indica en que columna nos paramos para ordenar}
                               begin
                               for j:=1 to 2 do
                                   begin
                                   aux := p[i,j];
                                   p[i,j] := p[k,j];
                                   p[k,j] := aux;
                                   end;
                               end;
                  end;
              end;
end;


{muestra la matriz seleccionada}
procedure mostrar(cart:integer; var crit_ord:matriz);
var
   cartel:string;
          begin
               if cart=1 then cartel:= 'codigo.'
                         else
                             cartel:= 'nombre.';

               gotoxy(50*(cart-1),1);
               writeln('Provincias ordenadas por ',cartel);
               orden_cod_prov(cart,crit_ord);
               gotoxy(50*(cart-1),2);
               writeln('    Codigo ---- Provincia');
               for i:=1 to ce do
                   for j:=1 to 2 do
                   begin
                       gotoxy(50*(cart-1)+8*j,3+i);
                       write(crit_ord[i,j]);
                   end;
               writeln();
          end;

{----------------------------------------------------------------------------}
{ Bloque N°4: Procedimientos de la OPCION 2}

{ Cargar sintoma, su codigo y descripcion}
procedure cargar_sint(var sintomas,cod_sint,det_sint:sint);
begin
      sintomas_tentativo;
      for i:=1 to es do
      begin
          write('Ingrese sintoma: ');
          readln(sintomas[i]);
          write('Ingrese codigo de sintoma: ');
          readln(cod_sint[i]);
          cod_sint[i]:=Mayus(cod_sint[i]);
          while length(cod_sint[i])<>3 do
          begin
                 write('Ingrese codigo correcto (3 letras): ');
                 readln(cod_sint[i]);
                 cod_sint[i]:=Mayus(cod_sint[i]);
          end;
          write('Detalle sintoma: ');
          readln(det_sint[i]);
          while length(det_sint[i])>30 do
          begin
               write('Ingrese descripcion mas corta: ');
               readln(det_sint[i]);
          end;
      end;
end;


{----------------------------------------------------------------------------}
{ Bloque N°5: OPCIONES}



{OPCION 1: carga una matriz con codigos y provincias, las muestra, las ordena en 2 criterios y las muestra}
{tambien cuenta la letra seleccionada por el usuario}
procedure opcion_1;
begin
     ClrScr;
     writeln('-CARGA DE CODIGOS Y PROVINCIAS-');
     inicializar_matriz(cod_prov);
     carga_cod_prov(cod_prov);
     ClrScr;
     mostrar(1,cod_prov);
     mostrar(2,cod_prov);
     writeln();
     writeln('Que letra inicial desea contar?(por ejemplo "s"), Si no deseas contar presiona "z".');
     readln(le);
     validar_letra(le);
     while le <> 'Z' do
           begin
           contar_prov(cod_prov,le,conteo_letra);
           writeln();
           writeln('Las provincias que empiezan con ',le,' son: ',conteo_letra,'!');
           writeln();
           writeln('Si desea contar otra letra ingresela, sino, ingrese "z".');
           readln(le);
           validar_letra(le);
           end;

end;


{OPCION 2:cargar listado de sintoma, codigo y descripcion}
procedure opcion_2;
begin
     ClrScr;
     writeln('-CARGA DEL LISTADO DE SINTOMAS A DISPONER-');
     cargar_sint(sintomas,cod_sint,det_sint);
end;


{OPCION 3: realiza la carga de todas las enfermedades con sus respectivos
sintomas y luego de la carga exhibe por cada síntoma, su código, su detalle
y cuantas enfermedades lo presentan}
procedure opcion_3(sintomas,cod_sint,det_sint:sint);
var
   cod_matriz:string;
   a:integer;
begin
     begin
     ClrScr;
     writeln();
     writeln('-CARGA DE ENFERMEDADES Y ASIGNACION DE SINTOMAS-');
     {Generar matriz de enfermedades y sintomas}
     c1:=0;
     enf[1]:='a';
     term2:='N';
     verif_carga_sint(sintomas,cod_sint,a);
     if a=0 then
        begin
        writeln('Por favor primero dirijase a la opcion 2, SINTOMAS.');
        term2:= 'S';
        writeln();
        end;
     while term2='N' do
     begin
          {cargar datos de enfermedad y su codigo}
          c1:=c1+1;
          write('Inserte enfermedad: ');
          readln(enf[c1]);
          write('Ingrese codigo de enfermedad: ');
          readln(cod_enf[c1]);
          cod_enf[c1]:=Mayus(cod_enf[c1]);
          while length(cod_enf[c1])<>3 do
          begin
                 write('Ingrese codigo correcto (3 letras): ');
                 readln(cod_enf[c1]);
                 cod_enf[c1]:=Mayus(cod_enf[c1]);
          end;

          {Generar una columna vacia de 0s para los sintomas de la enfermedad}
          for k:=1 to es do
              matriz_enf_sint[c1,k]:=0;


          {reemplazar con 1s donde aparezca el sintoma}
          contador:=0;
          term1:='N';

          while (term1='N') AND(contador<6) do
          begin
                contador:=contador+1;
                clrscr;
                sintomas_tentativo;
                write('Ingrese el sintoma correspondiente: ');
                readln(cod_matriz);
                c2:=indice(validar_sint(cod_matriz));
                matriz_enf_sint[c1,c2]:=1;

                write('Termino de cargar los sintomas ?(S/N): ');
                readln(term1);
                term1:=validar_S_N(term1);

          end;

          write('Termino de cargar las enfermedades ?(S/N): ');
          readln(term2);
          term2:=validar_S_N(term2);

     end;

     {Describir resultados}
     if a<>0 then
     begin
     for i:=1 to es do
     begin
          writeln('Sintoma: ',sintomas[i]);
          write('  Codigo: ',cod_sint[i]);
          write(', Descripcion: ',det_sint[i]);
          suma:=0;
          for j:=1 to c1 do
          begin
               suma:=suma+matriz_enf_sint[j,i];
          end;
          writeln(', Enfermedades con el sintoma: ',suma);
     end;
     end;
end;
end;




{OPCION 4: realiza el alta de pacientes y luego de la carga muestra el
promedio de edades de todos los pacientes que fueron atendidos por estas
enfermedades y cuantos pacientes se curaron}
procedure opcion_4;

var
    total_cur,maximo_edad,edad,num_pac:integer;
    promedio_edad,u:real;
    pac_cur:char;
    dni:string;
    termino_pac:char;
begin
     ClrScr;
     writeln();
     writeln('-ALTA DE PACIENTES-');
     u:=0;                                    {-u- permite hacer el promedio entre variables de tipo real e integer}
     promedio_edad:=0;
     maximo_edad:=0;
     total_cur:=0;
     num_pac:=0;

     termino_pac:='N';
     while termino_pac='N' do
     begin
          num_pac:=num_pac+1;

          write('Ingresar DNI del paciente ',num_pac,': ');
          readln(dni);
          validar_dni(dni);
          write('Ingresar edad del paciente ',num_pac,': ');
          readln(edad);
          validar_edad(edad);

          promedio_edad:=promedio_edad+(edad+u);

          if maximo_edad<edad then maximo_edad:=edad;



          write('Se curo el paciente? (S/N): ');
          readln(pac_cur);
          pac_cur:=validar_S_N(pac_cur);

          if pac_cur='S' then total_cur:=total_cur+1;

          write('Termino de ingresar pacientes (S/N): ');
          readln(termino_pac);
          termino_pac:=validar_S_N(termino_pac);


     end;
     clrscr;
     promedio_edad:= promedio_edad/num_pac;

     writeln('La edad promedio es: ',promedio_edad:5:2);
     writeln('La edad maxima es: ',maximo_edad);
     writeln('El numero de pacientes curados es: ',total_cur);


end;


{OPCION 5:cargar historia clinica, opcion en proceso}
procedure opcion_5;
begin
     ClrScr;
     writeln();
     writeln('-HISTORIAS CLINICAS-');
     gotoxy(40,12);writeln('Opcion en proceso, Disculpe las molestias');
     readln();
end;


{OPCION 6:cargar estadisticas, opcion en proceso}
procedure opcion_6;
begin
     ClrScr;
     writeln();
     writeln('-ESTADISTICAS-');
     gotoxy(40,12);writeln('Opcion en proceso, Disculpe las molestias');
     readln();
end;



{ Ejecuta la opcion que corresponde}
procedure opcion(opc:char);
begin
     case opc of
          '1': opcion_1;
          '2': opcion_2;
          '3': opcion_3(sintomas,cod_sint,det_sint);
          '4': opcion_4;
          '5': opcion_5;
          '6': opcion_6;
          '0': begin
               term:= 'S';
               ClrScr;
               gotoxy(51,25);write('Hasta luego.');
               grilla(48,22,1,1,16,5);
               readln();
               end;
     end;
end;


{Decidir si se termino de usar el programa}
procedure termino_sn(var termin:char);
          begin
          termin:=upcase(termin);
          if termin = 'S' then
                     begin
                           ClrScr;
                           gotoxy(51,25);
                           writeln('Hasta luego.');
                           grilla(48,22,1,1,16,5);
                           readln();
                     end
                     else
                     begin
                          writeln('Termino de usar el programa? (S/N)');
                          readln(termin);
                          validar_termino(termin);
                          if termin ='N' then
                                     begin
                                     ClrScr;
                                     mostrar_menu;
                                     end
                                     else
                                     begin
                                     ClrScr;
                                     gotoxy(51,25);
                                     writeln('Hasta luego.');
                                     grilla(48,22,1,1,16,5);
                                     readln();
                                     end;
                     end;
          end;


{----------------------------------------------------------------------------}
{ Bloque N°6: PROGRAMA PRINCIPAL}



begin
     term := 'N';
     mostrar_menu;
     while term <> 'S' do
     begin
           readln(opc);
           validar_opc(opc);
           opcion(opc);
           termino_sn(term);
     end;
end.


{----------------------------------------------------------------------------}
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

