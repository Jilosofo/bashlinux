#!/bin/bash

# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 10/03/2017
# Versão: 1.0
# Testado e homologado para a versão do Ubuntu
#
#Script vai acessar diretorio dos servidores e fazer backup em disco no servidor de backup


### Exec vai criar um arquivo de log em tudo que o script executar verboso
exec &> /home/backup/Documentos/compact_apaga-bkp.log <<END

END

PASTA=$(date +"%d%m%Y")


### O script vai entrar na pasta e tudo que acontecer no script
### vai acontecer nesse diretorio
cd /home/backup/Documentos/

##Se a pasta existir OK se não criar pasta
[[ ! -d $PASTA ]] && mkdir $PASTA

### cd na pasta da data criada
cd $PASTA

### Copiar backup do servidor 1
### A variavel 1 logo abaixo 
### A função vai copiar e compactar em tar
function servidor01-copia() {
  [[ ! -d "$1" ]] && mkdir "$1"
  cd "$1"
  smbclient //<servidor01>/"$1"$ -U '<usuario>%<senha>' -Tcqa $1.tar
  cd ..
}

##Copiar backup do servidor 2
### A variavel 2 logo abaixo 
### A função vai copiar e compactar em tar
function servidor02-copia() {
  [[ ! -d "$1" ]] && mkdir "$1"
  cd "$1"
  smbclient //<servidor02>/"$1"$ -U '<usuario>%<senha>' -Tcqa $1.tar
  cd ..
}

##Copiar backup do servidor 3
### A variavel 3 logo abaixo 
### A função vai copiar e compactar em tar
function servidor03-dados-copia() {
  [[ ! -d "$1" ]] && mkdir "$1"
  cd "$1"
  smbclient //<servidor03>/dados$/ -U '<usuario>%<senha>'  -D "$1" -Tcqa $1.tar
  cd ..
}

## Copiar backup do servidor 4
### A variavel 4 logo abaixo 
### A função vai copiar e compactar em tar
function servidor04-producao-copia() {
  [[ ! -d "$1" ]] && mkdir "$1"
  cd "$1"
  smbclient //servidor04.com.br/producao$/ -U '<usuario>%<senha>' -Tcqa $1.tar
  cd ..
}

### Acessar a função servidor4 e copiar a pasta produção do servidor
servidor04-producao-copia producao


### Se a pasta existir Ok se não criar
[[ ! -d RedeSev ]] && mkdir RedeSev
### cd na pasta RedeSev
cd RedeSev

### Acessar a função servidor 1 e copiar as pastas dadoshg, aplicacoes, dados e bd
servidor01-copia dadosHg
servidor01-copia aplicacoes
servidor01-copia dados
servidor01-copia bd

### Sair da pasta RedeSev
cd ..


### Se a pasta existir Ok se não criar
[[ ! -d RedeServidor ]] && mkdir RedeServidor

### cd na pasta RedeServidor
cd RedeServidor

### Acessar a função servidor 2 e copiar a pasta dados
servidor02-copia dados

### Se a pasta existir Ok se não criar
[[ ! -d dados ]] && mkdir dados

### cd na pasta dados
cd dados

### Acessar a função servidor 2 e copiar a pasta dados
servidor02-dados-copia aplicacoes
servidor02-dados-copia configuracaodosambientes
servidor02-dados-copia dadosdebackup
servidor02-dados-copia dadosproducao
servidor02-dados-copia direcao
servidor02-dados-copia documentacao
servidor02-dados-copia implantacaodeversoes
servidor02-dados-copia log
servidor02-dados-copia planejamento
servidor02-dados-copia procedimentos
servidor02-dados-copia publicacoesinternet
servidor02-dados-copia seguranca
servidor02-dados-copia treinamento
servidor02-dados-copia wiki

## Sair da pasta
cd ..

## Sair da pasta
cd ..

#DIRETORIO=/mnt/backupdiario/

cd /home/backup/Documentos

## Compactar em winrar modo default
rar a -m3 $PASTA $PASTA

## Depois de compactado deletar a pasta
rm $PASTA -dfr

sleep 3

## Se a pasta existir Ok se não criar
[[ ! -d $PASTA ]] && mkdir $PASTA

## Copiar o log na nova pasta criada
cp compact_apaga-bkp.log $PASTA

## Mover o backup em winrar para pasta com a data
mv  "$PASTA.rar" $PASTA

## HD2 carregar o espaço do disco
hd2=$(df -h | grep sdb1 | awk {'print $4'} |cut -d "G" -f 1)

## -ge Número maior ou igual a 90(se o espaço for maio ou igual 90) 
if [ $hd2 -ge 90 ]
then
## mount do driver sdb1 foi criado no /media/sdb
mv $PASTA /media/sdb/
else
## mount do driver sdc1 foi criado no /media/sdc ## O driver sdc foi criado no caso do sdb não ter espaço
mv $PASTA /media/sdc/
fi
sleep 4
chown -R <usuario>:<usuario> /media/sdb
sleep 4
chown -R <usuario>:<usuario> /media/sdc