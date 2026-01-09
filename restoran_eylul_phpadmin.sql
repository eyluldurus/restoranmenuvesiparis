-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 09 Oca 2026, 03:34:18
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `restoran_eylul`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `adminler`
--

CREATE TABLE `adminler` (
  `id` int(11) NOT NULL,
  `kullanici_adi` varchar(50) NOT NULL,
  `sifre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `adminler`
--

INSERT INTO `adminler` (`id`, `kullanici_adi`, `sifre`) VALUES
(1, 'admin', '$2y$10$aHDCXy6AHUrsG9AqNwdyYexfEVv2gTAKhVNthYcyvYInJEZTH2SIW');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kategoriler`
--

CREATE TABLE `kategoriler` (
  `id` int(11) NOT NULL,
  `ad` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `kategoriler`
--

INSERT INTO `kategoriler` (`id`, `ad`) VALUES
(2, 'Ana Yemekler'),
(3, 'İçecekler'),
(1, 'Kahvaltı'),
(4, 'Tatlılar');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanicilar`
--

CREATE TABLE `kullanicilar` (
  `id` int(11) NOT NULL,
  `ad` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `sifre` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `kullanicilar`
--

INSERT INTO `kullanicilar` (`id`, `ad`, `email`, `sifre`) VALUES
(1, 'Test Kullanıcı', 'test@test.com', '123456');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sepet`
--

CREATE TABLE `sepet` (
  `id` int(11) NOT NULL,
  `kullanici_id` int(11) NOT NULL,
  `urun_id` int(11) NOT NULL,
  `adet` int(11) DEFAULT 1,
  `tarih` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `siparisler`
--

CREATE TABLE `siparisler` (
  `id` int(11) NOT NULL,
  `kullanici_id` int(11) DEFAULT NULL,
  `toplam_tutar` decimal(10,2) DEFAULT NULL,
  `durum` enum('bekliyor','hazırlanıyor','tamamlandı') DEFAULT 'bekliyor',
  `tarih` datetime DEFAULT current_timestamp(),
  `masa_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `siparisler`
--

INSERT INTO `siparisler` (`id`, `kullanici_id`, `toplam_tutar`, `durum`, `tarih`, `masa_no`) VALUES
(1, 1, 300.00, 'tamamlandı', '2026-01-06 01:43:53', NULL),
(2, 1, 50.00, 'tamamlandı', '2026-01-06 02:13:10', NULL),
(3, 1, 233.00, 'tamamlandı', '2026-01-06 02:38:33', NULL),
(4, 1, 170.00, 'tamamlandı', '2026-01-06 02:39:01', NULL),
(5, 1, 154.00, 'tamamlandı', '2026-01-08 21:19:59', NULL),
(6, 1, 157.00, 'tamamlandı', '2026-01-08 21:20:35', NULL),
(7, 1, 67.00, 'tamamlandı', '2026-01-08 21:39:48', NULL),
(8, 1, 227.00, 'tamamlandı', '2026-01-08 22:23:58', NULL),
(9, 1, 95.00, 'tamamlandı', '2026-01-08 23:07:14', NULL),
(10, 1, 140.00, 'tamamlandı', '2026-01-08 23:51:48', NULL),
(11, 1, 95.00, 'tamamlandı', '2026-01-09 00:11:59', NULL),
(12, 1, 375.00, 'bekliyor', '2026-01-09 00:18:10', NULL),
(13, 1, 95.00, 'bekliyor', '2026-01-09 01:05:25', 5),
(14, 1, 195.00, 'bekliyor', '2026-01-09 01:11:08', 5),
(15, 1, 50.00, 'bekliyor', '2026-01-09 01:34:00', 5),
(16, 1, 90.00, 'bekliyor', '2026-01-09 01:43:19', 6),
(17, 1, 180.00, 'bekliyor', '2026-01-09 01:53:34', NULL),
(18, 1, 110.00, 'bekliyor', '2026-01-09 01:54:46', NULL),
(19, 1, 130.00, 'hazırlanıyor', '2026-01-09 02:04:23', 7),
(20, 1, 57.00, 'hazırlanıyor', '2026-01-09 02:24:40', 7),
(21, 1, 140.00, 'hazırlanıyor', '2026-01-09 02:32:45', 8),
(22, 1, 60.00, 'hazırlanıyor', '2026-01-09 03:51:12', 9),
(23, 1, 275.00, 'hazırlanıyor', '2026-01-09 05:24:52', 9);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `siparis_detay`
--

CREATE TABLE `siparis_detay` (
  `id` int(11) NOT NULL,
  `siparis_id` int(11) NOT NULL,
  `urun_id` int(11) DEFAULT NULL,
  `adet` int(11) NOT NULL,
  `fiyat` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `siparis_detay`
--

INSERT INTO `siparis_detay` (`id`, `siparis_id`, `urun_id`, `adet`, `fiyat`) VALUES
(1, 1, 2, 2, 50.00),
(2, 1, 3, 1, 85.00),
(3, 1, 7, 1, 60.00),
(4, 1, 8, 1, 55.00),
(5, 2, 2, 1, 50.00),
(6, 3, 5, 1, 15.00),
(7, 3, 8, 2, 55.00),
(8, 3, 6, 4, 12.00),
(9, 3, 4, 2, 30.00),
(10, 4, 8, 2, 55.00),
(11, 4, 7, 1, 60.00),
(12, 5, 1, 1, 45.00),
(13, 5, 3, 1, 85.00),
(14, 5, 6, 2, 12.00),
(15, 6, 5, 2, 15.00),
(16, 6, 8, 1, 55.00),
(17, 6, 7, 1, 60.00),
(18, 6, 6, 1, 12.00),
(19, 7, 6, 1, 12.00),
(20, 7, 8, 1, 55.00),
(21, 8, 3, 2, 85.00),
(22, 8, 5, 1, 15.00),
(23, 8, 6, 1, 12.00),
(24, 8, 4, 1, 30.00),
(25, 9, 1, 1, 45.00),
(26, 9, 2, 1, 50.00),
(27, 10, 1, 2, 45.00),
(28, 10, 2, 1, 50.00),
(29, 11, 2, 1, 50.00),
(30, 11, 1, 1, 45.00),
(31, 12, 2, 2, 50.00),
(32, 12, 3, 2, 85.00),
(33, 12, 1, 1, 45.00),
(34, 12, 7, 1, 60.00),
(35, 13, 1, 1, 45.00),
(36, 13, 2, 1, 50.00),
(37, 14, 1, 1, 45.00),
(38, 14, 2, 1, 50.00),
(39, 14, 3, 1, 85.00),
(40, 14, 5, 1, 15.00),
(41, 15, 2, 1, 50.00),
(42, 16, 1, 2, 45.00),
(43, 17, 1, 1, 45.00),
(44, 17, 2, 1, 50.00),
(45, 17, 3, 1, 85.00),
(46, 18, 1, 1, 45.00),
(47, 18, 2, 1, 50.00),
(48, 18, 5, 1, 15.00),
(49, 19, 8, 1, 55.00),
(50, 19, 7, 1, 60.00),
(51, 19, 5, 1, 15.00),
(52, 20, 1, 1, 45.00),
(53, 20, 6, 1, 12.00),
(54, 21, 3, 1, 85.00),
(55, 21, 8, 1, 55.00),
(56, 22, 1, 1, 45.00),
(57, 22, 5, 1, 15.00),
(58, 23, 8, 1, 55.00),
(59, 23, 3, 1, 85.00),
(60, 23, 5, 2, 15.00),
(61, 23, 1, 1, 45.00),
(62, 23, 7, 1, 60.00);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `urunler`
--

CREATE TABLE `urunler` (
  `id` int(11) NOT NULL,
  `ad` varchar(255) NOT NULL,
  `aciklama` text DEFAULT NULL,
  `fiyat` decimal(10,2) NOT NULL,
  `kategori_id` int(11) DEFAULT NULL,
  `resim` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `urunler`
--

INSERT INTO `urunler` (`id`, `ad`, `aciklama`, `fiyat`, `kategori_id`, `resim`) VALUES
(1, 'Menemen', 'Taze domates, biber, soğan ve yumurta', 45.00, 1, 'menemen.jpg'),
(2, 'Sucuklu Yumurta', 'Tavada sucuklu yumurta', 50.00, 1, 'sucuklu-yumurta.jpg'),
(3, 'Köfte', 'El yapımı köfte', 85.00, 2, 'kofte.jpg'),
(4, 'Lahmacun', 'İnce hamur üzerine kıyma', 30.00, 2, 'lahmacun.jpg'),
(5, 'Kola', 'Soğuk kola', 15.00, 3, 'kola.jpg'),
(6, 'Ayran', 'Serin ayran', 12.00, 3, 'ayran.jpg'),
(7, 'Künefe', 'Sıcak künefe', 60.00, 4, 'kunefe.jpg'),
(8, 'Baklava', 'Fıstıklı baklava', 55.00, 4, 'baklava.jpg');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `adminler`
--
ALTER TABLE `adminler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kullanici_adi` (`kullanici_adi`);

--
-- Tablo için indeksler `kategoriler`
--
ALTER TABLE `kategoriler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ad` (`ad`);

--
-- Tablo için indeksler `kullanicilar`
--
ALTER TABLE `kullanicilar`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Tablo için indeksler `sepet`
--
ALTER TABLE `sepet`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_sepet` (`kullanici_id`,`urun_id`),
  ADD KEY `fk_sepet_urun` (`urun_id`);

--
-- Tablo için indeksler `siparisler`
--
ALTER TABLE `siparisler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_siparis_kullanici` (`kullanici_id`);

--
-- Tablo için indeksler `siparis_detay`
--
ALTER TABLE `siparis_detay`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_detay_siparis` (`siparis_id`),
  ADD KEY `fk_detay_urun` (`urun_id`);

--
-- Tablo için indeksler `urunler`
--
ALTER TABLE `urunler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_urun_kategori` (`kategori_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `adminler`
--
ALTER TABLE `adminler`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `kategoriler`
--
ALTER TABLE `kategoriler`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `kullanicilar`
--
ALTER TABLE `kullanicilar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `sepet`
--
ALTER TABLE `sepet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- Tablo için AUTO_INCREMENT değeri `siparisler`
--
ALTER TABLE `siparisler`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Tablo için AUTO_INCREMENT değeri `siparis_detay`
--
ALTER TABLE `siparis_detay`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- Tablo için AUTO_INCREMENT değeri `urunler`
--
ALTER TABLE `urunler`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `sepet`
--
ALTER TABLE `sepet`
  ADD CONSTRAINT `fk_sepet_kullanici` FOREIGN KEY (`kullanici_id`) REFERENCES `kullanicilar` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sepet_urun` FOREIGN KEY (`urun_id`) REFERENCES `urunler` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `siparisler`
--
ALTER TABLE `siparisler`
  ADD CONSTRAINT `fk_siparis_kullanici` FOREIGN KEY (`kullanici_id`) REFERENCES `kullanicilar` (`id`) ON DELETE SET NULL;

--
-- Tablo kısıtlamaları `siparis_detay`
--
ALTER TABLE `siparis_detay`
  ADD CONSTRAINT `fk_detay_siparis` FOREIGN KEY (`siparis_id`) REFERENCES `siparisler` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detay_urun` FOREIGN KEY (`urun_id`) REFERENCES `urunler` (`id`) ON DELETE SET NULL;

--
-- Tablo kısıtlamaları `urunler`
--
ALTER TABLE `urunler`
  ADD CONSTRAINT `fk_urun_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategoriler` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
