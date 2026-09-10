# 08 — Next Steps

Bu bölüm yalnızca **read-only / gözlemsel** devam adımlarını tanımlar.

## 1. Startup correlation matrix

Aynı başlangıç penceresinde dört kanalı birlikte kaydet:

```text
filesystem hashes/timestamps
serverout log window
pg_stat_statements delta
Java class/method trace notes
```

Amaç, örneğin `petinfo.dat` değiştiğinde aynı anda hangi sınıfın ve hangi task/log olayının devreye girdiğini görmek.

## 2. `Indication` lifecycle mapping

Aşağıdaki methodların hangi çağrıcılardan geldiğini tam çağrı grafiği halinde belgelemek:

```text
deSerialize()
productNameDeSerialize()
serialize()
addEntry(...)
getEvalExpiryDate()
getInstallationExpiryDate()
```

Hedef: veri formatını değiştirmek değil, **kim yazıyor / kim okuyor / ne zaman** sorusunu cevaplamak.

## 3. `LicenseExpire` vs validation separation

`LicenseExpireTask` ve `LicenseExpire` sınıflarını, ilk lisans doğrulamasından ayırmak gerekiyor.

Sorular:

- Sadece bildirim mi üretir?
- Edition/evaluation durumunu hangi servis üzerinden okur?
- Startup doğrulaması ile paylaştığı ortak sınıflar nelerdir?

## 4. Read-only SQL delta windows

Aşağıdaki olayların her biri için ayrı `pg_stat_statements` snapshot penceresi oluştur:

```text
cold startup
admin login
license/about page open
scheduled expiry task execution window
clean shutdown
```

Her pencerede sadece yeni/artan sorgular raporlanmalı.

## 5. PostgreSQL user comparison

Her önemli DB çıktısını şu formatla etiketle:

```text
[postgres]
...

[sdpadmin]
...

Result comparison: same / different
```

Özellikle extension permissions, function execution rights ve görünür schema farklarını bu şekilde belgelemek yararlı olacaktır.

## 6. Evidence hygiene

Her yeni bulgu için şu mini şablonu kullan:

```text
Observation:
Evidence source:
Timestamp/build context:
What it proves:
What it does NOT prove:
Confidence:
Next read-only test:
```

## 7. Build/version fingerprint

ServiceDesk Plus build numarası, Java runtime sürümü ve ilgili JAR dosyalarının yalnızca hash/version metadata'sını kaydet. Böylece farklı build'lerde sınıf akışının değişip değişmediği karşılaştırılabilir.

## 8. Do not cross this boundary

Bu repo aşağıdaki deneyleri belgelemez veya otomatikleştirmez:

```text
license file forging
signature bypass
binary/JAR patching
DB UPDATE ile entitlement değiştirme
clock rollback/tampering
trial reset / evaluation extension
paid-feature unlock
```

Araştırmanın değeri, bu mekanizmaları etkisizleştirmekten değil, katmanlar arası mimariyi doğru ve yeniden üretilebilir biçimde açıklamaktan gelir.
