# bashlinux

**Recuperar backup usando tar**

    $tar -xvf /dev/nst0  `bkp/setembro2016/Rede/bd/bd.tar` -C `/home/infra/scriptLTO/restaurar/`
         
**Para listar os arquivos com multivolume:**

    $tar -t -v -M -f /dev/st0

**Para recuperar um arquivo:**

    $tar -x -v -M -f /dev/st0 arquivo_a_ser_recuperado**

**Com essas informações criei um script em shell para fazer o backup.**

BKPDEST="/dev/st0"
BKPORG="/u02/backup"
LOG="/u02/tape.log"

**LIMPA BACKUP LOG**


    $echo " " > $LOG

**REBOBINA TAPE**

echo "REBOBINANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG

    $mt -f /dev/st0 rewind

**APAGANDO TAPE**

echo "APAGANDO A FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG

    $mt -f /dev/st0 erase

**COPIANDO ARQUIVOS**

echo "COPIANDO ARQUIVOS-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG

    $tar -cvf $BKPDEST $BKPORG

**REBOBINA TAPE**

echo "REBOBINANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG

    $mt -f /dev/st0 rewind

**EJETA TAPE**

echo "EJETANDO FITA-`date +%d-%m-%Y`-`date +%H:%M`" >> $LOG

    $mt -f /dev/st0 eject

## Servidor Stream rtmp

**Instalar nginx**

    sudo apt install update
    sudo apt install nginx
    sudo apt install libnginx-mod-rtmp
    sudo apt install ffmpeg # no caso instalei via git

**Decklink ffmpeg via git**
https://github.com/usb171/FFMPEG-DECKLINK-SRT-

    sudo apt-get update -qq && sudo apt-get -y install \
      autoconf \
      automake \
      build-essential \
      cmake \
      git-core \
      libass-dev \
      libfreetype6-dev \
      libtool \
      libvorbis-dev \
      pkg-config \
      texinfo \
      wget \
      zlib1g-dev
    sudo apt-get -y install \
      nasm yasm libx264-dev libx265-dev libnuma-dev libvpx-dev \
      libfdk-aac-dev libmp3lame-dev libopus-dev

**Baixe o código fonte do ffmpeg e siga a baixo**

    cd ~/ffmpeg_sources
    wget https://ffmpeg.org/releases/ffmpeg-4.1.3.tar.bz2
    tar -xvf ffmpeg-*.tar.bz2
    cd ffmpeg-*/
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include -I$HOME/ffmpeg_sources/BMD_SDK/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --extra-libs="-lpthread -lm" \
      --bindir="$HOME/bin" \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree \
      --enable-decklink \
      --enable-libsrt

Observe a adição de --enable-decklink, --enable-libsrt e BlackMagicDesign SDK em --extra-cflags. Existem alterações de API no BMD SDK 11 em diante; portanto, se o ffmpeg não for compilado, compile-o com o BMD SDK 10.11.4.

**Compile e instale.**

    PATH="$HOME/bin:$PATH" make -j `nproc`
    sudo cp ffmpeg ffprobe /usr/local/bin/

**sudo nano /etc/nginx/nginx.conf**

    . . .
    rtmp {
        server {
                listen 1935;
                chunk_size 4096;
                allow publish 127.0.0.1;
                deny publish all;

                application live {
                        live on;
                        record off;
                }
            }
        }

**ufw firewall liberar a porta 1935**

    sudo ufw allow 1935/tcp
    
**Reiniciar o nginx**

    sudo systemctl reload nginx.service


    
