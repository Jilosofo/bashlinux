#!/bin/bash
exec 6>&1
exec >> /home/mensal/bkpdiario.log <<END

END

data=$(date +"%A")
#lerBD=$(tar -tvf /mnt/backupdiario/$data/RedeSev/bd/bd.tar | awk '/b([a-z]+)/{print$6}' | cut -d'/' -f 2)
#lerBD=$(tar -tvf /mnt/backupdiario/terça/RedeSev/bd/bd.tar | awk '/b([a-z]+)/{print$6}' | cut -d'/' -f 2)
lerBD=$(tar -tvf /mnt/backupdiario/bd.tar | awk '/b([a-z]+)/{print$6}' | cut -d'/' -f 2)
dirBKP=/bkp/
devLTO=/dev/nst0

echo $lerBD
#sleep 2

function verificaTape(){
tape="0"
    while [ $tape -lt 1 ]
    do
       ## Verificar o status da LTO
       sudo mt -f /dev/nst0 status
     
        ## Variavel tp executar comando de ir pra frente 
        ## Mover até o final da fita para depois gravar
        ## Se ele receber o falhar ele para de serguir frente até a ultima gravação 
        ## E agora ele vai voltar 1 count e preparar para gravar a LTO
        ## Ele sai do while
     
      tp=$(sudo mt -f  /dev/nst0 fsfm 2 2>&1 | awk '{print $4}' | cut -d ':' -f 1)
     
        if [ "$tp" = "falhou" ]; then
            tape=1
            echo "Final Tape"
        fi
     
       i=$[$i+1]
       echo "File Number: $i"$i
   
    done ##while

    vtp=$(sudo mt -f  /dev/nst0 status | awk /block/ | cut -d '=' -f 2)
        if [ "$vtp" = " -1" ]; then
        sudo mt -f /dev/nst0 bsfm 1 ## voltou 1 count
        fi
}



function gravarMensal() {

    sudo mt -f /dev/nst0 status
    sudo tar -c -v -f $devLTO $dirBKP
    sleep 3   
    sudo mt -f /dev/nst0 eject
        }


function verificarBKPMensal()
{
        if ["$lerBD" = ""]; then
        (dialog --backtitle "" \
                     --infobox 'BackupMensal não encontrado.' 3 70; sleep 3)

        else
        (dialog --backtitle "" \
                     --infobox 'BackupMensal Encontrado.' 3 70; sleep 3)

                ( dialog --title "Leitura do banco" \
                --infobox ' '$lerBD 3 70; sleep 5)
                        verificaTape
			sleep 3 
                        gravarMensal


        fi
}

verificarBKPMensal $lerBD