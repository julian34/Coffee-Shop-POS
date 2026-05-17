# Hasil JUnit Unit Test — MainActivityTest

**Tanggal dijalankan:** 17 Mei 2026, 16:00:50  
**Perintah:** `./gradlew :app:testDebugUnitTest`  
**File test:** `android/app/src/test/kotlin/id/sevatech/poscafe/MainActivityTest.kt`  
**Class:** `id.sevatech.poscafe.MainActivityTest`

## Ringkasan

| Metrik       | Nilai       |
| ------------ | ----------- |
| Total Test   | 20          |
| Lulus (Pass) | 20          |
| Gagal (Fail) | 0           |
| Error        | 0           |
| Dilewati     | 0           |
| Durasi Total | 0.034 detik |

**Status: ✅ SEMUA TES LULUS**

---

## Detail Per Test Case

### isValidCartId

| No  | Nama Test                                           | Status  | Durasi  |
| --- | --------------------------------------------------- | ------- | ------- |
| 1   | `cartId yang valid mengembalikan true`              | ✅ PASS | 0.000 s |
| 2   | `cartId kosong mengembalikan false`                 | ✅ PASS | 0.001 s |
| 3   | `cartId hanya spasi mengembalikan false`            | ✅ PASS | 0.000 s |
| 4   | `cartId dengan spasi di tengah mengembalikan false` | ✅ PASS | 0.000 s |

### calculateChange

| No  | Nama Test                                           | Status  | Durasi  |
| --- | --------------------------------------------------- | ------- | ------- |
| 5   | `kembalian dihitung dengan benar`                   | ✅ PASS | 0.000 s |
| 6   | `kembalian nol saat uang pas`                       | ✅ PASS | 0.000 s |
| 7   | `kembalian negatif saat uang kurang (underpayment)` | ✅ PASS | 0.000 s |

### isValidRole

| No  | Nama Test                                                      | Status  | Durasi  |
| --- | -------------------------------------------------------------- | ------- | ------- |
| 8   | `role Owner valid`                                             | ✅ PASS | 0.000 s |
| 9   | `role Manager valid`                                           | ✅ PASS | 0.000 s |
| 10  | `role Cashier valid`                                           | ✅ PASS | 0.000 s |
| 11  | `role tidak dikenal mengembalikan false`                       | ✅ PASS | 0.000 s |
| 12  | `role kosong mengembalikan false`                              | ✅ PASS | 0.000 s |
| 13  | `role dengan huruf kecil mengembalikan false (case-sensitive)` | ✅ PASS | 0.001 s |

### resolveCustomerName

| No  | Nama Test                                               | Status  | Durasi  |
| --- | ------------------------------------------------------- | ------- | ------- |
| 14  | `nama pelanggan yang valid dikembalikan apa adanya`     | ✅ PASS | 0.000 s |
| 15  | `nama pelanggan kosong dikembalikan sebagai Guest`      | ✅ PASS | 0.000 s |
| 16  | `nama pelanggan hanya spasi dikembalikan sebagai Guest` | ✅ PASS | 0.028 s |

### isValidPaymentMethod

| No  | Nama Test                                             | Status  | Durasi  |
| --- | ----------------------------------------------------- | ------- | ------- |
| 17  | `metode pembayaran Cash valid`                        | ✅ PASS | 0.000 s |
| 18  | `metode pembayaran QRIS valid`                        | ✅ PASS | 0.000 s |
| 19  | `metode pembayaran tidak dikenal mengembalikan false` | ✅ PASS | 0.000 s |
| 20  | `metode pembayaran kosong mengembalikan false`        | ✅ PASS | 0.000 s |
