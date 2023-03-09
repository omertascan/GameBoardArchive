use [BoardGameArchive]
IF OBJECT_ID('SP') IS NOT NULL 
BEGIN 
DROP PROCEDURE dbo.SP
end
go 
create procedure SP
(
@sorguTuru int, @yorumAktifBilgi int=null,@minTarih date=null

)
--Sorgu 1 : pasif yorumları siler 
--Sorgu 2 : Belirtilen tarihten önceki yorumların aktifliğini pasif yapar 
as declare @hata int 
if(@sorguTuru=1)
begin
select Y.yorum
from tblYorumYapma as  Y
inner join tblOyun as O on Y.oyunId=O.id
inner join tblOyuncu as P on Y.oyuncuId=P.id 

where 
Y.aktifmi=@yorumAktifBilgi 
if(@yorumAktifBilgi= 0)
begin 
begin try 
delete from  tblYorumYapma where tblYorumYapma.aktifmi=@yorumAktifBilgi 
end try 
begin catch 
select ERROR_NUMBER() as errNumber ,
ERROR_LINE() as errLine,
ERROR_MESSAGE() as errMsg
end catch 
end 
end

else if(@sorguTuru=2)
begin 
select Y.yorum
from tblYorumYapma as  Y
inner join tblOyun as O on Y.oyunId=O.id
inner join tblOyuncu as P on Y.oyuncuId=P.id 
where 
DATEDIFF(DAY,Y.yorumTarihi,@minTarih)>0
begin transaction 
update tblYorumYapma set aktifmi=0 where tblYorumYapma.yorumTarihi<@minTarih 
set  @hata= @@ERROR 
if(@hata !=0) begin rollback transaction end 
else if (@hata=0) begin commit transaction end 
end 
go 
--Sp kısmı test
--exec dbo.SP 2,0,'2015-01-01' 

--Trigger Test 
Select * from dbo.yedekyorumtablo
exec dbo.SP 1,0
Select * from dbo.yedekyorumtablo
