#!/bin/bash

# İmleci gizle ve bitişte geri getir
trap "tput cnorm; exit" SIGINT SIGTERM
tput civis

options=("Build" "Deploy" "Çıkış")
selected=0

draw_menu() {
    clear
    
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            tput rev
            echo "> ${options[$i]}"
            tput sgr0
        else
            echo "  ${options[$i]}"
        fi
    done
}

build_op() {

    # Renk tanımlamaları (görsellik için)
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    NC='\033[0m' # Renk Yok

    BUILD_DIR="cmake-build-debug"

    echo -e "${BLUE}--- Derleme İşlemi Başlatılıyor ---${NC}"

    # 1. Klasör kontrolü ve oluşturma
    if [ ! -d "$BUILD_DIR" ]; then
        echo -e "${BLUE}[1/3]${NC} $BUILD_DIR klasörü oluşturuluyor..."
        mkdir "$BUILD_DIR"
    fi

    # 2. Klasöre gir
    cd "$BUILD_DIR" || { echo -e "${RED}Hata: Klasöre girilemedi!${NC}"; exit 1; }

    # 3. CMake yapılandırması
    echo -e "${BLUE}[2/3]${NC} CMake yapılandırılıyor..."
    cmake ..
    if [ $? -ne 0 ]; then
        echo -e "${RED}Hata: CMake yapılandırması başarısız!${NC}"
        exit 1
    fi

    # 4. Derleme (Make)
    echo -e "${BLUE}[3/3]${NC} Kod derleniyor (make)..."
    make -j$(nproc) # Tüm çekirdekleri kullanarak hızlı derle
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✔ Derleme başarıyla tamamlandı!${NC}"
    else
        echo -e "${RED}✘ Derleme sırasında hata oluştu!${NC}"
        exit 1
    fi
    
    # 5. Bir üst klasöree geri çık.
    cd ..
}

while true; do
    while true; do
        draw_menu

        # Read Key
        read -rsn3 key
        
        case "$key" in
            $'\e[A') # Up
                ((selected--))
                [ "$selected" -lt 0 ] && selected=$((${#options[@]} - 1))
                ;;
            $'\e[B') # Down
                ((selected++))
                [ "$selected" -ge "${#options[@]}" ] && selected=0
                ;;
            "") # Enter
                break
                ;;
        esac
    done

    tput cnorm # Show cursor
    clear
    
    case $selected in
        0)
            echo "--- Derleme başlatılıyor ---"
	    build_op
            ;;
        1)
            echo "--- Yükleme başlatılıyor ---"
            $HOME/ti/uniflash_8.3.0/dslite.sh -c $HOME/Desktop/Git-Repo/Blinky/TM4C1294NCPDT.ccxml -e -f -v $PWD/cmake-build-debug/Blinky.bin,0x0
            ;;
        2)
            echo "Çıkış yapılıyor..."
            tput cnorm
            exit 0
            ;;
    esac

    echo ""
    echo "Devam etmek için bir tuşa basın..."
    read -n 1 -s # Kullanıcı bir tuşa basana kadar bekler
    tput civis # Menüye dönerken imleci tekrar gizle
done

