# Immobiliare Backend (Express + PostgreSQL)

Backend per servizio di tour 3D per agenzie immobiliari.

## Requisiti
- Node.js 18+
- PostgreSQL (in locale o su cloud)
- Variabili d'ambiente: `DATABASE_URL`, `JWT_SECRET`

## Avvio locale
```bash
npm install
cp .env.example .env
# modifica .env con la tua DATABASE_URL
npm run dev
# API su http://localhost:4000
```

## Endpoints principali
- `POST /api/auth/register { nome, email, password }` → crea agenzia+utente e restituisce token
- `POST /api/auth/login { email, password }` → JWT
- `GET /api/annunci` (auth) → lista
- `POST /api/annunci` (auth) → crea
- `PUT /api/annunci/:id` (auth) → aggiorna
- `DELETE /api/annunci/:id` (auth) → elimina

## Deploy su Render
1. Crea un repository GitHub e carica questi file.
2. Su Render → **New → Web Service** → collega il repo.
3. Runtime: **Node**.  
   - Build Command: `npm install`  
   - Start Command: `npm start`
4. Variabili **Environment**:
   - `DATABASE_URL` = stringa connessione Postgres (Render → New → PostgreSQL → Connect → External URL)
   - `JWT_SECRET` = una stringa lunga a caso
   - `PGSSL` = `true` (consigliato su Render)
5. Deploy.

## Database
Esegui lo schema SQL qui sotto (su Render DB o locale):

Vedi `schema.sql` in repo. Puoi usare il terminale di Render o un client (es. TablePlus).

## Test veloci (curl)
```bash
# register
curl -s -X POST https://<TUO_HOST>/api/auth/register -H 'content-type: application/json'   -d '{ "nome":"Agenzia Uno", "email":"demo@example.com", "password":"pass123" }' | jq

# login
TOKEN=$(curl -s -X POST https://<TUO_HOST>/api/auth/login -H 'content-type: application/json'   -d '{ "email":"demo@example.com", "password":"pass123" }' | jq -r .token)

# create listing
curl -s -X POST https://<TUO_HOST>/api/annunci -H "authorization: Bearer $TOKEN" -H 'content-type: application/json'   -d '{ "titolo":"Trilocale", "descrizione":"luminoso", "prezzo":250000, "mq":95, "locali":3, "bagni":2, "indirizzo":"Via Roma", "tour_mode":"built-in" }' | jq

# list
curl -s https://<TUO_HOST>/api/annunci -H "authorization: Bearer $TOKEN" | jq
```

## Licenza
MIT
