# Cai Landshot tren Windows bang mot lenh (tro ly AI chay giup duoc). Trong PowerShell:
#   $env:BDS_MA="BDS-XXXX-XXXX-XXXX-XXXX"; irm https://landshot.io.vn/cai.ps1 | iex
# Tai bo cai dung ban cua ma -> giai nen vao %USERPROFILE%\.landshot -> cai lenh bds + skill -> kich hoat ma.
function Cai-Landshot {
  $ErrorActionPreference = "Continue"
  $ProgressPreference = "SilentlyContinue"                       # thanh tien trinh cua PowerShell 5.1 lam tai cham hang chuc lan
  try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}
  $MayChu = "https://landshot-ma.hieuwork280300.workers.dev"
  $Ma = $env:BDS_MA
  if (-not $Ma) { $Ma = Read-Host "Nhap ma kich hoat Landshot (BDS-XXXX-XXXX-XXXX-XXXX)" }
  $Ma = ("" + $Ma).Trim().ToUpper()
  if (-not $Ma) { Write-Host "!! Thieu ma kich hoat."; return }
  $Goc = Join-Path $env:USERPROFILE ".landshot"
  $Zip = Join-Path $env:TEMP "landshot-cai.zip"
  Write-Host "[1/3] Tai bo cai..."
  try { Invoke-WebRequest -Uri "$MayChu/tai?ma=$Ma" -OutFile $Zip -UseBasicParsing }
  catch { Write-Host "!! Ma khong dung, da bi khoa, hoac mat mang. Kiem lai ma trong email mua hang."; return }
  Write-Host "[2/3] Giai nen vao $Goc ..."
  New-Item -ItemType Directory -Force -Path $Goc | Out-Null
  if (Test-Path "$Goc\landshot") { Remove-Item -Recurse -Force "$Goc\landshot" }
  Expand-Archive -Path $Zip -DestinationPath $Goc -Force
  Remove-Item $Zip -Force -ErrorAction SilentlyContinue
  Write-Host "[3/3] Cai dat (lan dau 10-30 phut: tai Chromium, giong doc, model chep loi)..."
  $env:BDS_MA = $Ma
  powershell -NoProfile -ExecutionPolicy Bypass -File "$Goc\landshot\cai_dat\cai_windows.ps1"
  Write-Host ""
  Write-Host "Landshot da cai xong. Dong cua so nay, mo cuoc tro chuyen MOI voi tro ly AI de no thay 4 skill bds-*."
}
Cai-Landshot
