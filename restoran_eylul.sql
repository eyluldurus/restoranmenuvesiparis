-- phpMyAdmin SQL Dump
-- FINAL VERSION - restoran_eylul
-- Sunucu: MySQL 8.x
-- Karakter seti: utf8mb4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

SET NAMES utf8mb4;

-- --------------------------------------------------------
-- VERİTABANI
-- --------------------------------------------------------
CREATE DATABASE IF NOT EXISTS restoran_eylul
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE restoran_eylul;

-- --------------------------------------------------------
-- KATEGORİLER
-- --------------------------------------------------------
CREATE TABLE kategoriler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO kategoriler (ad) VALUES
('Kahvaltı'),
('Ana Yemekler'),
('İçecekler'),
('Tatlılar');

-- --------------------------------------------------------
-- KULLANICILAR
-- --------------------------------------------------------
CREATE TABLE kullanicilar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    sifre VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

INSERT INTO kullanicilar (ad, email, sifre) VALUES
('Test Kullanıcı', 'test@test.com', '123456');

-- --------------------------------------------------------
-- ÜRÜNLER
-- --------------------------------------------------------
CREATE TABLE urunler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(255) NOT NULL,
    aciklama TEXT,
    fiyat DECIMAL(10,2) NOT NULL,
    kategori_id INT,
    resim VARCHAR(255),
    CONSTRAINT fk_urun_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategoriler(id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO urunler (ad, aciklama, fiyat, kategori_id) VALUES
('Menemen', 'Taze domates, biber, soğan ve yumurta', 45.00, 1),
('Sucuklu Yumurta', 'Tavada sucuklu yumurta', 50.00, 1),
('Köfte', 'El yapımı köfte', 85.00, 2),
('Lahmacun', 'İnce hamur üzerine kıyma', 30.00, 2),
('Kola', 'Soğuk kola', 15.00, 3),
('Ayran', 'Serin ayran', 12.00, 3),
('Künefe', 'Sıcak künefe', 60.00, 4),
('Baklava', 'Fıstıklı baklava', 55.00, 4);

-- --------------------------------------------------------
-- SEPET
-- --------------------------------------------------------
CREATE TABLE sepet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kullanici_id INT NOT NULL,
    urun_id INT NOT NULL,
    adet INT DEFAULT 1,
    tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sepet_kullanici
        FOREIGN KEY (kullanici_id)
        REFERENCES kullanicilar(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sepet_urun
        FOREIGN KEY (urun_id)
        REFERENCES urunler(id)
        ON DELETE CASCADE,
    UNIQUE KEY uniq_sepet (kullanici_id, urun_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- SİPARİŞLER
-- --------------------------------------------------------
CREATE TABLE siparisler (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kullanici_id INT,
    toplam_tutar DECIMAL(10,2),
    durum ENUM('bekliyor','hazırlanıyor','tamamlandı') DEFAULT 'bekliyor',
    tarih DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_siparis_kullanici
        FOREIGN KEY (kullanici_id)
        REFERENCES kullanicilar(id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- --------------------------------------------------------
-- SİPARİŞ DETAY
-- --------------------------------------------------------
CREATE TABLE siparis_detay (
    id INT AUTO_INCREMENT PRIMARY KEY,
    siparis_id INT NOT NULL,
    urun_id INT,
    adet INT NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detay_siparis
        FOREIGN KEY (siparis_id)
        REFERENCES siparisler(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_detay_urun
        FOREIGN KEY (urun_id)
        REFERENCES urunler(id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

COMMIT;
