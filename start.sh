#!/bin/bash

# Autor: Rodrigo Luis Chaves Marques da Silva, Valdemir Oliveira
# Versão: 1.0
# Data de criação 01/11/2023
# Testado e homologado para a versão Ubuntu 23.04 kernel 6.2.0-36-generic
# Script vai capturar imagem HDMI via ffmpeg (Decklink Intensity Pro 4K) criando servidor rtmp nginx

send_message ()
{
    zenity --info --timeout 3 --title="Aviso" --text="aplicacao $1 foi reiniciada - pid: $2"
}    

start_painelD ()
{
	ffmpeg -y -f decklink -video_input hdmi -raw_format argb -i 'Intensity Pro 4K (1)' -video_size 1920x1080 -framerate 30 -c:v h264 -b:v 4000k -pix_fmt yuv420p -ac 2 -ab 96k -ar 48k -c:a aac outputh264.mp4 -flags +global_header -copytb 1 -async 1 -f flv rtmp://localhost/live/painelD &
	pid_painelD=$!
}

start_painelE ()
{
	ffmpeg -y -f decklink -video_input hdmi -raw_format argb -i 'Intensity Pro 4K (2)' -video_size 1920x1080 -framerate 30 -c:v h264 -b:v 4000k -pix_fmt yuv420p -ac 2 -ab 96k -ar 48k -c:a aac outputh264.mp4 -flags +global_header -copytb 1 -async 1 -f flv rtmp://localhost/live/painelE &
	pid_painelE=$!
}

start_console ()
{
	/home/streamcosev/scripts/console.sh $1 &
	pid_console=$!
}

start_vlc ()
{
	sleep 5
	vlc rtmp://localhost/live/painelD &
	vlc rtmp://localhost/live/painelE &
	vlc rtmp://localhost/live/console &
}

sleep 15

start_painelD
start_painelE
start_console
start_vlc


while [  1==1 ]; do
    ITEM_SELECIONADO=$(zenity --title="Gerenciamento" --list --text "Selecione a aplicacao para reiniciar" --radiolist --column "Marcar" --column "Aplicacoes" FALSE PAINELD FALSE PAINELE FALSE CONSOLE FALSE VLC)

    if [[ $ITEM_SELECIONADO == "PAINELD" ]]; then
            kill $pid_painelD
            sleep 1
            start_painelD
            send_message $ITEM_SELECIONADO $pid_painelD
    fi
    if [[ $ITEM_SELECIONADO == "PAINELE" ]]; then
            kill $pid_painelE
            sleep 1
            start_painelE
            send_message $ITEM_SELECIONADO $pid_painelE
    fi
    if [[ $ITEM_SELECIONADO == "CONSOLE" ]]; then
            kill $pid_console
            sleep 1
            start_console
            send_message $ITEM_SELECIONADO $pid_console
    fi
    if [[ $ITEM_SELECIONADO == "VLC" ]]; then
            kill $pid_vlc
	    pkill vlc
            sleep 1
            start_vlc
            send_message $ITEM_SELECIONADO $pid_vlc
    fi
done
