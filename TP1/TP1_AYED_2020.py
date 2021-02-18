
# Definir Menú
Menu='MENU PRINCIPAL ' \
     '\n 1 – PROVINCIAS ' \
     '\n 2 – SINTOMAS' \
     '\n 3 – ENFERMEDADES' \
     '\n 4 – PACIENTES' \
     '\n 5 – HISTORIAS CLÍNICAS' \
     '\n 6 – ESTADÍSTICAS' \
     '\n 0 – fin del programa'

# Inicializar variables
ing_opc_corr=False
lista_opciones=[str(i) for i in range(0,7)]
negar=['N','n']
aceptar=['S','s']

#--------------------------------------------------------
# Programa para la opcion 1
def OPCION_1(num_prov=23):
    # Inicializar variables
    dic_prov={}
    Contador_s = 0

    # ingresar datos para todas las provincias
    for provincias in range(0,num_prov):
        nom_prov=input('Ingresar nombre de la provincia :')
        cod_prov=input('Ingresar codigo de la provincia (Letra): ')
        dic_prov[nom_prov]='AR-'+cod_prov


        # Contar si la primera letra es S
        Pr_letra_s= (nom_prov[0]=='s' or nom_prov[0]=='S')
        if Pr_letra_s==True:
            Contador_s = Contador_s + 1

    #Mostrar resultados
    print('\nEl numero de provincias que empiezan con s son '+str(Contador_s))

    return dic_prov

#--------------------------------------------------------
# Programa para la opcion 4
def OPCION_4(indice_inicial=0):

    # Ingresar numero de pacientes a dar el alta de datos
    num_pac = int(input('Ingresar numero de pacientes:'))

    # Inicializar variables
    suma_edad=0
    maximo_edad=0
    total_cur=0


    dic_DNI,dic_edad,dic_curado={},{},{}
    dic_pac = {'DNI': dic_DNI,'Edad':dic_edad,'Curado':dic_curado}

    # Cargar datos para todos los pacientes
    for pacientes in range(indice_inicial,num_pac) :
        pac_DNI=input('Ingresar DNI: ')
        pac_curado=input('Se curó el paciente? (S/N): ')
        pac_edad_str=input('Ingresar edad: ')

     # Verificar que los datos son correctos
        es_numero = False
        while es_numero==False :
            try:
                pac_edad_num=int(pac_edad_str)
                es_numero = True
            except:
                print('\nIngresar opcion correcta')
                pac_edad_str = input('Ingresar edad: ')
        while pac_curado not in negar and pac_curado not in aceptar :
            print('\nIngresar opcion correcta')
            pac_curado = input('Se curó el paciente? (S/N): ')


        # Calcular promedio
        suma_edad=suma_edad + pac_edad_num

        # Calcular Edad Maxima
        if pac_edad_num>maximo_edad :
            maximo_edad=pac_edad_num

        # Calcular total de pacientes curados
        if pac_curado in aceptar :
            total_cur +=1


        dic_DNI[pacientes]=pac_DNI
        dic_edad[pacientes]=pac_edad_num
        dic_curado[pacientes]=pac_curado

    # Mostrar resultados
    print('\nEl promedio de edad es ' + str(round(suma_edad/int(num_pac),3)) +' años')
    print('\nEl maximo de edad es ' + str(maximo_edad) +' años')
    print('\nEl numero de pacientes curados son ' + str(total_cur))


    return dic_pac

#--------------------------------------------------------

# Ejecutar programa principal hasta que el usuario decida terminar

while (ing_opc_corr==False or (Termino in negar) ) :

    # Ingresar opcion del menu
    print(Menu)
    Opcion=input('Ingresar Opcion: ')

    if Opcion in lista_opciones :
        ing_opc_corr = True
        if Opcion=='1' :
            # Ejecutar OPCION_1
            prov=OPCION_1()

        elif Opcion=='4' :
            # Ejecutar OPCION_4
            pac=OPCION_4()

        elif Opcion=='0':
            break

        else :
            print('\nEn ejecucion')

        # Definir si el usuario termino de usar el programa
        Termino=input('\nTerminó de usar el programa? (S/N): ')
        while Termino not in negar and Termino not in aceptar :
            print('\nIngresar opcion correcta')
            Termino = input('\nTerminó de usar el programa? (S/N): ')

    else :
        print('\nIngresar opcion correcta\n')
print('\nFin del programa')