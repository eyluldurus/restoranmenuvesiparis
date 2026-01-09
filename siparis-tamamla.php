<?php
require_once 'config/db.php';

/* ==============================
   MASA KONTROLÜ (ZORUNLU)
============================== */

if (!isset($_SESSION['masa_no'])) {
    header("Location: musteri-giris.php");
    exit;
}

$kullanici_id = $_SESSION['kullanici_id'];
$masa_no = $_SESSION['masa_no'];

/* ==============================
   SİPARİŞ OLUŞTURMA
============================== */

if (isset($_POST['siparis_onayla'])) {

    // Sepeti çek
    $stmt = $db->prepare("
        SELECT sepet.*, urunler.fiyat
        FROM sepet
        INNER JOIN urunler ON sepet.urun_id = urunler.id
        WHERE sepet.kullanici_id = ?
    ");
    $stmt->execute([$kullanici_id]);
    $urunler = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Sepet boşsa geri dön
    if (count($urunler) === 0) {
        header("Location: sepet.php");
        exit;
    }

    // Toplam hesapla
    $toplam_tutar = 0;
    foreach ($urunler as $u) {
        $toplam_tutar += $u['adet'] * $u['fiyat'];
    }

    try {
        // TRANSACTION BAŞLAT
        $db->beginTransaction();

        // Sipariş ekle
        $stmt = $db->prepare("
            INSERT INTO siparisler (kullanici_id, masa_no, toplam_tutar, durum)
            VALUES (?, ?, ?, 'bekliyor')
        ");
        $stmt->execute([$kullanici_id, $masa_no, $toplam_tutar]);
        $siparis_id = $db->lastInsertId();

        // Sipariş detayları
        $stmt = $db->prepare("
            INSERT INTO siparis_detay (siparis_id, urun_id, adet, fiyat)
            VALUES (?, ?, ?, ?)
        ");

        foreach ($urunler as $u) {
            $stmt->execute([
                $siparis_id,
                $u['urun_id'],
                $u['adet'],
                $u['fiyat']
            ]);
        }

        // Sepeti temizle
        $db->prepare(
            "DELETE FROM sepet WHERE kullanici_id = ?"
        )->execute([$kullanici_id]);

        // TRANSACTION BİTİR
        $db->commit();

        header("Location: siparis-tamamla.php?ok=1");
        exit;

    } catch (Exception $e) {
        $db->rollBack();
        die("Sipariş oluşturulurken bir hata oluştu.");
    }
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sipariş Onayı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f6f9; }
        .onay-card {
            max-width: 700px;
            margin: auto;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }
        .success-icon {
            font-size: 50px;
        }
    </style>
</head>

<body class="container mt-5">

<div class="card onay-card p-4">
    <h2 class="text-center mb-3">🧾 Sipariş Onayı</h2>

<?php if (isset($_GET['ok'])): ?>

    <div class="alert alert-success text-center">
        <div class="success-icon">✅</div>
        <strong>Siparişiniz başarıyla alındı!</strong>
        <p class="mb-0">En kısa sürede hazırlanacaktır.</p>
    </div>

    <div class="text-center">
        <a href="menu.php" class="btn btn-primary">Menüye Dön</a>
    </div>

<?php else: ?>

<?php
$stmt = $db->prepare("
    SELECT sepet.*, urunler.ad, urunler.fiyat
    FROM sepet
    INNER JOIN urunler ON sepet.urun_id = urunler.id
    WHERE sepet.kullanici_id = ?
");
$stmt->execute([$kullanici_id]);
$urunler = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<?php if (count($urunler) === 0): ?>

    <div class="alert alert-warning text-center">
        Sepetiniz boş.
    </div>

    <div class="text-center">
        <a href="menu.php" class="btn btn-secondary">Menüye Dön</a>
    </div>

<?php else: ?>

    <ul class="list-group mb-3">
        <?php $toplam = 0; ?>
        <?php foreach ($urunler as $u): ?>
            <?php
                $satir = $u['adet'] * $u['fiyat'];
                $toplam += $satir;
            ?>
            <li class="list-group-item d-flex justify-content-between">
                <?= htmlspecialchars($u['ad']) ?> (<?= $u['adet'] ?> adet)
                <strong><?= number_format($satir, 2) ?> ₺</strong>
            </li>
        <?php endforeach; ?>
    </ul>

    <h4 class="text-end">Toplam: <?= number_format($toplam, 2) ?> ₺</h4>

    <form method="POST" class="text-center mt-4">
        <button type="submit" name="siparis_onayla" class="btn btn-success btn-lg">
            Siparişi Onayla
        </button>
    </form>

<?php endif; ?>
<?php endif; ?>

</div>

<footer class="bg-dark text-light text-center py-3 mt-5">
    <div class="container">
        © 2026 Eylül Restoran | Tüm hakları saklıdır.
    </div>
</footer>

</body>
</html>
