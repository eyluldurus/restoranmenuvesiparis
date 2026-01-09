<?php
require_once 'config/db.php';

$hata = "";

if (isset($_POST['giris'])) {
    $masa_no = trim($_POST['masa_no']);

    if (ctype_digit($masa_no) && (int)$masa_no >= 1 && (int)$masa_no <= 20) {
        $_SESSION['masa_no'] = (int) $masa_no;
        header("Location: menu.php");
        exit;
    } else {
        $hata = "Lütfen 1 ile 20 arasında geçerli bir masa numarası giriniz.";
    }
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Müşteri Girişi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height:100vh;">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow p-4">
                <h3 class="text-center mb-3">🧑‍🍽️ Müşteri Girişi</h3>

                <?php if ($hata): ?>
                    <div class="alert alert-danger text-center"><?= $hata ?></div>
                <?php endif; ?>

                <form method="POST">
                    <div class="mb-3">
                        <label class="form-label">Masa Numaranız</label>
                        <input
    type="number"
    name="masa_no"
    class="form-control"
    placeholder="Örn: 5"
    min="1"
    max="20"
    required
    inputmode="numeric"
    pattern="[0-9]*"
>

                    </div>

                    <button type="submit" name="giris" class="btn btn-success w-100">
                        Giriş Yap
                    </button>
                </form>

                <div class="text-center mt-3">
                    <a href="index.php">← Geri Dön</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
