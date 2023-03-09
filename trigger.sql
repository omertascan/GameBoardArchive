use [BoardGameArchive]
IF OBJECT_ID('tr') IS NOT NULL 
BEGIN 
DROP TRIGGER dbo.tr
end
go 
IF OBJECT_ID('yedekyorumtablo') IS NOT NULL 
BEGIN 
DROP table yedekyorumtablo
end
go 
--Yedel bir yorum tablosu oluşturuldu 
Create table yedekyorumtablo (
    ID INT PRIMARY KEY IDENTITY(1,1),
    yorumId INT,
    begenmeSayisi INT
)
go
create trigger tr on tblYorumYapma
after delete
as
begin
declare @yorumid int
declare @begenme int
select @yorumid=id,@begenme=begenme from deleted -- deleted tablosundan veriler alındı 

if(@begenme < 5) -- begenme sayısı 5 ten büyük olanlar yedek yorum tablosuna eklendi 
begin
raiserror('Sadece begenme sayisi 5 ten büyük olanlar yedeklenecek',1,1)
rollback transaction
end
else
begin
insert into yedekyorumtablo Values(@yorumid,@begenme)
end
end