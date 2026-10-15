#!/bin/bash
# Cài Landshot trên Mac bằng một lệnh (trợ lý AI chạy giúp được):
#   curl -fsSL https://cai.landshot.io.vn/mac | BDS_MA=BDS-XXXX-XXXX-XXXX-XXXX bash
# Tải bộ cài đúng bản của mã → giải nén vào ~/.landshot → cài lệnh bds + skill → kích hoạt mã.
set -e
MAY_CHU="https://landshot-ma.hieuwork280300.workers.dev"
MA="${BDS_MA:-}"
if [ -z "$MA" ] && [ -r /dev/tty ]; then read -r -p "Nhap ma kich hoat Landshot (BDS-XXXX-XXXX-XXXX-XXXX): " MA < /dev/tty; fi
MA=$(printf '%s' "$MA" | tr '[:lower:]' '[:upper:]' | tr -d ' \r\n')
[ -n "$MA" ] || { echo "!! Thieu ma kich hoat. Chay lai kem BDS_MA=<ma>."; exit 1; }
GOC="$HOME/.landshot"; TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
echo "[1/3] Tai bo cai..."
curl -fSL --retry 3 "$MAY_CHU/tai?ma=$MA" -o "$TMP/landshot.zip" || { echo "!! Ma khong dung, da bi khoa, hoac mat mang. Kiem lai ma trong email mua hang."; exit 1; }
echo "[2/3] Giai nen vao $GOC ..."
mkdir -p "$GOC"; rm -rf "$GOC/landshot"; unzip -q "$TMP/landshot.zip" -d "$GOC"
echo "[3/3] Cai dat (lan dau 10-30 phut: tai Chromium, giong doc, model chep loi)..."
BDS_MA="$MA" bash "$GOC/landshot/cai_dat/cai_mac.sh"
echo
echo "Landshot da cai xong. Mo cuoc tro chuyen MOI voi tro ly AI de no thay 4 skill bds-*."
