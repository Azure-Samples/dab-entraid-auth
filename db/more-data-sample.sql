use [dab_entraid]
go

/*
    Clean up database
*/
delete from web.sessions_speakers
delete from web.speakers
delete from web.sessions
go

/*
    Add sample speakers
*/
insert into web.speakers 
    (id, full_name, email) 
values
    (1, 'John Doe', 'johndoe@acme.com'),
    (2, 'Jane Dean', 'janedean@acme.com')
;

-- Some random data
insert into 
    web.speakers
select 
    100 + s.[value],
    'Speaker ' + format([value], '000'),
    's' + format([value], '000') + '@acme.com'
from 
    generate_series(1, 100) s
go


/*
    Add sample sessions
*/
insert into web.sessions 
    (id, title, [owner], abstract, tags, last_updated)
values
    (1001, 'From databases to API: an efficient solution both on-premises and in Azure', 'johndoe@acme.com', 'Data API builder turns Azure Databases into REST a GraphQL API so that you can have the backend for your next modern application done in just a few minutes instead of days. With full support to authentication and authorization, integrated with Static Web Apps and easily scalable up and out - using API Management - Data API builder is something you really want to look at. Available both on Azure and on-premises, and Open Source, this is very likely to become your favorite tool. Come and learn everything about it!', '["api", "rest", "graphql", "open-api"]', sysdatetime()),
    (1002, 'Some cool title here', 'janedean@acme.com', 'Some cool abstract about cool web technology.', '["web"]', sysdatetime()),
    (1003, 'This is a session done together!', 'johndoe@acme.com', 'Just a demo to showcase many-to-many relationship in GraphQL', '["graphql"]', sysdatetime())
;

-- Some random data
with s as (select [value] as n, abs(checksum(newid())) as r from generate_series(1, 1000))
insert into
    web.sessions (id, title, abstract, [owner], [day], [room])
select     
    [id] = 10000 + n,
    [title] = 'Sample Session ' + format(n, '0000'),
    [abstract] = 'Abstract for session ' + format(n, '0000'),
    [owner] = 'admin',
    [day] = r % 5 + 1,
    [room] = choose(r % 7 + 1, 'Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Indigo', 'Violet')
from 
    s
go

/*
    Associate speakers to sessions
*/
insert into web.sessions_speakers 
    (session_id, speaker_id)    
values
    (1001, 1),
    (1002, 2),
    (1003, 1),
    (1003, 2)
go

with s as (select [value] as n, abs(checksum(newid())) as r from generate_series(1, 1000))
insert into
    web.sessions_speakers (session_id, speaker_id)    
select     
    [session_id] = 10000 + n,
    [speaker_id] = 100 + (n % 100) + 1
from 
    s
go

/*
    View the data
*/
select * from web.sessions;

select * from web.speakers;

select * from web.sessions_speakers;

select
    title,
    full_name
from
    web.sessions s 
inner join
    web.sessions_speakers ss on s.id = ss.session_id 
inner join
    web.speakers sp on ss.speaker_id = sp.id
where
    s.title like '%API%';

select
    title,
    full_name
from
    web.sessions s 
inner join
    web.sessions_speakers ss on s.id = ss.session_id
inner join
    web.speakers sp on ss.speaker_id = sp.id
where
    sp.full_name = 'Speaker 007'
