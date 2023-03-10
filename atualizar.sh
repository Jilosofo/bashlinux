#!/bin/bash

# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 10/03/2023
# Data de atualização: 10/03/2023
# Versão: 2.0
# Testado e homologado para a versão do Debian 9.8 stretch
# Kernel >= 4.9.0-8-amd64
# Testado e homologado 
#
#Executa aplicação e cria log


dir_config="/opt/script/config"
log="/var/log/scriptAtualizacao.log"


${dir_config}/configuracao.sh &> $log