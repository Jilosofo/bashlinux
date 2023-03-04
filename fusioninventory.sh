#!/bin/bash
# Autor: Rodrigo Luis Chaves Marques da Silva
# Data de criação: 04/03/2023
# Data de atualizaÃ§Ã£o: 04/03/2023
# Versão: 0.01
# Testado e homologado para a versão do Ubuntu 20.04.x LTS x64
# Kernel >= 5.4.0-x
# Testado e homologado para a versão do FusionInventory Server 9.5.x, Agent 2.5.x, GLPI 9.5.x
#
# O FusionInventory Agent é um agente multiplataforma genériico. Ele pode executar uma grande variedade de
# tarefas de gerenciamento, como inventÃ¡rio local, implantaÃ§Ã£o de software ou descoberta de rede. Ele pode
# ser usado autônomo ou em combinação com um servidor compatível (OCS Inventory, GLPI, OTRS, Uranos, etc..)
# atuando como um ponto de controle centralizado.
#
# Informações que serão solicitadas na configuração via Web do FusionInventory no GLPI
# Configurar
#   Plug-ins
#       FusionInventory: Instalar
#       FusionInventory: Habilitar
#
# Software utilizados pelo FusionInventory:
# fusioninventory-agent: Agente de InventÃ¡rio e Tarefas Local do FusionInventory
# fusioninventory-inventory: InventÃ¡rio AutÃ´nomo do FusionInventory, utilizado nas tarefas do GLPI
# fusioninventory-remoteinventory: Ferramenta de InventÃ¡rio Remoto do FusionInventory
# fusioninventory-netdiscovery: Descoberta de Rede AutÃ´nomo do FusionInventory, utilizado nas tarefas do GLPI
# fusioninventory-netinventory: InventÃ¡rio de Rede AutÃ´nomo do FusionInventory, utilizado nas tarefas do GLPI
# fusioninventory-wakeonlan: Wake-on-LAN de Computadores FusionInventory, utilizado nas tarefas do GLPI
# fusioninventory-injector: Ferramenta de Envio de InventÃ¡rio Remoto do FusionInventory
#
# Site Oficial do Projeto: http://fusioninventory.org/
#
# VÃ­deo de instalaÃ§Ã£o do GNU/Linux Ubuntu Server 18.04.x LTS: https://www.youtube.com/watch?v=zDdCrqNhIXI
# VÃ­deo de instalaÃ§Ã£o do LAMP Server: https://www.youtube.com/watch?v=6EFUu-I3u4s&t
# VÃ­deo de instalaÃ§Ã£o do GLPI Help Desk: https://www.youtube.com/watch?v=6T9dMwJMeDw&t
#
# VariÃ¡vel da Data Inicial para calcular o tempo de execuÃ§Ã£o do script (VARIÃVEL MELHORADA)
# opÃ§Ã£o do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# VariÃ¡veis para validar o ambiente, verificando se o usuÃ¡rio e "root", versÃ£o do ubuntu e kernel
# opÃ§Ãµes do comando id: -u (user)
# opÃ§Ãµes do comando: lsb_release: -r (release), -s (short),
# opÃµes do comando uname: -r (kernel release)
# opÃ§Ãµes do comando cut: -d (delimiter), -f (fields)
# opÃ§Ã£o do shell script: piper | = Conecta a saÃ­da padrÃ£o com a entrada padrÃ£o de outro comando
# opÃ§Ã£o do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opÃ§Ã£o do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere Ã© especial)
# opÃ§Ã£o do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)
#
# VariÃ¡vel do caminho do Log dos Script utilizado nesse curso (VARIÃVEL MELHORADA)
# opÃ§Ãµes do comando cut: -d (delimiter), -f (fields)
# $0 (variÃ¡vel de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Declarando as variÃ¡veis de download do FusionInventory (Links atualizados no dia 14/08/2020)
# OBSERVAÃÃO: O FusionInventory depende do GLPI para funcionar corretamente, recomendo sempre manter o GLPI
# Ã© o FusionInventory atualizados para as Ãºltimas versÃµes.
FUSIONSERVER="https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.5.0%2B1.0/fusioninventory-9.5.0+1.0.tar.bz2"
FUSIONAGENT="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent_2.5.2-1_all.deb"
FUSIONCOLLECT="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-collect_2.5.2-1_all.deb"
FUSIONNETWORK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-network_2.5.2-1_all.deb"
FUSIONDEPLOY="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-deploy_2.5.2-1_all.deb"
AGENTWINDOWS32="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent_windows-x86_2.5.2.exe"
AGENTWINDOWS64="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent_windows-x64_2.5.2.exe"
AGENTMACOS="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/FusionInventory-Agent-2.5.2-1.dmg"
#
# LocalizaÃ§Ã£o padrÃ£o do diretÃ³rio de instalaÃ§Ã£o do GLPI Help Desk utilizado no script glpi.sh
GLPI="/var/www/html/glpi"
#
# Exportando o recurso de Noninteractive do Debconf para nÃ£o solicitar telas de configuraÃ§Ã£o
export DEBIAN_FRONTEND="noninteractive"
#
# Verificando se o usuÃ¡rio Ã© Root, DistribuiÃ§Ã£o Ã© >=18.04 e o Kernel Ã© >=4.15 <IF MELHORADO)
# [ ] = teste de expressÃ£o, && = operador lÃ³gico AND, == comparaÃ§Ã£o de string, exit 1 = A maioria dos erros comuns na execuÃ§Ã£o
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "18.04" ] && [ "$KERNEL" == "4.15" ]
then
echo -e "O usuÃ¡rio Ã© Root, continuando com o script..."
echo -e "DistribuiÃ§Ã£o Ã© >= 18.04.x, continuando com o script..."
echo -e "Kernel Ã© >= 4.15, continuando com o script..."
sleep 5
else
echo -e "UsuÃ¡rio nÃ£o Ã© Root ($USUARIO) ou DistribuiÃ§Ã£o nÃ£o Ã© >=18.04.x ($UBUNTU) ou Kernel nÃ£o Ã© >=4.15 ($KERNEL)"
echo -e "Caso vocÃª nÃ£o tenha executado o script com o comando: sudo -i"
echo -e "Execute novamente o script para verificar o ambiente."
exit 1
fi
#
# Verificando se as dependÃªncias do FusionInventory estÃ£o instaladas
# opÃ§Ã£o do dpkg: -s (status), opÃ§Ã£o do echo: -e (interpretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lÃ³gico OU), 2> (redirecionar de saÃ­da de erro STDERR), && = operador lÃ³gico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressÃ£o, retornando 0 ou 1, -ne = Ã© diferente (NotEqual)
echo -n "Verificando as dependÃªncias do FusionInventory, aguarde... "
for name in mysql-server mysql-common apache2 php
do
  [[ $(dpkg -s $name 2> /dev/null) ]] || {
              echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";
              deps=1;
              }
done
[[ $deps -ne 1 ]] && echo "DependÃªncias.: OK" || {
            echo -en "\nInstale as dependÃªncias acima e execute novamente este script\n";
            echo -en "Recomendo utilizar o script: lamp.sh para resolver as dependÃªncias."
            exit 1;
            }
sleep 5
#
# Verificando se o GLPI Help Desk estÃ¡ instaladas
# opÃ§Ã£o do comando: echo: -e (interpretador de escapes de barra invertida)
# opÃ§Ã£o do comando if: [ ] = testa uma expressÃ£o, -e = testa se Ã© diretÃ³rio existe
echo -e "Verificando se o GLPI Help Desk estÃ¡ instalado, aguarde...\n"
if [ -e "$GLPI" ]
then
    echo -e "O GLPI Help Desk estÃ¡ instalado, continuando com o script...\n"
sleep 5
else
    echo "O GLPI Help Desk nÃ£o estÃ¡ instalado, instale o GLPI com o script: glpi.sh"
echo "Depois da instalaÃ§Ã£o e configuraÃ§Ã£o, execute novamente esse script."
exit 1
sleep 5
fi
#
# Script de instalaÃ§Ã£o do FusionInventory no GNU/Linux Ubuntu Server 18.04.x
# opÃ§Ã£o do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opÃ§Ã£o do comando hostname: -I (all IP address)
# opÃ§Ã£o do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opÃ§Ã£o do comando cut: -d (delimiter), -f (fields)
echo -e "InÃ­cio do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear
#
echo -e "InstalaÃ§Ã£o do FusionInventory no GNU/Linux Ubuntu Server 18.04.x\n"
echo -e "ApÃ³s a instalaÃ§Ã£o do FusionInventory acesse a URL: http://`hostname -I | cut -d' ' -f1`/glpi\n"
echo -e "As configuraÃ§Ãµes do FusionInventory e feita dentro do GLPI Help Desk\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5
#
echo -e "Adicionando o RepositÃ³rio Universal do Apt, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
add-apt-repository universe &>> $LOG
echo -e "RepositÃ³rio adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Adicionando o RepositÃ³rio MultiversÃ£o do Apt, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
add-apt-repository multiverse &>> $LOG
echo -e "RepositÃ³rio adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando as listas do Apt, aguarde..."
#opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Atualizando o sistema, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando apt: -y (yes)
apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Removendo software desnecessÃ¡rios, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando apt: -y (yes)
apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o FusionInventory Server e Agent, aguarde...\n"
#
echo -e "Fazendo o download do FusionInventory Server do site Oficial, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando rm: -v (verbose)
# opÃ§Ã£o do comando wget: -O (output document file)
rm -v fusion.tar.bz2 &>> $LOG
wget $FUSIONSERVER -O fusion.tar.bz2 &>> $LOG
echo -e "Download do FusionInventory Server feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Descompactando o FusionInventory Server, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando tar: -j (bzip2), -x (extract), -v (verbose), -f (file)
tar -jxvf fusion.tar.bz2 &>> $LOG
echo -e "FusionInventory Server descompactado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Movendo o diretÃ³rio do FusionInventory Server para o GLPI Help Desk, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando mv: -v (verbose)
mv -v fusioninventory/ $GLPI/plugins/ &>> $LOG
echo -e "DiretÃ³rio do FusionInventory Server movido com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando as DependÃªncias do FusionInventory Server e Agent, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando apt: -y (yes)
# dependÃªncias do FusionInventory Agent
apt -y install dmidecode hwdata ucf hdparm perl libuniversal-require-perl libwww-perl libparse-edid-perl \
libproc-daemon-perl libfile-which-perl libhttp-daemon-perl libxml-treepp-perl libyaml-perl libnet-cups-perl \
libnet-ip-perl libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl libxml-xpath-perl \
libyaml-tiny-perl libio-socket-ssl-perl libnet-ssleay-perl libcrypt-ssleay-perl &>> $LOG
# dependÃªncias do FusionInventory Task Network
apt -y install libnet-snmp-perl libcrypt-des-perl libnet-nbname-perl &>> $LOG
# dependÃªncias do FusionInventory Task Deploy
apt -y install libfile-copy-recursive-perl libparallel-forkmanager-perl &>> $LOG
# dependÃªncias do FusionInventory Task WakeOnLan
apt -y install libwrite-net-perl &>> $LOG
    # dependÃªncias do FusionInventory SNMPv3
apt -y install libdigest-hmac-perl &>> $LOG
echo -e "DependÃªncias instaladas com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Fazendo o download do FusionInventory Agent do site Oficial, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando rm: -v (verbose)
# opÃ§Ã£o do comando wget: -O (output document file)
rm -v agent.deb task.deb deploy.deb snmp.deb &>> $LOG
wget $FUSIONAGENT -O agent.deb &>> $LOG
wget $FUSIONCOLLECT -O task.deb &>> $LOG
wget $FUSIONDEPLOY -O deploy.deb &>> $LOG
wget $FUSIONNETWORK -O network.deb &>> $LOG
echo -e "Download do FusionInventory Agent feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Instalando o FusionInventory Agent, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando dpkg: -i (install)
dpkg -i agent.deb &>> $LOG
dpkg -i task.deb &>> $LOG
dpkg -i deploy.deb &>> $LOG
dpkg -i network.deb &>> $LOG
echo -e "FusionInventory Agent instalado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Configurando o FusionInventory Agent, pressione <Enter> para continuar."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
    # opÃ§Ã£o do comando mkdir: -v (verbose)
# opÃ§Ã£o do comando cp: -v (verbose)
read
sleep 3
    mkdir -v /var/log/fusioninventory-agent/ &>> $LOG
    touch /var/log/fusioninventory-agent/fusioninventory.log &>> $LOG
cp -v /etc/fusioninventory/agent.cfg /etc/fusioninventory/agent.cfg.bkp &>> $LOG
cp -v conf/agent.cfg /etc/fusioninventory/agent.cfg &>> $LOG
vim /etc/fusioninventory/agent.cfg
echo -e "FusionInventory Agent configurado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Iniciando o serviÃ§o do FusionInventory Agent, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
systemctl enable fusioninventory-agent &>> $LOG
systemctl start fusioninventory-agent &>> $LOG
echo -e "ServiÃ§o do FusionInventory Agent iniciado com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Executando o InventÃ¡rio do FusionInventory Agent, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
fusioninventory-agent --debug &>> $LOG
echo -e "InventÃ¡rio do FusionInventory Agent feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "Criando o repositÃ³rio local e fazendo o download dos Agentes do FusionInventory, aguarde..."
# opÃ§Ã£o do comando: &>> (redirecionar a saÃ­da padrÃ£o)
# opÃ§Ã£o do comando mkdir: -v (verbose)
# opÃ§Ã£o do comando chown: -v (verbose)
# opÃ§Ã£o do comando chmod: -v (verbose)
# opÃ§Ã£o do comando cp: -v (verbose)
# opÃ§Ã£o do comando wget: -O (output document file)
mkdir -v /var/www/html/agentes &>> $LOG
chown -v www-data.www-data /var/www/html/agentes &>> $LOG
chmod -v 755 /var/www/html/agentes &>> $LOG
cp -v conf/agent.cfg /var/www/html/agentes &>> $LOG
wget $AGENTWINDOWS32 -O /var/www/html/agentes/agent_windows32.exe &>> $LOG
wget $AGENTWINDOWS64 -O /var/www/html/agentes/agent_windows64.exe &>> $LOG
wget $AGENTMACOS -O /var/www/html/agentes/agent_macos.dmg &>> $LOG
echo -e "Download dos FusionInventory Agent feito com sucesso!!!, continuando com o script..."
sleep 5
echo
#
echo -e "InstalaÃ§Ã£o do FusionInventory feita com Sucesso!!!."
# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
# opÃ§Ã£o do comando date: +%T (Time)
HORAFINAL=$(date +%T)
# opÃ§Ã£o do comando date: -u (utc), -d (date), +%s (second since 1970)
HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
# opÃ§Ã£o do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second),
TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
# $0 (variÃ¡vel de ambiente do nome do comando)
echo -e "Tempo gasto para execuÃ§Ã£o do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opÃ§Ã£o do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
exit 1
