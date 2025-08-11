CREATE TABLE [web].[sessions] (
    [id]           INT            DEFAULT (NEXT VALUE FOR [web].[global_id]) NOT NULL,
    [title]        NVARCHAR (200) NOT NULL,
    [abstract]     NVARCHAR (MAX) NOT NULL,
    [owner]        nvarchar (100) NOT NULL,
    [room]         nvarchar (100) NULL,
    [day]          INT NULL,
    [start_time]   TIME NULL,
    [end_time]     TIME NULL, 
    [enabled]      TINYINT,
    [tags]         NVARCHAR (MAX) NULL,
    [last_updated] DATETIME2 (7)  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CHECK (isjson([tags])=(1)),
    UNIQUE NONCLUSTERED ([title] ASC)
);
GO

