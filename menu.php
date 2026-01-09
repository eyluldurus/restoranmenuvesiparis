<?php
require_once 'config/db.php';

/* ==============================
   SEPETE EKLEME
============================== */

if (isset($_POST['sepete_ekle'], $_POST['urun_id'])) {
    $urun_id = (int) $_POST['urun_id'];
    $kullanici_id = $_SESSION['kullanici_id'];

    $kontrol = $db->prepare(
        "SELECT id FROM sepet WHERE kullanici_id = ? AND urun_id = ?"
    );
    $kontrol->execute([$kullanici_id, $urun_id]);
    $urun = $kontrol->fetch(PDO::FETCH_ASSOC);

    if ($urun) {
        $db->prepare(
            "UPDATE sepet SET adet = adet + 1 WHERE id = ?"
        )->execute([$urun['id']]);
    } else {
        $db->prepare(
            "INSERT INTO sepet (kullanici_id, urun_id, adet)
             VALUES (?, ?, 1)"
        )->execute([$kullanici_id, $urun_id]);
    }

    header("Location: menu.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Eylül Restoran</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background-color: #f4f6f9; }
        .navbar { box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .kategori-link { font-weight: 500; }
        .urun-card {
            border-radius: 15px;
            transition: transform .2s, box-shadow .2s;
        }
        .urun-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .fiyat {
            font-size: 18px;
            font-weight: 600;
            color: #198754;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.php">🍽️ Eylül Restoran</a>
        <a href="sepet.php" class="btn btn-light btn-sm">🛒 Sepetim</a>
    </div>
</nav>

<div class="container mt-4">

    <!-- KATEGORİLER -->
    <ul class="nav nav-pills justify-content-center mb-4">
        <li class="nav-item">
            <a class="nav-link <?= !isset($_GET['kategori_id']) ? 'active' : '' ?>" href="menu.php">
                Tümü
            </a>
        </li>

        <?php
        $kategoriler = $db->query(
            "SELECT id, ad FROM kategoriler"
        )->fetchAll(PDO::FETCH_ASSOC);

        foreach ($kategoriler as $kategori):
        ?>
            <li class="nav-item">
                <a class="nav-link kategori-link <?= (isset($_GET['kategori_id']) && (int)$_GET['kategori_id'] === (int)$kategori['id']) ? 'active' : '' ?>"
                   href="?kategori_id=<?= $kategori['id'] ?>">
                    <?= htmlspecialchars($kategori['ad']) ?>
                </a>
            </li>
        <?php endforeach; ?>
    </ul>

    <!-- ÜRÜNLER -->
    <div class="row">
        <?php
        $kategori_id = isset($_GET['kategori_id']) ? (int) $_GET['kategori_id'] : 0;

        if ($kategori_id > 0) {
            $stmt = $db->prepare(
                "SELECT * FROM urunler WHERE kategori_id = ?"
            );
            $stmt->execute([$kategori_id]);
        } else {
            $stmt = $db->query(
                "SELECT * FROM urunler"
            );
        }

        $urunler = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (count($urunler) === 0):
        ?>
            <div class="alert alert-warning text-center">
                Bu kategoride ürün yok.
            </div>
        <?php endif; ?>

        <?php foreach ($urunler as $urun): ?>
            <div class="col-12 col-md-4 mb-4">
                <div class="card urun-card h-100 p-3">

                    <?php if (!empty($urun['resim'])): ?>
                        <img 
                            src="assets/img/<?= $urun['resim'] ?>" 
                            class="card-img-top mb-2"
                            style="height:180px; object-fit:cover;"
                            alt="<?= htmlspecialchars($urun['ad']) ?>"
                        >
                    <?php endif; ?>

                    <h5 class="card-title">
                        <?= htmlspecialchars($urun['ad']) ?>
                    </h5>

                    <p class="card-text text-muted">
                        <?= htmlspecialchars($urun['aciklama']) ?>
                    </p>

                    <div class="d-flex justify-content-between align-items-center mt-auto">
                        <span class="fiyat">
                            <?= number_format($urun['fiyat'], 2) ?> ₺
                        </span>

                        <form method="POST">
                            <input type="hidden" name="urun_id" value="<?= $urun['id'] ?>">
                            <button type="submit" name="sepete_ekle" class="btn btn-success">
                                Sepete Ekle
                            </button>
                        </form>
                    </div>

                </div>
            </div>
        <?php endforeach; ?>
    </div>
</div>

<footer class="bg-dark text-light text-center py-3 mt-5">
    <div class="container">
        © 2026 Eylül Restoran | Tüm hakları saklıdır.
    </div>
</footer>

</body>
</html>
