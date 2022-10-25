this is for demo purpose to connect psql from nodejs api.

```bash
docker run --name pg -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=jino -e POSTGRES_DB=jino -p 5432:5432 -d postgres
```