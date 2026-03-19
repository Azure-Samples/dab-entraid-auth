CREATE TABLE [web].[speakers] (
    [id]        INT            DEFAULT (NEXT VALUE FOR [web].[global_id]) NOT NULL,
    [full_name] NVARCHAR (100) NOT NULL,
    [email]     NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    UNIQUE NONCLUSTERED ([email] ASC)
);
GO

