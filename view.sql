USE [BoardGameArchive]
--VİEW 
IF OBJECT_ID('dbo.oyun_bilgi') IS not null
BEGIN
DROP VIEW oyun_bilgi
END
GO 
------VIEW---
---Oyun adı , puan , yayimlanmaTarihi , zorluk,yassniri, kategori adı , ortalama puan , Artist adı bilgileri getirilir ---
 --İnnerJoin kısımında yayimciID ile yayimci adi getirilecek, kategoriId ile kategori tablosunda oyunun hangi kategoriye ait olduğu getirilecek--
 --Case kısmında  yas sınırı 7 den küçük olan oyunlar çoçcuklar için , 7-14 arası gençler için , 14 ten büyük olanlar yetişkinler için olmak üzere bilgiler getirilir
 -- test kısmında ise fonksiyon kısından alınan ortalama puana  azalan değere göre bilgiler getirilir


CREATE VIEW oyun_bilgi as
SELECT o.id,o.adi,o.puan,o.yayimlanmaTarihi AS Yayimlanma_Tarihi,o.zorluk,o.yasSiniri, tblKategori.adi as Kategori_Adı,
dbo.ortalama_fiyat(tblKategori.id) as ortalama_fiyat,
Case  WHEN o.yasSiniri < 7 THEN 'Çocuklar için'
WHEN o.yasSiniri > 7 and o.yasSiniri < 14 THEN 'Gençler için' 
ELSE 'Yetişkinler için'
END as Yas_Siniri
FROM tblOyun o
INNER JOIN tblKategori ON o.kategorid = tblKategori.id

Select  * from oyun_bilgi 
go 
select  W.adi as OyunADI, W.Kategori_Adı ,A.adi as ArtisAdi,W.ortalama_fiyat As Fiyat
from dbo.oyun_bilgi W 
INNER JOIN tblArtist A on A.id=W.id 

order by ortalama_fiyat desc