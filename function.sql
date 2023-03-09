use [BoardGameArchive]
IF OBJECT_ID('dbo.ortalama_fiyat') IS not null
BEGIN
DROP FUNCTION ortalama_fiyat
END
GO
-- Kategori id alarak o kategoride ki oyunların fiyatlarının ortalamasını alan fonksiyon 
create function ortalama_fiyat 
(

@kategori int

)
returns int as 
begin 
declare @kategorifiyatı as int 
select @kategorifiyatı= AVG(fiyat) from tblOyun as O 
INNER JOIN tblKategori as K on K.id=O.kategorid 
where  K.id=@kategori 
return @kategorifiyatı 
end
go  
select dbo.ortalama_fiyat(4 ) 


 

