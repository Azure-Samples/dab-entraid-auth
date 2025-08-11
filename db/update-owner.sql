use [dab_entraid]
go

select * from web.sessions
go

update web.sessions
set [owner] = 'OBJECT_ID'
where id = 1001
go
