<?php
require_once 'config/db.php';

$kullanici_id = $_SESSION['kullanici_id'];

/* SEPETTEN SİLME */
if (isset($_GET['sil'])) {
    $id = (int) $_GET['sil'];

    $db->prepare(
        "DELETE FROM sepet WHERE id = ? AND kullanici_id = ?"
    )->execute([$id, $kullanici_id]);

    header("Location: sepet.php");
    exit;
}

/* SEPETİ ÇEK */
$sorgu = $db->prepare("
    SELECT sepet.*, urunler.ad, urunler.fiyat
    FROM sepet
    INNER JOIN urunler ON sepet.urun_id = urunler.id
    WHERE sepet.kullanici_id = ?
");
$sorgu->execute([$kullanici_id]);
$urunler = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sepetim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f6f9; }
        .sepet-card {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .sepet-title {
            color: #0d6efd;
            font-weight: 600;
        }
        table tbody tr:hover { background-color: #f1f7ff; }
        .btn-danger,
        .btn-primary,
        .btn-secondary {
            border-radius: 20px;
            padding: 8px 20px;
        }
        .toplam-box {
            background-color: #e9f2ff;
            padding: 15px;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
        }
    </style>
</head>

<body class="container mt-5">

<div class="card sepet-card p-4">
    <h2 class="sepet-title mb-4">🛒 Sepetim</h2>

    <?php if (count($urunler) === 0): ?>
        <div class="alert alert-warning">
            Sepetiniz boş.
        </div>
        <a href="index.php" class="btn btn-secondary">
            Alışverişe Başla
        </a>
    <?php else: ?>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-primary text-center">
                <tr>
                    <th>Ürün</th>
                    <th>Adet</th>
                    <th>Fiyat</th>
                    <th>Toplam</th>
                    <th>Sil</th>
                </tr>
            </thead>
            <tbody>

            <?php $genel_toplam = 0; ?>
            <?php foreach ($urunler as $u): ?>
                <?php
                    $satir_toplam = $u['adet'] * $u['fiyat'];
                    $genel_toplam += $satir_toplam;
                ?>
                <tr class="text-center">
                    <td class="text-start"><?= htmlspecialchars($u['ad']) ?></td>
                    <td><?= $u['adet'] ?></td>
                    <td><?= number_format($u['fiyat'], 2) ?> ₺</td>
                    <td><?= number_format($satir_toplam, 2) ?> ₺</td>
                    <td>
                        <a href="sepet.php?sil=<?= $u['id'] ?>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Ürünü sepetten silmek istiyor musunuz?')">
                            Sil
                        </a>
                    </td>
                </tr>
            <?php endforeach; ?>

            </tbody>
        </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3">
        <div class="toplam-box">
            Genel Toplam: <?= number_format($genel_toplam, 2) ?> ₺
        </div>
        <div>
            <a href="menu.php" class="btn btn-secondary w-100 mb-2">
                Alışverişe Devam Et
            </a>
            <a href="siparis-tamamla.php" class="btn btn-primary w-100 ">
                Sipariş Ver
            </a>
        </div>
    </div>

    <?php endif; ?>
</div>
<footer class="bg-dark text-light text-center py-3 mt-5">
    <div class="container">
        © 2026 Eylül Restoran | Tüm hakları saklıdır.
    </div>
</footer>

</body>
</html>
