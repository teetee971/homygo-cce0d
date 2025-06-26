@echo off
:: Script de push Git automatique avec log
setlocal

set LOG_FILE=push-log.txt
set REPO_DIR=%~dp0

echo [%date% %time%] --- Début du push --- >> "%REPO_DIR%%LOG_FILE%"
cd /d "%REPO_DIR%"
git add . >> "%LOG_FILE%" 2>&1
git commit -m "🌀 Commit automatique via push-auto-launcher" >> "%LOG_FILE%" 2>&1
git push origin main >> "%LOG_FILE%" 2>&1
echo [%date% %time%] --- Fin du push --- >> "%LOG_FILE%"
echo Push terminé. Détails dans push-log.txt

endlocal
pause
