# Font ve Asset Ekleme Rehberi

## 📝 Adım 1: Font Dosyalarını İndirme

### Pacifico Font:
1. Tarayıcınızda şu adrese gidin: https://fonts.google.com/specimen/Pacifico
2. Sağ üstteki "Download family" butonuna tıklayın
3. İndirilen ZIP dosyasını açın
4. `Pacifico-Regular.ttf` dosyasını bulun
5. Bu dosyayı kopyalayın ve şu klasöre yapıştırın:
   ```
   assets/fonts/Pacifico-Regular.ttf
   ```

### Montserrat Font:
1. Tarayıcınızda şu adrese gidin: https://fonts.google.com/specimen/Montserrat
2. Sağ üstteki "Download family" butonuna tıklayın
3. İndirilen ZIP dosyasını açın
4. Şu dosyaları bulun:
   - `Montserrat-Regular.ttf`
   - `Montserrat-Bold.ttf`
5. Bu dosyaları kopyalayın ve şu klasöre yapıştırın:
   ```
   assets/fonts/Montserrat-Regular.ttf
   assets/fonts/Montserrat-Bold.ttf
   ```

## 📝 Adım 2: Font Dosyalarını Klasöre Kopyalama

### Yöntem 1: Finder (Mac) veya File Explorer (Windows) ile:
1. İndirdiğiniz font dosyalarını bulun
2. Proje klasörünüze gidin: `CS310-TERM-PROJECT-main-`
3. `assets/fonts/` klasörüne gidin
4. Font dosyalarını buraya sürükleyip bırakın

### Yöntem 2: Terminal ile:
```bash
# Proje klasörüne gidin
cd /Users/sabanciberke/Desktop/CS310-TERM-PROJECT-main-

# Font dosyalarınızın bulunduğu yolu kullanarak kopyalayın
# Örnek (kendi dosya yolunuzu yazın):
cp ~/Downloads/Pacifico-Regular.ttf assets/fonts/
cp ~/Downloads/Montserrat-Regular.ttf assets/fonts/
cp ~/Downloads/Montserrat-Bold.ttf assets/fonts/
```

## 📝 Adım 3: Asset Görselleri Ekleme

1. Kullanmak istediğiniz görselleri hazırlayın (PNG, JPG formatında)
2. Görselleri `assets/images/` klasörüne kopyalayın
3. Örnek görsel isimleri:
   - `logo.png`
   - `placeholder.png`
   - `app_icon.png`

## 📝 Adım 4: Flutter'ı Güncelleme

Font ve asset dosyalarını ekledikten sonra terminalde şu komutu çalıştırın:

```bash
flutter pub get
```

## ✅ Kontrol

Dosyaların doğru yerde olduğunu kontrol etmek için:

```bash
# Font dosyalarını kontrol et
ls -la assets/fonts/

# Görsel dosyalarını kontrol et
ls -la assets/images/
```

Şunları görmelisiniz:
- `assets/fonts/Pacifico-Regular.ttf`
- `assets/fonts/Montserrat-Regular.ttf`
- `assets/fonts/Montserrat-Bold.ttf`
- `assets/images/` (görselleriniz)

## 🚨 Önemli Notlar

1. **pubspec.yaml zaten güncellendi** - Font ve asset yapılandırması eklenmiş durumda
2. **Dosya isimleri önemli** - Dosya isimleri tam olarak eşleşmeli (büyük/küçük harf duyarlı)
3. **Uygulamayı yeniden başlatın** - Font değişikliklerini görmek için uygulamayı tamamen kapatıp açın

## 📱 Kodda Kullanım

### Font kullanımı (zaten kodda var):
```dart
Text(
  'FitSwipe',
  style: TextStyle(
    fontFamily: 'Pacifico',  // Otomatik olarak çalışacak
    fontSize: 28,
  ),
)
```

### Asset görsel kullanımı:
```dart
Image.asset('assets/images/logo.png')
```


