# Security & Responsible Research Policy

Bu depo yalnızca eğitim, mimari analiz, gözlemlenebilirlik ve savunmacı güvenlik araştırması içindir.

## Kapsam içi

- Read-only log analizi
- Dosya hash/timestamp karşılaştırmaları
- PostgreSQL şema ve sorgu telemetry incelemesi
- Java sınıf/method çağrı ilişkilerinin belgelenmesi
- Evaluation/lisans yaşam döngüsünün yüksek seviyeli modellenmesi
- Yetkili test ortamlarında davranış gözlemi

## Kapsam dışı

- Lisans doğrulamasını atlatan patch veya kod
- Lisans dosyası sahteleme, imza atlatma veya binary modifikasyonu
- Yetkisiz şekilde evaluation süresini uzatma
- Ücretli özellikleri lisanssız etkinleştirme
- Üreticiye ait JAR/binary/decompile çıktılarının yeniden dağıtılması
- Gerçek lisans anahtarı, parola, token veya müşteri verisi paylaşımı

## Raporlama yaklaşımı

Bulgular mümkün olduğunca üç sınıfa ayrılır:

- **Confirmed:** doğrudan gözlem/log/schema/hash ile doğrulandı.
- **Strong indicator:** birden fazla bağımsız gözlem aynı yorumu destekliyor.
- **Hypothesis:** test edilmesi gereken çalışma modeli.

Amaç mekanizmayı anlamaktır; mekanizmayı etkisizleştirmek değildir.
