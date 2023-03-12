bashlinux

Recuperar backup usando tar ######
tar -xvf /dev/nst0  bkp/setembro2016/Rede/bd/bd.tar -C /home/infra/scriptLTO/restaurar/
                   /                                              /                                                 \
         dispotivo LTO                           Local do arquivo                         Onde salvar

Para listar os arquivos com multivolume:

tar -t -v -M -f /dev/st0

Para recuperar um arquivo:

tar -x -v -M -f /dev/st0 arquivo_a_ser_recuperado

Com essas informaÃ§Ãµes criei um script em shell para fazer o backup.

BKPDEST="/dev/st0"
BKPORG="/u02/backup"
LOG="/u02/tape.log"

LIMPA BACKUP LOG
echo " " > $LOG

REBOBINA TAPE
echo "REBOBINANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG
mt -f /dev/st0 rewind

APAGANDO TAPE
echo "APAGANDO A FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG
mt -f /dev/st0 erase

COPIANDO ARQUIVOS
echo "COPIANDO ARQUIVOS-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG
tar -cvf $BKPDEST $BKPORG

REBOBINA TAPE
echo "REBOBINANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG
mt -f /dev/st0 rewind

EJETA TAPE
echo "EJETANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG
mt -f /dev/st0 eject
