#===============================================================================
#
# IMPORTAR LOS DATOS EN R  
#===============================================================================
#
# Se puede realizar de formas diferntes
# 1. Utilizando RStudio : File /Import Dataset/From text (base)
#                         En el caso de que los datos en forato csv
#
#                         File/ Import Dataset/ From Excel
#                         En caso de estar en fomato xlsx
#                         Aparece una ventana de dialogo para dar los parametros
# 
# 2. Utilizando el paquete Rcmdr y RcomdrMisc que activa una interfas de R que
#    trabaja con menus y ventanas con un proceso parecido al anterio
#
#  Los anteriores caso implican que tengamos la base de datos descargada en una
#  carpeta de nuestro PC
#
# 3. Podemos importar la base de datos de un repositorio que maneje API que es 
#    un permiso a traves de un token. En este caso debemos solicitar el token e
#    instalar el paquete RSocrata

#  Por ejemplo
#  Instalacion de paquetes requeridos
install.packages("RSocrata", dependencies = TRUE) 
library(RSocrata)
token <- "zxMsD6eXc0zlEMryRGW87Hwrz"
Colombia <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token)
# Este proceso tarde unos minutos pues  la base es grande

# Para guardar el archivo en mi Pc
# El formarto RDS es menos pesado
saveRDS(Colombia, file = "data/Colombia.RDS")  

# 4. Podemos trabajar con Dataset disponible en los paquetes de R
#   Para ello solo utilizamos la funcion data
data(iris)
data(cars)
#-------------------------------------------------------------------------------
# Si tengo un archivo en mi PC
# puedo utilizar la siguinte funcion para conocer la ruta donde esta  el archivo
# y con Ctrl+C, 
file.choose()
# indica la ruta donde esta el archivo
# en mi caso me dio esta direccion
# "/home/deg/github/dgonxalex.github.io/Colombia.csv"
# Ahora pego la ruta dentro de la funcion read.csv() y le indico que me la copie
# en un objeto
Colombia<- read_csv("~/Descargas/Casos_positivos_de_COVID-19_en_Colombia (1).csv",col_types = cols(Edad = col_integer()))
#===============================================================================  
#
# REVISAR Y ARREGLAR LOS DATOS
#
#===============================================================================
# Despues de vajar la data es necesario revisar que no tenga problemas como:
#   variables con cademas escritas de diferente forma, p.ej.: casa, CASA, Casa
#   esta revision la podemos hacer rapidamente con 
summary(df.ins)
#-------------------------------------------------------------------------------  
summary(iris)
# ------------------------------------------------------------------------------
summary(cars)
--------------------------------------------------------------------------------  
  # permite visualizar los datos en una hoja 
  View(df.ins)  
# ------------------------------------------------------------------------------
View(iris)
# ------------------------------------------------------------------------------
View(cars)
#-------------------------------------------------------------------------------
# podemos visualizar los primeros 6 registros con el nombre de las variables
head(iris)  
# y los ultimos seis registros  
tail(iris)
# ------------------------------------------------------------------------------
# Observemos lo que pasa con la base de datos de Covid-19
table(Colombia$ubicacion)
# casa         Casa         CASA    Fallecido     Hospital Hospital UCI   N/A 
# 6982      2078352            7        56733        20461         3395   7417 


# Observamos que presenta problema de escritura del valor Casa
# para arreglarlo vamos a utilia el paquete stringr que viene incorpodato dentro
# de un paquete llamado tidyverse
install.packages("tidyverse", dependencies = TRUE)
library(tidyverse)
# se deben cargar 8 paquetes para el analisis de datos
# ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
# ✓ tibble  3.0.6     ✓ dplyr   1.0.4
# ✓ tidyr   1.1.2     ✓ stringr 1.4.0
# ✓ readr   1.4.0     ✓ forcats 0.5.0

# Ahora arreglamos el problema de casa
# Primero vamos a unificar todos los valores, todo en minuscula
Colombia$ubicacion=str_to_lower(Colombia$ubicacion)

table(Colombia$ubicacion)
# ahora quitamos el valor n/a y lo convertimos en na
Colombia$ubicacion[Colombia$ubicacion=="n/a"]=NA
table(Colombia$ubicacion)

#------------------------------------------------------------------------------
# Convertimos la edad en numero ( se importa como cadena)
Colombia$edad=as.integer(Colombia$edad)
#-------------------------------------------------------------------------------
# Arreglo de la variable sexo  
table(Colombia$sexo)
# f       F       M 
# 1 1115909 1057437 
Colombia$sexo=str_to_lower(Colombia$sexo)
table(Colombia$sexo)
#------------------------------------------------------------------------------
table(Colombia$estado)
# Fallecido     Grave      leve      Leve      LEVE  moderado  Moderado       N/A 
# 56733      3395      4016   2081323         2         5     20456      741
# debemos arreglar la variable
Colombia$estado=str_to_lower(Colombia$estado)
Colombia$estado[Colombia$estado=="n/a"]=NA
table(Colombia$estado)
#-------------------------------------------------------------------------------
table(Colombia$pais_viajo_1_nom)
# ok
#-------------------------------------------------------------------------------
table(Colombia$recuperado)

# Activo  fallecido  Fallecido        N/A Recuperado 
# 54818        295      56438       6328    2055468 

Colombia$recuperado=str_to_lower(Colombia$recuperado)
Colombia$recuperado[Colombia$recuperado=="n/a"]=NA
table(Colombia$recuperado)
#-------------------------------------------------------------------------------
table(Colombia$tipo_recuperacion)
# ok
#-------------------------------------------------------------------------------
table(Colombia$nom_grupo_)
# ok
#-------------------------------------------------------------------------------
table(Colombia$per_etn_)
# ok
#-------------------------------------------------------------------------------
# YA ESTA LISTA LA BASE !!!!

# este un trabajo que demanda mucho tiempo, pero que es necesario para 
# tener una buena calidad en los datos

# Cuando la base esta bien, podemos continuar con los demas procesos
# Tambien a podemos guardar para una posterior revision
# Guardar el archivo en formato csv
write_csv(df.ins, "data/Colombia.csv")
# 
# Guardar enformato RDS -formato recomendado pues ocupa menos espacio
saveRDS(df.ins, file = "data/Colombia.RDS")
# Leer archivo en formato RDS 
Colombia=readRDS(file = "data/Colombia.RDS")

#  Listo !!!!
# TENEMOS LA BASE DEL COVID.19 ACTUALIZADA Y ARREGLADA
#===============================================================================
# submuestra Cali
Cali=Colombia[Colombia$ciudad_municipio_nom=="CALI",]
#-------------------------------------------------------------------------------
# si queremos sacar la submuestra Nariño ?
# prueba para saber si has entendido....
#-------------------------------------------------------------------------------
# Ahora estas listo para bajar una base de datos, revisarla y guardarla para 
# realizar un análisis estadístico