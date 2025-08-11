# Build the sample DB and expose it with Data API Builder (no auth)

## Initialize Data API Builder (DAB)

Create a DAB config for development pointing to your database:

```powershell
dab init --database-type mssql --host-mode development --connection-string "@env('MSSQL')"
```

## Add entities and permissions (no auth)

Add the two entities from the `web` schema with open permissions:

```powershell
dab add Session --source "web.sessions" --permissions "anonymous:*"
dab add Speaker --source "web.speakers" --permissions "anonymous:*"
```

## Start DAB and explore Swagger

```powershell
dab start
```

Open Swagger UI:
- http://localhost:5000/swagger/index.html

You should see REST endpoints for your entities.


## Expose friendly REST paths (hot reload demo)

Change the Session REST path to `sessions`. To demo hot reload, edit `dab-config.json` in VS Code to set the REST path on the `Session` entity, or run:

```powershell
dab update Session --rest "sessions"
```

Then set the Speaker REST path:

```powershell
dab update Speaker --rest "speakers"
```

Refresh Swagger to see `/api/sessions` and `/api/speakers`.

## Try GraphQL

GraphQL endpoint:
- http://localhost:5000/graphql

Query sessions:

```graphql
query {
  sessions {
    items {
      id
      title
      abstract
    }
  }
}
```

## Add relationships (many-to-many)

Relate Sessions and Speakers via the linking object `web.sessions_speakers`:

Stop DAB via CTRL-C and then update the configuration:

```powershell
dab update Session --relationship speakers --cardinality many --target.entity Speaker --linking.object "web.sessions_speakers"

dab update Speaker --relationship sessions --cardinality many --target.entity Session --linking.object "web.sessions_speakers"
```

Run DAB via `dab start` and then test via GraphQL.

The following GraphQL query will return the sessions and the related speakers

```graphql
query {
  sessions {
    items {
      id
      title
      abstract
      speakers {
        items {
          full_name
        }
      }
    }
  }
}
```

while the next one will return the speakers and their sessions

```graphql
query {
  speakers {
    items {
      id
      full_name
      sessions {
        items {
          title
        }
      }
    }
  }
}
```

## Enable CORS for Live Server

If serving `index.html` with Live Server (default http://localhost:5500) you need to make sure that CORS is configured properly:

```powershell
dab configure --runtime.host.cors.origins http://localhost:5500
```
