#!/bin/bash

# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 02/03/2020
# Data de atualização: 10/03/2023
# Versão: 2.0
# Testado e homologado para a versão do Debian 9.8 stretch
# Kernel >= 4.9.0-8-amd64
# Testado e homologado 
#
# Esse script vai inserir todas informações de configurações 





dir_config="/opt/script/config"


cat << EOF > "${dir_config}/configuracao.sh"
#!/bin/bash
# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 04/03/2023
# Data de atualização: 10/03/2023
# Versão: 2.0
# Testado e homologado para a versão do Debian 9.8 stretch
# Kernel >= 4.9.0-8-amd64
# Testado e homologado 
#
# Esse script faz consulta a cada 1 min
# Caso tenha alguma versão mais nova o script atualiza por scripts faz download e executa
cd /opt/script/config/
export PATH=\$PATH:/bin:/usr/bin:/sbin:.
ARQUIVO_BUILD=build_num.info
ARQUIVO_CHECKSUM=md5sum.txt
ARQUIVO_BUILD_LOCAL=/opt/config/\$ARQUIVO_BUILD
URL_DISTRIBUICAO=http://<servidor>
CHECKSUMSERVIDOR=sumservidor.md5
ATUALIZACAO_DIR=/opt/script/atualizacao
WWW_DIR=/var/www/
HOME_<user>=/home/<user>
DATA=\$(date '+%d/%m/%Y %T')
NOME=\$(hostname -f)
IP=\$(ip addr show enp0s3 | grep enp0s3 | awk '{print\$2}')
SERVIDOR_IP=\$(getent hosts <servidor> | awk '{ print \$1 }')
######Se o login estiver ok e o checksum, poderei efetuar download
baixarArquivo () {
    if [ -n "\$1" ] ; then
        echo "####################################################################################"
        echo "Carregando arquivo \$1"
        wget -c -P \$WWW_DIR --no-proxy --no-cache -4 \$URL_DISTRIBUICAO/\$1
    fi
}
#Procedure do servidor ############
inserirChecksum () {
  echo " " > md5sumservidor.txt
  for ARQUIVO in \`ls \$LIVE_DIR\`
  do
    #echo \$ARQUIVO
    md5sum \$LIVE_DIR\$ARQUIVO >> md5sumservidor.txt
  done
}
###################################
lerArquivo () {
rm \$ATUALIZACAO_DIR/build_num.info
rm \$ATUALIZACAO_DIR/*.sh
for line in \$(cat arquivoserv.txt);
do
baixarArquivo "\$line" ;
done
echo "Ler aquivo proxima estapa verificarIntegridade!!!"
verificarIntegridade
}
#####Verificar checksum está OK
verificarIntegridade (){
check=\$(md5sum -c  \$CHECKSUMSERVIDOR | grep FALHOU | awk '{print\$2}')
if [ -z "\$check" ]; then
    check="ok"
fi
echo "\$check"
if [ \$check == "FALHOU" ]; then > /dev/null
   echo "FAIL"
   echo "Integridade falhou"
else
   echo "Integridade Ok"
   move
fi
}
md5servidor (){
   scp -o StrictHostKeyChecking=no <user>@s<servidor>:/home/<user>/sumservidor.md5 .
   scp -o StrictHostKeyChecking=no <user>@<servidor>:/home/<user>/arquivoserv.txt .
   echo "Download do arquivo md5servidor via SCP proxima etapa limpaArquivo"
   limpaArquivo
   }
############Se a versão build mudar verificar logar e baixar os aquivos checksum e hash
move () {
for line in \$(cat arquivoserv.txt);
do
   mv \$WWW_DIR\$line \$ATUALIZACAO_DIR;
done
echo "Mover arquivo para atualizacao proximo arquivo execArquivo"
mv ../config/build_num.info ../atualizacao/versao-anterior/build_num.info
execArquivo
}
build () {
/bin/ping -w 1 -c 1 seleg.camara.gov.br
if [ \$? -eq 0 ];
then
rm build_num.info
wget --no-proxy --no-cache -4 \$URL_DISTRIBUICAO/build_num.info
build_local=\$(cat ../config/build_num.info)
build_num=\$(cat ../atualizacao/versao-anterior/build_num.info)
##echo "Builds \$build_local \$build_num"
if [ \$build_num == \$build_local ];
then
echo "Build OK"  
#echo "ok"
else
echo "Build: proxima estapa md5sum"
md5servidor
fi ##IFELSE do build comparação
else ##Else ping
  echo "Erro na buid"
fi ##IFelse do PING
}
execArquivo () {
rm \$ATUALIZACAO_DIR/versao-anterior/*.sh
cp -r \$ATUALIZACAO_DIR/*.sh \$ATUALIZACAO_DIR/versao-anterior/
rm \$ATUALIZACAO_DIR/build_num.info
for line in \$(cat arquivoserv.txt);
do
echo "Arquivo exec \$line"
bash \$ATUALIZACAO_DIR/\$line;
done
echo "Execução dos arquivos depois do reboot"
#####reboot ## reiniciar
}
limpaArquivo () {
for line in \$(cat arquivoserv.txt);
do
rm \$WWW_DIR\$line;
done
echo "Limpar arquivo OK, proxima etapa lerArquivo!!!"
lerArquivo
}
########Verificar o Ip do sistema e enviar para servidor
if [ -f \$HOME_<user>/Downloads/touch ]
then
echo "Touch existe" 
build
else
echo "\$DATA touch nÃ£o existe" &>> /var/log/touch.log
/usr/bin/touch \$HOME_<user>/Downloads/touch
/bin/chown <user>:<user> \$HOME_<user>/Downloads/touch
echo "Data \$DATA IP \$IP hostname \$NOME" | ssh -o StrictHostKeyChecking=no  <user>@\$SERVIDOR_IP "cat - >> ips.txt"
fi
EOF

chmod +x ${dir_config}/configuracao.sh

cat << EOF > "${dir_config}/atualizar.sh"
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
\${dir_config}/configuracao.sh &> \$log
EOF