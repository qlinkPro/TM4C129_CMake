#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/cmake-build-debug"
BIN_FILE="${BUILD_DIR}/Blinky.bin"
CCXML_FILE="${PROJECT_ROOT}/board/TM4C1294NCPDT.ccxml"
DSLITE="${HOME}/ti/uniflash_8.3.0/dslite.sh"

if [[ ! -x "${DSLITE}" ]]; then
    echo "Hata: dslite bulunamadi veya calistirilabilir degil: ${DSLITE}" >&2
    exit 1
fi

if [[ ! -f "${BIN_FILE}" ]]; then
    echo "Hata: bin dosyasi bulunamadi: ${BIN_FILE}" >&2
    exit 1
fi

if [[ ! -f "${CCXML_FILE}" ]]; then
    echo "Hata: ccxml dosyasi bulunamadi: ${CCXML_FILE}" >&2
    exit 1
fi

"${DSLITE}" -c "${CCXML_FILE}" -e -f -v "${BIN_FILE},0x0"
