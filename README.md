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
real-estate-backend/
├── server.js
├── package.json
└── routes/
    ├── auth.js
    └── annunci.js
import express from "express";
import authRoutes from "./routes/auth.js";
import annunciRoutes from "./routes/annunci.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use("/auth", authRoutes);
app.use("/annunci", annunciRoutes);

app.get("/", (req, res) => {
  res.send("Hello from Render 🚀 with Auth & Annunci Routes");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
import express from "express";

const router = express.Router();

// Login demo
router.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (email === "test@test.com" && password === "1234") {
    return res.json({ token: "fake-jwt-token" });
  }

  return res.status(401).json({ error: "Invalid credentials" });
});

export default router;
import express from "express";

const router = express.Router();

// Annunci demo
let annunci = [
  { id: 1, titolo: "Appartamento in centro", prezzo: 200000 },
  { id: 2, titolo: "Villa con giardino", prezzo: 450000 },
  { id: 3, titolo: "Monolocale economico", prezzo: 80000 }
];

// GET tutti gli annunci
router.get("/", (req, res) => {
  res.json(annunci);
});

// GET un annuncio specifico
router.get("/:id", (req, res) => {
  const id = parseInt(req.params.id);
  const annuncio = annunci.find(a => a.id === id);
  if (annuncio) {
    res.json(annuncio);
  } else {
    res.status(404).json({ error: "Annuncio non trovato" });
  }
});

// POST nuovo annuncio
router.post("/", (req, res) => {
  const { titolo, prezzo } = req.body;
  const nuovo = { id: annunci.length + 1, titolo, prezzo };
  annunci.push(nuovo);
  res.status(201).json(nuovo);
});

export default router;
{
  "name": "real-estate-backend",
  "version": "1.2.0",
  "type": "module",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
