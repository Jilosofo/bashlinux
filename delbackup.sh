#!/bin/bash

# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 10/03/2017
# Versão: 1.0
# Testado e homologado para a versão do Ubuntu
#
#Esse script deleta pasta do mês passado

## exec imprimir todo script
exec 6>&1
exec >> /mnt/DelBackupDiario.log  <<END

END
DataAtual=$(date +"%d%m%Y")

echo "-----------------------------------------"
echo "Data Atual "$DataAtual
cd /mnt/
## Carregar variavel do mês passado 
D=$(date -d 'last month' '+%d%m%Y')
#[[ ! -d $D ]] && echo "Diretório do mês $D não existe"
## Procurar o arquivo do mês passado e remover
find /media/ -name $D -exec rm -drfv {} \;
echo "----------------------------------------"