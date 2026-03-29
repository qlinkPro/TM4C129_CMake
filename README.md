# TM4C129_CMake Example

## Deploy

Deploy işlemi için proje kök dizininde şu komutu çalıştır:

```bash
./utils/deploy.sh
```

Script şu dosyaları kullanır:

- ELF/BIN çıktısı: `cmake-build-debug/Blinky.bin`
- Board config: `board/TM4C1294NCPDT.ccxml`
- UniFlash aracı: `$HOME/ti/uniflash_8.3.0/dslite.sh`

Not: Önce projeyi derleyip `cmake-build-debug/Blinky.bin` dosyasını üretmiş olmalısın.

## Debug (Embedded GDB Server)

CLion içinde **Embedded GDB Server** konfigürasyonu aç ve aşağıdaki alanları doldur:

1. **Run/Debug Configuration tipi**: `Embedded GDB Server`
2. **Executable binary**: derlenen `.elf` dosyası  
   Örnek: `cmake-build-debug/Blinky.elf`
3. **Debugger**: `arm-none-eabi-gdb`
4. **Target remote args**: `localhost:3333`
5. **GDB Server**: `/usr/bin/openocd`
6. **GDB Server args**:

```bash
-s /usr/share/openocd/scripts -f board/openocd_tm4c1294.cfg
```

Bu argümanların anlamı:

- `-s /usr/share/openocd/scripts`: OpenOCD’nin standart script dizinini tanımlar.
- `-f board/openocd_tm4c1294.cfg`: Bu projedeki hedef/arayüz ayar dosyasını yükler.

OpenOCD varsayılan olarak GDB portu `3333` kullanır; bu yüzden `localhost:3333` ile eşleşir.
