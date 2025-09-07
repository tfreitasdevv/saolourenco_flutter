@echo off
echo 🚀 Iniciando deploy da aplicação web...
echo.

echo 📦 Fazendo build da aplicação...
flutter build web --release

echo.
echo 🌐 Fazendo deploy para Firebase Hosting...
firebase deploy --only hosting

echo.
echo ✅ Deploy concluído!
echo 🌐 Aplicação disponível em: https://sao-lourenco.web.app
pause
