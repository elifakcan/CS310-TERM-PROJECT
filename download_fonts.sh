#!/bin/bash

# Font indirme ve kurulum scripti
# Bu script Google Fonts'tan font dosyalarını indirir

echo "📥 Font dosyaları indiriliyor..."

# Assets klasörlerini oluştur
mkdir -p assets/fonts
mkdir -p assets/images

# Pacifico font indir
echo "📥 Pacifico font indiriliyor..."
curl -L "https://github.com/google/fonts/raw/main/ofl/pacifico/Pacifico-Regular.ttf" -o assets/fonts/Pacifico-Regular.ttf

# Montserrat font indir
echo "📥 Montserrat font indiriliyor..."
curl -L "https://github.com/google/fonts/raw/main/ofl/montserrat/static/Montserrat-Regular.ttf" -o assets/fonts/Montserrat-Regular.ttf
curl -L "https://github.com/google/fonts/raw/main/ofl/montserrat/static/Montserrat-Bold.ttf" -o assets/fonts/Montserrat-Bold.ttf

echo "✅ Font dosyaları başarıyla indirildi!"
echo "📁 Dosyalar: assets/fonts/ klasöründe"
echo ""
echo "Şimdi şu komutu çalıştırın:"
echo "flutter pub get"


