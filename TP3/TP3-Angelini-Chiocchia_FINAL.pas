program TP3(input,output);
uses
    crt,sysutils;
type
    sin = array[1..6] of string[3];
    pr = record
        cod_prov:char;
        nom_prov:string[30];
    end;
    si = record
        cod_sint:string[3];
        nom_sint:string[15];
        desc_sint:string[30];
    end;
    en = record
        cod_enf:string[3];
        nom_enf:string[15];
        desc_enf:string[30];
        sintomas:sin;
    end;
    pa = record
        dni:string[8];
        nom_pac:string[15];
        edad:integer;
        cod_prov:char;
        cant_enf:integer;
        fallecido:char;
    end;
    hi = record
        dni:string[8];
        cod_enf:string[3];
        curado:char;
        fecha_ingreso:TDateTime;
        sin_tomas:sin;
        efector:string[30];
    end;
    ar_pr = file of pr;
    ar_si = file of si;
    ar_en = file of en;
    ar_pa = file of pa;
    ar_hi = file of hi;
var
    a_prov:ar_pr;
    a_sint:ar_si;
    a_enf:ar_en;                    {variables archivo}
    a_pac:ar_pa;
    a_his:ar_hi;

    prov:pr;
    sint:si;
    enf:en;                         {variables elemento de archivo (registro)}
    pac:pa;
    his:hi;

    i,j:integer;
    term,opc:char;

procedure capt(var arch:file);
begin
    {$I-}
    reset(arch);                         {resetea o crea el archivo segun corresponda}
    if ioresult=2 then rewrite(arch);
    {$I+}
end;

function captura(var variable:integer):integer;
begin
    {$I-}
    readln(variable);
    captura:=IOResult;
    {$I+}
end;

procedure inicializar;
begin
    assign(a_prov,'C:\TP3\provincias.dat');
    capt(a_prov);
    assign(a_sint,'C:\TP3\sintomas.dat');
    capt(a_sint);
    assign(a_enf,'C:\TP3\enfermedades.dat');        {asigna y abre variables archivo}
    capt(a_enf);
    assign(a_pac,'C:\TP3\pacientes.dat');
    capt(a_pac);
    assign(a_his,'C:\TP3\historias.dat');       
    capt(a_his);
end;

procedure cerrar;
begin
    close(a_prov);
    close(a_sint);
    close(a_enf);
    close(a_pac);
    close(a_sint);
end;

procedure grilla(posx,posy,fil,col,tamx,tamy:integer);
begin
    for i:=1 to (col*tamx) do
        for j:=1 to (fil+1) do                 {la coordenada (posx,posy) indica el origen de la grilla}
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

procedure mostrar_menu;
begin
    textbackground(black);
    ClrScr;
    gotoxy(50,2);writeln('MENU PRINCIPAL');
    gotoxy(7,6);writeln('- Opcion:       -1-          -2-          -3-           -4-         -5-           -6-        -0-');
    gotoxy(7,8);writeln('- Descrip:   PROVINCIAS    SINTOMAS     ENFERMED     PACIENTES   H CLINICAS     ESTADIS     SALIR');
    grilla(5,3,1,8,13,7);
    gotoxy(5,12);writeln('Seleccione una opcion por favor:');
end;

{------------------------------------------------------------------------------ ORDEN Y BUS}
procedure orden(crit:integer;var arch:ar_pr);
var
    a,b:pr;
begin
    reset(arch);
    for i:=0 to filesize(arch)-2 do
        for j:=i+1 to filesize(arch)-1 do
        begin
            seek(arch,i);
            read(arch,a);
            seek(arch,j);
            read(arch,b);
            case crit of
            1:  if a.cod_prov>b.cod_prov then
                begin
                    seek(arch,i);
                    write(arch,b);
                    seek(arch,j);
                    write(arch,a);
                end;
            2:  if a.nom_prov>b.nom_prov then
                begin
                    seek(arch,i);
                    write(arch,b);
                    seek(arch,j);
                    write(arch,a);
                end;
            end;
        end;
end;

procedure orden_pac(var arch:ar_pa);
var
    a,b:pa;
begin
    seek(arch,0);
    if filesize(arch)>=2 then
    begin
        for i:=0 to filesize(arch)-2 do
            for j:=i+1 to filesize(arch)-1 do
            begin
                seek(arch,i);
                read(arch,a);
                seek(arch,j);
                read(arch,b);
                if a.dni>b.dni then
                begin
                    seek(arch,i);
                    write(arch,b);
                    seek(arch,j);
                    write(arch,a);
                end;
            end;
    end;
end;

procedure orden_his(var arch:ar_hi);
var
    a,b:hi;
begin
    reset(arch);
    for i:=0 to filesize(arch)-2 do
        for j:=i+1 to filesize(arch)-1 do
        begin
            seek(arch,i);
            read(arch,a);
            seek(arch,j);
            read(arch,b);
            if a.dni>b.dni then
            begin
                seek(arch,i);
                write(arch,b);
                seek(arch,j);
                write(arch,a);
            end;
        end;
end;

function busca_dico(var a:ar_pa;b:string):integer;
var
    m:integer;
begin                                  
    i:=0;
    if filesize(a)=0 then
    busca_dico:=-1
    else
    begin
        j:=filesize(a)-1;                   
        m:=(i+j)div 2;
        seek(a,m);
        read(a,pac);
        while (b<>pac.dni) and (i<=j) do
        begin
            if b>pac.dni then
                i:=m+1
            else
                j:=m-1;
            m:=(i+j)div 2;
            seek(a,m);
            read(a,pac);
        end;
        if b=pac.dni then
            busca_dico:=m                  {m --> posicion}
        else
            busca_dico:=-1;
    end;
end;

function bus_dico(var a:ar_pa;b:string):boolean;
begin
	if busca_dico(a,b)=-1 then
	    bus_dico:=false
    else
        bus_dico:=true;
end;

{------------------------------------------------------------------------------ VALIDACION}
function validar_char(cod2:string):char;
begin
    while (length(cod2)>1) or (cod2='') do
    begin
        write('Ingrese un codigo correcto: ');
        readln(cod2);
    end;
    validar_char:=Upcase(cod2[1]);
end;

procedure validar_opc(var opc:char;n:char);
begin
    while (opc<'0') or (opc>n) do
    begin
        ClrScr;
        writeln('Por favor ingrese una opcion entre 0 y 6 cuya finalidad esta descripta a continuacion: ');
        writeln();
        mostrar_menu;
	    readln(opc);
    end;
end;

function validar_string(long:integer;cod2:string):string;
begin
    while (length(cod2)<>long) and (cod2<>'*') do
    begin
        write('Ingrese un codigo correcto(de ',long,'caracteres ("*" para salir): ');
        readln(cod2);
    end;
    if length(cod2)=long then
        validar_string:=UpperCase(cod2)
    else
        validar_string:='*';
end;

{------------------------------------------------------------------------------ OPCION 1}
procedure listar_prov(cart:integer;var a_prov:ar_pr);
var 
    cartel:string;
begin
    case cart of
    1: cartel:='codigo';
    2: cartel:='nombre';
    end;
    seek(a_prov,0);
    gotoxy(4+48*(cart-1),7);
    writeln('Provincias ordenadas por ',cartel,':');
    i:=0;
    while not eof(a_prov) do
    begin
        read(a_prov,prov);
        gotoxy(10+48*(cart-1),10);
        writeln('Codigo              Provincia');
        gotoxy(48*(cart-1)+12,12+i);
        writeln('AR-',prov.cod_prov);
        gotoxy(48*(cart-1)+24,12+i);
        writeln(prov.nom_prov);
        i:=i+1;
    end;
    grilla(3+48*(cart-1),8,1,2,20,4+i);
end;

procedure carga_en_0(var cont:integer;var a_prov:ar_pr);
var
    cod:char;
    cod2:string;
    nom:string[30];
begin
    writeln('Ingrese codigo de provincia, "*" para salir');
    readln(cod2);
    cod:=Upcase(validar_char(cod2));
    while cod<>'*' do
    begin
        seek(a_prov,0);
        while not eof(a_prov) do
        begin
            read(a_prov,prov);
            if cod=prov.cod_prov then
            begin
                writeln('Ingrese un codigo correcto, ese esta repetido.');
                readln(cod2);
                cod:=Upcase(validar_char(cod2));
                seek(a_prov,0);
            end;
        end;
        if (Ord(cod)>=65) and (Ord(cod)<=90) and (cod<>'I') and (cod<>'O') then
        begin
            writeln('Ingrese nombre provincia:');
            readln(nom);
            seek(a_prov,0);
            while not eof(a_prov) do
            begin
                read(a_prov,prov);
                if nom=prov.nom_prov then
                begin
                    writeln('Provincia repetida.');
                    readln(nom);
                    seek(a_prov,0);
                end;
            end;
            if not eof(a_prov) then
                seek(a_prov,filesize(a_prov)-1);
            prov.cod_prov:=cod;
            prov.nom_prov:=nom;
            write(a_prov,prov);
            if Upcase(nom[1])='S'then
                cont:=cont+1;
        end;
        writeln('Ingrese codigo de provincia, "*" para salir');
        readln(cod2);
        cod:=Upcase(validar_char(cod2));
    end;
end;

procedure opcion_1;
var
    cont:integer;
    nom:string;
begin
    reset(a_prov);
    if FileSize(a_prov)=0 then
    begin
        gotoxy(3,1);writeln(' OPCION 1: carga de provincias, archivo vacio.');
        cont:=0;
        carga_en_0(cont,a_prov);
        ClrScr;
        gotoxy(5,4);writeln(cont,' provincias empiezan con "S".');
        grilla(3,2,1,1,33,3);
    end
    else
    begin
        cont:=0;
        writeln('  OPCION 1: archivo ya cargado. Conteo de provincias con "S":');
        reset(a_prov);
        while not eof(a_prov) do
        begin
            read(a_prov,prov);
            nom:=prov.nom_prov;
            if Upcase(nom[1])='S'then
                cont:=cont+1;
        end;
        gotoxy(5,4);writeln(cont,' provincias empiezan con "S".');
        grilla(3,2,1,1,33,3);
    end;
    orden(1,a_prov);
    listar_prov(1,a_prov);
    orden(2,a_prov);
    listar_prov(2,a_prov);
    writeln();
    writeln('   Presione una tecla para continuar...');
    readln();
    ClrScr;
end;

{------------------------------------------------------------------------------ OPCION 2}
procedure sintomas_tentativo;
begin
    gotoxy(88,3);writeln(' SINTOMAS SUGERIDOS');
    gotoxy(80,6);writeln('  -- CAL --        Calambres');
    gotoxy(80,7);writeln('  -- CNA --        Congestion nasal');
    gotoxy(80,8);writeln('  -- CON --        Conjuntivitis');
    gotoxy(80,9);writeln('  -- DIA --        Diarrea');
    gotoxy(80,10);writeln('  -- DRE --        Dif respiratoria');
    gotoxy(80,11);writeln('  -- DAB --        Dolor abdominal');
    gotoxy(80,12);writeln('  -- DDC --        Dolor de cabeza');
    gotoxy(80,13);writeln('  -- DDG --        Dolor de garganta');
    gotoxy(80,14);writeln('  -- DMU --        Dolor muscular');
    gotoxy(80,15);writeln('  -- DDO --        Dolor de ojos');
    gotoxy(80,16);writeln('  -- FAT --        Fatiga');
    gotoxy(80,17);writeln('  -- FIE --        Fiebre');
    gotoxy(80,18);writeln('  -- INA --        Inapetencia');
    gotoxy(80,19);writeln('  -- INS --        Insomnio');
    gotoxy(80,20);writeln('  -- NAU --        Nauseas');
    gotoxy(80,21);writeln('  -- OAM --        Ojos amarillos');
    gotoxy(80,22);writeln('  -- PGU --        Perdida gusto');
    gotoxy(80,23);writeln('  -- SAR --        Sarpullido');
    gotoxy(80,24);writeln('  -- SOM --        Somnoliencia');
    gotoxy(80,25);writeln('  -- TSE --        Tos seca');
    grilla(75,4,1,2,22,22);
    gotoxy(1,4);
end;

procedure listar_sint;
begin
    reset(a_sint);
    i:=0;
    while (not eof(a_sint)) do
    begin
        read(a_sint,sint);
        gotoxy(81,3);write('SINTOMAS CARGADOS: ');
        gotoxy(60,5);write('  - CODIGO -    - NOMBRE -      - DESCRIPCION -');
        gotoxy(65,7+i);write(sint.cod_sint);
        gotoxy(75,7+i);write(sint.nom_sint);
        gotoxy(95,7+i);write(sint.desc_sint);
        i:=i+1;
    end;
    grilla(61,4,1,1,58,2+i);
    writeln();
end;

{------------------------------------------------------------------------------ OPCION 2}
procedure opcion_2;
var
    cod:string[3];
    desc,nom:string;
    traer_datos,seguir_cargando:boolean;
begin
    seguir_cargando:=TRUE;
    j:=0;
    while seguir_cargando do
    begin
        {mostrar datos si no es el primer ingreso}
        reset(a_sint);
        if not eof(a_sint) then
        begin
            ClrScr;
            sintomas_tentativo;
            traer_datos:=TRUE;
            i:=0;
            while traer_datos do
            begin
                read(a_sint,sint);
                gotoxy(2,1);writeln('OPCION 2: carga de sintomas: ');
                gotoxy(2,3);writeln('- CODIGO -     - NOMBRE -         - DESCRIPCION -');
                gotoxy(2,6+i);write(' ',(i+1));
                gotoxy(6,6+i);write(sint.cod_sint);
                gotoxy(13,6+i);write(sint.nom_sint);
                gotoxy(31,6+i);write(sint.desc_sint);
                i:=i+1;
                if eof(a_sint) then
                begin
                    traer_datos:=FALSE;
                    reset(a_sint);
                end;
            end;
            grilla(1,4,1,2,29,2+i);
            gotoxy(2,3+i+j);writeln('Ingresar Codigo de sintoma ("*" para salir): ');
        end
        else
        begin
            i:=0;
            ClrScr;
            sintomas_tentativo;
            writeln('Ingresar Codigo de sintoma ("*" para salir): ');
        end;
        {ingresar codigo, salir si es '*'. de lo contrario verificar si existe
        y luego ingresar descripcion y nombre}
        j:=j+1;
        readln(cod);
        cod:=validar_string(3,cod);
        if cod<>'*' then
        begin
            {verificar solo si no es el primer ingreso}
            if not eof(a_sint) then
            begin
                traer_datos:=TRUE;
                while traer_datos do
                begin
                    read(a_sint,sint);
                    if cod=sint.cod_sint then
                    begin
                        write('Ingresar Codigo Correcto !! : ');
                        readln(cod);
                        cod:=validar_string(3,cod);
                        reset(a_sint);
                    end;
                    if eof(a_sint) then
                        traer_datos:=FALSE;
                end;
            end;
            if cod<>'*' then
            begin
                write('Ingresar Nombre de Sintoma: ');
                readln(nom);
                write('Ingresar Descripcion del mismo: ');
                readln(desc);
            end
            else
            begin
                ClrScr;
                write('Carga terminada por el usuario.');
                writeln();
                seguir_cargando:=FALSE;
            end;
            {guardar los datos, salir si se alcanzo el maximo de sintomas}
            sint.cod_sint:=cod;
            sint.desc_sint:=desc;
            sint.nom_sint:=nom;
            write(a_sint,sint);
            if filesize(a_sint)=20 then
            begin
                write('Se alcanzo el maximo de sintomas(20).');
                seguir_cargando:=FALSE;
            end;
        end
        else
        begin
            ClrScr;
            write('Carga terminada por el usuario.');
            writeln();
            seguir_cargando:=FALSE;
        end;
    end;
end;

{------------------------------------------------------------------------------ OPCION 2}
procedure listar_enf(var l:integer);
var
    k:integer;
begin
    i:=0;
    l:=0;
    ClrScr;
    reset(a_enf);
    gotoxy(16,3);writeln('ENFERMEDADES CARGADAS: ');
    gotoxy(2,4);
    while (not eof(a_enf)) do
    begin
        writeln('-----------------------------------------------------');
        read(a_enf,enf);
        write('  Codigo: ',enf.cod_enf);
        write('   Nombre: ',enf.nom_enf);
        write('   Descrip: ',enf.desc_enf);
        writeln();
        writeln('  - - - - Sintomas de ',enf.cod_enf,': - - - - ');
        k:=0;
        for j:=1 to 6 do
        begin
            if enf.sintomas[j]<>'' then                     
            begin
                write(' - Codigo: ',enf.sintomas[j]);
                reset(a_sint);
                while not eof(a_sint) do
                begin
                    read(a_sint,sint);
                    if enf.sintomas[j]=sint.cod_sint then
                        writeln(' - Nombre: ',sint.nom_sint);
                end;
                k:=k+1;
            end;
        end;
        i:=i+3+k;
    end;
    l:=i;
    grilla(1,4,1,1,53,l);
end;

procedure validar_dni(var dni:string);
var
   r,s:integer;
   j:char;
begin
    r:=0;
    s:=length(dni);
    while ((r<>s) or (s=0)) and (dni<>'*') do
    begin
        if s>0 then
        begin
            if s<9 then
            begin
                for i:=1 to s do
                    for j:='0' to '9' do
                        if (dni[i]=j) or (dni[i]='*') then
                            r:=r+1;
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

function validar_SN(cod2:string):char;
begin
    while (Upcase(cod2[1])<>'S') and (Upcase(cod2[1])<>'N')  do
    begin
        write('Ingrese S o N: ');
        readln(cod2);
    end;
    validar_SN:=Upcase(cod2[1]);
end;

{------------------------------------------------------------------------------ OPCION 3}
procedure opcion_3;
var
    cargar_enfermedades,cargar_sintomas,buscar_sintoma,repet_o_noenc:boolean;
    cs,ce:char;
    n_sint,k,m:integer;
    nomenf:string[15];
    codsint,codenf:string[3];
begin
    m:=0;
    seek(a_sint,0);
    cargar_enfermedades:=TRUE;
    {fijarse si estan cargados los sintomas, luego mostrar lista de enfermedades y sintomas cargados}
    if eof(a_sint) then
    begin
        cargar_enfermedades:=FALSE;
        writeln('Cargar sintomas antes de cargar enfermedades. Dirijase a la OPCION 2.');
    end
    else
    begin
        writeln('Sintomas disponibles para cargar:');
        if not eof(a_enf) then
            listar_enf(m);       
        seek(a_sint,0);
    end;
    seek(a_enf,0);
    {Ingresar enfermedades}
    while cargar_enfermedades do
    begin
        seek(a_sint,0);
        listar_sint;
        gotoxy(2,5+m);
        write('Ingresar codigo de enfermedad: ("*" para salir)');
        readln(codenf);
        codenf:=validar_string(3,codenf);
        if codenf<>'*' then
        begin
            cargar_sintomas:=TRUE;
            {verificar si el codigo de enfermedad ya fue ingresado}
            seek(a_enf,0);
            while not eof(a_enf) do
            begin
                read(a_enf,enf);
                if enf.cod_enf=codenf then
                begin
                    writeln('Enfermedad repetida.');
                    seek(a_enf,0);
                    write('Ingresar codigo de enfermedad correcto: ("*") para salir');
                    readln(codenf);
                    codenf:=validar_string(3,codenf);
                    if codenf='*' then
                    begin
                        writeln('Carga de enfermedades detenida.');
                        seek(a_enf,filesize(a_enf));
                        cargar_sintomas:=FALSE;
                        cargar_enfermedades:=FALSE;
                    end;
                end;
            end;
            if cargar_sintomas then
            begin
                for k:=1 to 6 do
                begin
                    enf.sintomas[k]:='';
                end;
                write('Ingresar nombre de enfermedad: ');
                readln(nomenf);

                write('Ingresar descripcion de enfermedad: ');
                readln(enf.desc_enf);
                {cargar los sintomas para cada enfermedad}
                n_sint:=1;
            end;
            while cargar_sintomas do
            begin
                write('Ingresar codigo de sintoma correspondiente: ');
                readln(codsint);
                codsint:=validar_string(3,codsint);
                seek(a_sint,0);
                buscar_sintoma:=TRUE;
                {buscar el sintoma ingresado}
                repet_o_noenc:=TRUE;
                while buscar_sintoma do
                begin
                    if codsint='*' then
                    begin
                        buscar_sintoma:=FALSE;
                        writeln('Carga de sintomas detenida.');
                    end;
                    read(a_sint,sint);
                    {si encuentra el codigo de sintoma verificar que no este repetido, en ese caso guardarlo y detener la busqueda}
                    if sint.cod_sint=codsint then
                    begin
                        i:=1;
                        repet_o_noenc:=FALSE;
                        while i<n_sint do
                        begin
                            if enf.sintomas[i]=codsint then
                            begin
                                writeln('Sintoma ya ingresado.');
                                repet_o_noenc:=TRUE;
                            end;
                            i:=i+1;
                        end;
                        if (not repet_o_noenc) then
                        begin
                            enf.sintomas[n_sint]:=codsint;
                            n_sint:=n_sint+1;
                            buscar_sintoma:=FALSE;
                        end;
                    end;
                    {si no encuentra el codigo del sintoma, ingresar codigo correcto y reiniciar la busqueda}
                    if (eof(a_sint)) and (repet_o_noenc) then
                    begin
                        write('Ingresar codigo de sintoma correcto: ');
                        readln(codsint);
                        codsint:=validar_string(3,codsint);
                        seek(a_sint,0);
                    end;
                end;
                enf.nom_enf:=nomenf;
                enf.cod_enf:=codenf;
                {solicitar ingreso de sintomas si no se alcanzo el numero maximo permitido}
                if n_sint>6 then
                begin
                    write('Se alcanzo el maximo de sintomas por enfermedad (max 6).');
                    cargar_sintomas:=FALSE;
                end
                else
                begin
                    write('Termino de cargar sintomas?(S/N): ');
                    readln(cs);
                    cs:=validar_SN(cs);
                    if cs='S' then
                        cargar_sintomas:=FALSE
                    else
                        writeln('Quedan ',7-n_sint,' sintomas para cargar: ');
                end;
            end;
            if cargar_enfermedades then
            begin
                {mostrar las enfermedades cargadas con sus sintomas}
                ClrScr;
                write(a_enf,enf);
                seek(a_enf,0);
                listar_enf(m);
                {solicitar el ingreso de mas enfermedades}
                writeln();
                write('Termino de cargar enfermedades?(S/N): ');
                readln(ce);
                ce:=validar_SN(ce);
                if ce='S' then
                    cargar_enfermedades:=FALSE
                else
                begin
                    cargar_enfermedades:=TRUE;
                    ClrScr;
                    m:=0;
                end;
            end;
        end
        else
        begin
            writeln('Carga de enfermedades detenida.');
            seek(a_enf,filesize(a_enf));
            cargar_enfermedades:=FALSE;
        end;

    end;
end;

{------------------------------------------------------------------------------ OPCION 4}
procedure alta_paciente(var docu:string);
var
    p:char;
    q,r,t:integer;
    s,agr_cod,nomprov:string;
begin
    reset(a_pac);
    while bus_dico(a_pac,docu) do
    begin
        write('Dni ya existente, ingrese otro("*" para salir): ');
        readln(docu);
        validar_dni(docu);
    end;
    if docu<>'*' then
    begin
        reset(a_pac);
        if (filesize(a_pac)<>0) then
        begin
            seek(a_pac,filesize(a_pac)-1);
            read(a_pac,pac);
        end;
        pac.dni:=docu;
        write('Nombre del paciente: ');
        readln(s);
        s[1]:=Upcase(s[1]);
        pac.nom_pac:=s;
        {write('Edad del paciente: ');}
        t:=1;
        while t<>0 do
        begin
            write('Ingrese edad: ');
            t:=captura(r);
            if (r<1) or (r>122) then
                t:=1;
        end;
        pac.edad:=r;
        write('Codigos de provincias disponibles: ');
        reset(a_prov);
        writeln();
        while not eof(a_prov) do
        begin
            read(a_prov,prov);
            writeln('Codigo de provincia: ',prov.cod_prov);
        end;
        q:=0;
        while q=0 do
        begin
            write('Ingrese el codigo de provincia del paciente: ');
            readln(p);
            validar_char(p);
            p:=Upcase(p);
            reset(a_prov);
            while (not eof(a_prov)) and (q=0) do
            begin
                read(a_prov,prov);
                if prov.cod_prov=p then
                    q:=1;
            end;
            if (q=0) and (p<>'*') and (p<>'I') and (p<>'O') then
            begin
                writeln('El codigo de provincia no existe, desea agregarlo? (S/N)');
                readln(agr_cod);
                agr_cod:=validar_SN(agr_cod);
                if agr_cod='S' then
                begin
                    writeln('Ingrese nombre provincia: ');
                    readln(nomprov);
                    reset(a_prov);
                    while not eof(a_prov) do
                    begin
                        read(a_prov,prov);
                        if nomprov=prov.nom_prov then
                        begin
                            writeln('Nombre de prov repetido, ingrese otro: ');
                            readln(nomprov);
                            reset(a_prov);
                        end;
                    end;
                    prov.cod_prov:=Upcase(p);
                    prov.nom_prov:=nomprov;
                    write(a_prov,prov);
                    q:=1;
                end;
            end;
        end;
        pac.cod_prov:=p;
        pac.cant_enf:=1;
        write('Fallecio el paciente?(S/N): ');
        readln(pac.fallecido);
        pac.fallecido:=validar_SN(pac.fallecido);
        write(a_pac,pac);
        orden_pac(a_pac);
        reset(a_pac);
    end;
end;
procedure mostrar_pac;
begin
    reset(a_pac);
    if filesize(a_pac)<>0 then
    begin
        gotoxy(71,1);writeln('Lista de pacientes ingresados: ');
        gotoxy(63,3);writeln(' N       DNI     EDAD   PROV  DEF  NOMBRE');
        gotoxy(63,4);writeln('_________________________________________________');
        while not eof(a_pac) do
        begin
            read(a_pac,pac);
            gotoxy(63,filepos(a_pac)+4);writeln(' ',filepos(a_pac),'  | ',pac.dni,' |  ',pac.edad,'  |  ',pac.cod_prov,'  |  ',pac.fallecido,' | ',pac.nom_pac);
        end;
        grilla(62,2,1,1,50,3+filesize(a_pac));
    end
    else
        writeln('No hay pacientes cargados.');
end;
procedure opcion_4;
var docu:string[8];
begin
    mostrar_pac;
    reset(a_prov);
    if filesize(a_prov)<>0 then
    begin
        seek(a_pac,0);
        gotoxy(2,2);
        write('Documento del paciente("*" para salir): ');
        readln(docu);
        validar_dni(docu);
        while docu<>'*' do
        begin   
            alta_paciente(docu);
            ClrScr;
            mostrar_pac;
            gotoxy(2,2);
            write('Documento del paciente("*" para salir): ');
            readln(docu);
            validar_dni(docu);
        end;
    end
    else
        writeln('No hay provincias cargadas, dirijase a la opcion 1 para continuar: ');
end;

procedure mostrar_his;
begin
    reset(a_his);
    if filesize(a_his)<>0 then
    begin
        gotoxy(70,1);writeln('Lista de historias clinicas ingresadas: ');
        gotoxy(63,3);writeln(' N       DNI      ENFE  CURADO  EFECTOR');
        gotoxy(63,4);writeln('____________________________________________');
        while not eof(a_his) do
        begin
            read(a_his,his);
            gotoxy(63,filepos(a_his)+4);writeln(' ',filepos(a_his),'  | ',his.dni,' |  ',his.cod_enf,'  |  ',his.curado,'  |  ',his.efector);
        end;
        grilla(62,2,1,1,45,3+filesize(a_his));
    end
    else
        writeln('No hay historias clinicas cargadas.');
end;
{------------------------------------------------------------------------------ OPCION 5}
procedure opcion_5;
var docu:string[8];
    sintoma,codenf:string[3];
    k,k2:integer;
begin
    ClrScr;
    writeln('OPCION 5: alta de historias clinicas.');
    mostrar_his;
    gotoxy(2,2);
    write('Ingrese dni para historia clinica ("*" para salir): ');
    readln(docu);
    validar_dni(docu);
    while docu<>'*' do
    begin
        {Realizar alta del paciente si no se encuentra en el registro}
        reset(a_pac);
        if (not bus_dico(a_pac,docu)) then
        begin
            writeln('Paciente nuevo... realizando alta');
            alta_paciente(docu);
        end;
        if (filesize(a_his)<>0) then
        begin
            seek(a_his,filesize(a_his)-1);
            read(a_his,his);
        end;
        his.dni:=docu;
        {ingresar enfermedad y validar codigo}
        writeln('Enfermedades disponibles: ');
        reset(a_enf);
        while not eof(a_enf) do
        begin
            read(a_enf,enf);
            write(' - ',enf.cod_enf);
        end;
        writeln();
        write('Ingrese codigo de enfermedad del paciente: ');
        readln(codenf);
        codenf:=validar_string(3,codenf);
        reset(a_enf);
        read(a_enf,enf);
        while codenf<>enf.cod_enf do
        begin
            if not eof(a_enf) then
            begin
                read(a_enf,enf);
            end
            else
            begin
                write('Ingrese codigo correcto: ');
                readln(codenf);
                codenf:=validar_string(3,codenf);
                reset(a_enf);
            end;
        end;
        his.cod_enf:=codenf;
        {mostrar sintomas correspondientes a la enfermedad}
        k:=1;
        writeln('Sintomas de la enfermedad: ');
        while  (k<=6) and (length(enf.sintomas[k])<>0) do
        begin
            if (length(enf.sintomas[k])>0) then     {agregar condicion para que no itere los ''..}
                writeln('  -  ', enf.sintomas[k]);
            k:=k+1;
        end;
        {cargar sintomas validos}
        write('Ingrese sintoma de la enfermedad del paciente: ');
        readln(sintoma);
        sintoma:=validar_string(3,sintoma);
        i:=1;
        j:=1;
        while (sintoma<>'*') and (j<k-1) do
        begin
            while (sintoma<>'*') and (sintoma<>enf.sintomas[i]) do
            begin
                if i=6 then
                begin
                    write('Ingrese sintoma correcto ("*" para salir): ');
                    readln(sintoma);
                    sintoma:=validar_string(3,sintoma);
                    i:=0;
                end;
                i:=i+1;
                if (sintoma=enf.sintomas[i]) and (j>1) then
                begin
                    for k2:=1 to j-1 do
                    begin
                        if his.sin_tomas[k2]=sintoma then
                        begin
                            writeln('Sintoma repetido');
                            sintoma:='***';
                            i:=0;
                        end;
                    end;
                end;
            end;
            if sintoma<>'*' then
            begin
                his.sin_tomas[j]:=sintoma;
                j:=j+1;
                i:=0;
                write('Ingrese sintoma del paciente ("*" para salir): ');
                readln(sintoma);
                sintoma:=validar_string(3,sintoma);
            end;
        end;
        if j=k-1 then
            writeln('No dispone de mas sintomas.');
        write('Se curo el paciente? (S/N): ');
        readln(his.curado);
        his.curado:=validar_SN(his.curado);
        his.fecha_ingreso:=Date;
        write('Ingrese efector: ');
        readln(his.efector);
        his.efector:=Uppercase(his.efector);
        if filesize(a_his)>1 then
            seek(a_his,filesize(a_his));
        write(a_his,his);
        orden_his(a_his);
        ClrScr;
        mostrar_his;
        gotoxy(2,1);
        writeln('OPCION 5: alta de historias clinicas.');
        write('Ingrese dni de historia clinica("*" para salir): ');
        readln(docu);
        validar_dni(docu);
    end;
    ClrScr;
end;

{------------------------------------------------------------------------------ OPCION 6}
procedure enfxsint;
var exs:integer;
begin
    ClrScr;
    gotoxy(1,2);writeln('Cantidad de enfermedades por cada sintoma: ');
    gotoxy(4,5);writeln('SINTOMA - NRO ENF - NOMBRE');
    gotoxy(3,6);writeln('______________________________________');
    reset(a_sint);
    while not eof(a_sint) do
    begin
        read(a_sint,sint);
        reset(a_enf);
        exs:=0;
        while not eof(a_enf) do
        begin
            read(a_enf,enf);
            i:=1;
            while (i<=6) and (enf.sintomas[i]<>'') do
            begin
                if enf.sintomas[i]=sint.cod_sint then
                    exs:=exs+1;
                i:=i+1;
            end;
        end;
        gotoxy(2,filepos(a_sint)+6);writeln('    ',sint.cod_sint,'   |    ',exs,'   |  ',sint.nom_sint);
    end;
    grilla(2,3,1,1,38,filesize(a_sint)+4);
end;

procedure promedio_numero_y_maximo_edad(opcion:integer);
var pac_encontrado,pac_curado:boolean;
    cont_pac,acum_edad,cont_curado,max_edad:integer;
    max_pac:string;
begin
    ClrScr;
    reset(a_enf);
    max_edad:=0;
    while not eof(a_enf) do
    begin
        read(a_enf,enf);
        reset(a_pac);
        cont_pac:=0;
        cont_curado:=0;
        acum_edad:=0;
        while not eof(a_pac) do
        begin
            read(a_pac,pac);
            pac_encontrado:=TRUE;
            pac_curado:=TRUE;
            reset(a_his);
            while (not eof(a_his)) and pac_curado  do
            begin
                read(a_his,his);
                if (his.dni=pac.dni) and (his.cod_enf=enf.cod_enf) and (pac_encontrado) then
                begin
                    acum_edad:=acum_edad+pac.edad;
                    cont_pac:=cont_pac+1;
                    pac_encontrado:=FALSE;
                    if pac.edad>max_edad then
                    begin
                        max_edad:=pac.edad;
                        max_pac:=pac.nom_pac;
                    end;
                end;
                if (his.dni=pac.dni) and (his.cod_enf=enf.cod_enf) and (his.curado='N') then
                    pac_curado:=FALSE;
            end;
            if (not pac_encontrado) and (pac_curado) then
                cont_curado:=cont_curado+1;
        end;
        case opcion of
        1:
            begin
                gotoxy(12,4+filepos(a_enf));
                if cont_pac<>0 then
                    writeln(enf.cod_enf,' : ',round(acum_edad/cont_pac))
                else
                    writeln(enf.cod_enf,' : Ninguno tuvo ',enf.cod_enf);
            end;
        2:
            begin
                gotoxy(6,4+filepos(a_enf));
                if cont_curado<>0 then
                    writeln(enf.cod_enf,' : ',cont_curado )
                else
                    writeln(enf.cod_enf,' : Ninguno');
            end;
        3:
            begin
                gotoxy(2,4);
                if eof(a_enf) then
                    writeln('El paciente de mayor edad es ',max_pac,' con ',max_edad,' anios');
            end;
        end;
    end;
    case opcion of
    1:
        begin
            gotoxy(2,2);writeln('Promedio de edad por enfermedad: ');
            grilla(8,3,1,1,15,filesize(a_enf)+2);
        end;
    2:
        begin
            gotoxy(2,1);writeln('Atendidos y curados por enfermedad: ');
            gotoxy(2,3);writeln(' ATENDIDOS - CURADOS');
            grilla(2,2,1,1,21,filesize(a_enf)+3);
        end;
    3:
        begin
            gotoxy(2,3);writeln('Paciente de mayor edad: ');
            grilla(1,2,1,1,50,3);
        end;
    end;
end;

procedure fall_xenf;
var
    cont:integer;
    enfer:string;
    encontro_enf:boolean;
begin
    ClrScr;
    write('Ingrese la enfermedad para la cual desea saber sus fallecidos: ');
    readln(enfer);
    enfer:=validar_string(3,enfer);
    reset(a_enf);
    encontro_enf:=FALSE;
    while (not eof(a_enf)) and (not encontro_enf) do
    begin
        read(a_enf,enf);
        if enf.cod_enf=enfer then encontro_enf:=TRUE;
        if (eof(a_enf)) and (not encontro_enf) then
        begin
            reset(a_enf);
            write('Ingrese una enfermedad correcta: ');
            readln(enfer);
            enfer:=validar_string(3,enfer);
        end;
    end;
    cont:=0;
    reset(a_his);
    while (not eof(a_his)) do
    begin
        read(a_his,his);
        if enfer=his.cod_enf then
        begin
            reset(a_pac);
            seek(a_pac,busca_dico(a_pac,his.dni));
            read(a_pac,pac);
            if pac.fallecido='S' then
                cont:=cont+1;
        end;
    end;
    writeln('Para la enfermedad ',enfer,' fallecieron ',cont,' personas.');
end;

procedure atendidos_xefector;
var
    cont:integer;
    efect:string;
    encontro_efec:boolean;
begin
    ClrScr;
    write('Ingrese el efector para contar el numero de atendidos : ');
    readln(efect);
    efect:=Uppercase(efect);
    cont:=0;
    reset(a_his);
    encontro_efec:=FALSE;
    while (not eof(a_his)) and (not encontro_efec) do
    begin
        read(a_his,his);
        if efect=his.efector then
        begin
            reset(a_pac);
            seek(a_pac,busca_dico(a_pac,his.dni));
            read(a_pac,pac);
            cont:=cont+1;
            encontro_efec:=TRUE;
        end;
        if eof(a_his) then
        begin
            write('Ese efector no se encuentra en la base de datos, ingresar uno correcto: ');
            reset(a_his);
            readln(efect);
            efect:=Uppercase(efect);
        end
    end;
    writeln('El efector ',efect,' atendio a ',cont,' personas.');
end;

procedure prov_max;
var
    maxprov:string;
    maxnom:string;
    cont,tot:integer;
begin
    tot:=0;
    maxprov:='*';
    reset(a_prov);
    while not eof(a_prov) do
    begin
        cont:=0;
        read(a_prov,prov);
        reset(a_his);
        while not eof(a_his) do
        begin
            read(a_his,his);
            reset(a_pac);
            seek(a_pac,busca_dico(a_pac,his.dni));
            read(a_pac,pac);
            if (pac.cod_prov=prov.cod_prov) then
                cont:=cont+1;
        end;
        if cont>tot then
        begin
            tot:=cont;
            maxprov:=prov.cod_prov;
            maxnom:=prov.nom_prov;
        end;
    end;
    ClrScr;
    gotoxy(2,2);writeln('Provincia con mayor cantidad de pacientes: ');
    gotoxy(2,3);writeln('La provincia que mas pacientes atendio es ',maxnom,' (',maxprov,') con ',tot,' enfermos.');
    grilla(1,1,1,1,70,3);
end;

procedure formxfecha;
var dd,mm,yy:word;
    fecha:TDateTime;
    t:char;
    encontro_fecha:boolean;
begin
    t:='N';
    ClrScr;
    writeln('Busqueda por fecha: ');
    while t<>'S' do
    begin
        fecha:=0;
        while fecha=0 do
        begin
            writeln('Ingresa una fecha (- Dia - Mes - Anio -) Gracias.');
            writeln('Dia: (1-31)');
            readln(dd);
            writeln('Mes: (1-12)');
            readln(mm);
            writeln('Año: (1-9999)');
            readln(yy);
            fecha:=EnCodeDate(yy,mm,dd);
            ClrScr;
        end;
        Writeln('fecha: ',FormatDateTime('DD MM YYYY',fecha));
        reset(a_his);
        encontro_fecha:=FALSE;
        while not eof(a_his) do
        begin
            read(a_his,his);
            if his.fecha_ingreso=fecha then
            begin
                 encontro_fecha:=TRUE;
                 writeln('DNI: ',his.dni);
                 writeln('Nombre enfermedad: ',his.cod_enf);
            end;
        end;
        if (not encontro_fecha) then writeln('No existen pacientes atendidos ese dia');
        writeln('Termino de buscar por fecha? (S/N): ');
        readln(t);
        t:=validar_char(t);
    end;
end;

procedure sub_menu;
begin
    ClrScr;
    gotoxy(69,2);writeln('SUBMENU OPCION 6: ');
    gotoxy(57,4);writeln('  -1-  Conteo de enf por sintoma: ');
    gotoxy(57,5);writeln('  -2-  Promedio de edad por enfermedad: ');
    gotoxy(57,6);writeln('  -3-  Atendidos y curados por enfermedad: ');
    gotoxy(57,7);writeln('  -4-  Paciente de mayor edad: ');
    gotoxy(57,8);writeln('  -5-  Provincia que mas enfermos atendio: ');
    gotoxy(57,9);writeln('  -6-  Busqueda por fecha: ');
    gotoxy(57,10);writeln('  -7-  Fallecidos para enfermedad ingresada: ');
    gotoxy(57,11);writeln('  -8-  Busqueda por efector: ');
    gotoxy(57,12);writeln('  -0-  Volver al menu principal.');
    grilla(56,3,1,1,45,10);
end;

procedure opcion_6;
var op:char;
begin
    writeln('OPCION 6: exhibicion de estadisticas.');
    if filesize(a_his)<>0 then
    begin
        sub_menu;
        gotoxy(2,2);
        writeln('Ingresar opcion de submenu (entre 0 y 8): ');
        readln(op);
        validar_opc(op,'8');
        while op<>'0' do
        begin
            case op of
                '1':
                    begin
                        enfxsint;
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
                '2':
                    begin
                        promedio_numero_y_maximo_edad(1);
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();                        
                    end;
                '3':
                    begin                      
                        promedio_numero_y_maximo_edad(2);
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
                '4':
                    begin
                        promedio_numero_y_maximo_edad(3);
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
                '5':
                    begin                      
                        prov_max;
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
                '6':
                    begin                       
                        formxfecha;
                    end;
                '7':
                    begin                        
                        fall_xenf;
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
                '8':
                    begin                       
                        atendidos_xefector;
                        writeln();
                        writeln('Presione una tecla para volver.');
                        readln();
                    end;
            end;
            if op <>'0' then
            begin
                sub_menu;
                gotoxy(2,2);
                writeln('Ingresar opcion de submenu (entre 0 y 8): ');
                readln(op);
                validar_opc(op,'8');
            end
            else
                writeln('Volviendo al menu principal...');
        end;
    end
    else
        writeln('No hay historias clinicas cargadas, vaya a la opcion 5.');
    readln();
end;

{------------------------------------------------------------------------------- MENU PRINCIPAL}
procedure opcion(opc:char);
begin
    ClrScr;
    case opc of
        '1':
            begin
                textbackground(4);
                ClrScr;
                opcion_1;
            end;
        '2':
            begin
                textbackground(6);
                ClrScr;
                opcion_2;
                
            end;
        '3':
            begin
                textbackground(5);
                ClrScr;
                opcion_3;
                
            end;
        '4':
            begin
                textbackground(11);
                ClrScr;
                opcion_4;
                
            end;
        '5':
            begin
                textbackground(10);
                ClrScr;
                opcion_5;
                
            end;
        '6':
            begin
                textbackground(9);
                ClrScr;
                opcion_6;    
            end;
        '0':
            begin
                term:='S';
                ClrScr;
            end;
    end;
end;

procedure termino_sn(var termin:char);
begin
    writeln('Termino de usar el programa? (S/N)');
    readln(termin);
    termin:=upcase(termin);
    while (termin <> 'S') and (termin <> 'N') do
    begin
        write('Presione N para continuar, S para salir.');
        readln(termin);
        termin:=upcase(termin);
    end;
    if termin ='N' then
    begin
        ClrScr;
        mostrar_menu;
    end
    else
    begin
        textbackground(black);
        ClrScr;
        gotoxy(51,25);
        writeln('Hasta luego.');
        grilla(48,22,1,1,16,5);
        readln();
    end;
end;

{------------------------------------------------------------------------------- PROGRAMA PRINCIPAL}
begin
    inicializar;               
    term:='N';
    mostrar_menu;
    while term <> 'S' do
    begin
        readln(opc);
        validar_opc(opc,'6');
        opcion(opc);
        if opc<>'0' then
            termino_sn(term);
    end;
    cerrar;
end.
