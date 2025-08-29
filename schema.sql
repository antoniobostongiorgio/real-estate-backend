-- Schema database PostgreSQL

CREATE TABLE IF NOT EXISTS agenzie (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    indirizzo TEXT,
    telefono VARCHAR(50),
    logo_url TEXT,
    piano_abbonamento VARCHAR(50) DEFAULT 'free',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS utenti (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    ruolo VARCHAR(50) NOT NULL CHECK (ruolo IN ('agente','admin_agenzia','superadmin')),
    agenzia_id INT REFERENCES agenzie(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS annunci (
    id SERIAL PRIMARY KEY,
    agenzia_id INT REFERENCES agenzie(id) ON DELETE CASCADE,
    titolo VARCHAR(200) NOT NULL,
    descrizione TEXT,
    prezzo NUMERIC(12,2) NOT NULL,
    mq INT NOT NULL,
    locali INT NOT NULL,
    bagni INT NOT NULL,
    indirizzo TEXT,
    cover_url TEXT,
    tour_mode VARCHAR(20) NOT NULL CHECK (tour_mode IN ('built-in','embed')),
    embed_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS statistiche_annuncio (
    id SERIAL PRIMARY KEY,
    annuncio_id INT REFERENCES annunci(id) ON DELETE CASCADE,
    views INT DEFAULT 0,
    tours INT DEFAULT 0,
    data DATE NOT NULL,
    UNIQUE (annuncio_id, data)
);

CREATE TABLE IF NOT EXISTS lead_clienti (
    id SERIAL PRIMARY KEY,
    annuncio_id INT REFERENCES annunci(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(50),
    messaggio TEXT,
    data_creazione TIMESTAMP DEFAULT NOW()
);
