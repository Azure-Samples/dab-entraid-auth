-- This file contains SQL statements that will be executed after the build script.

-- Create application user 
if (serverproperty('Edition') = 'SQL Azure') begin
    if not exists (select * from sys.database_principals where [type] in ('E', 'S') and [name] = 'dab_user')
    begin 
        create user [dab_user] with password = 'P@ssw0rd';
    end      
end else begin
    if not exists (select * from sys.server_principals where [type] in ('E', 'S') and [name] = 'dab_user')
    begin 
        create login [dab_user] with password = 'P@ssw0rd'
    end    

    if not exists (select * from sys.database_principals where [type] in ('E', 'S') and [name] = 'dab_user')
    begin
        create user [dab_user] from login [dab_user]            
    end
end

-- Just for demo purposes, don't do this in production, 
-- but, instead, give only the minimum permissions needed for the application to work
if not exists(select * from sys.database_role_members where 
                role_principal_id = database_principal_id('db_owner') and 
                member_principal_id = database_principal_id('dab_user'))
begin
    alter role db_owner add member [dab_user]
end

-- Add sample data
if ((select count(*) from web.sessions) = 0) begin
    insert into web.speakers 
        (id, full_name, email) 
    values
        (1, 'John Doe', 'johndoe@acme.com'),
        (2, 'Jane Dean', 'janedean@acme.com')
    ;
    insert into web.sessions 
        (id, title, [owner], abstract, tags, last_updated)
    values
        (1001, 'From databases to API: an efficient solution both on-premises and in Azure', 'johndoe@acme.com', 'Data API builder turns Azure Databases into REST a GraphQL API so that you can have the backend for your next modern application done in just a few minutes instead of days. With full support to authentication and authorization, integrated with Static Web Apps and easily scalable up and out - using API Management - Data API builder is something you really want to look at. Available both on Azure and on-premises, and Open Source, this is very likely to become your favorite tool. Come and learn everything about it!', '["api", "rest", "graphql", "open-api"]', sysdatetime()),
        (1002, 'Some cool title here', 'janedean@acme.com', 'Some cool abstract about cool web technology.', '["web"]', sysdatetime()),
        (1003, 'This is a session done together!', 'johndoe@acme.com', 'Just a demo to showcase many-to-many relationship in GraphQL', '["graphql"]', sysdatetime())
    ;
    insert into web.sessions_speakers 
        (session_id, speaker_id)    
    values
        (1001, 1),
        (1002, 2),
        (1003, 1),
        (1003, 2)
end
;