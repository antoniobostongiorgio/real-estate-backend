import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import authRoutes from "./routes/auth.js";
import annunciRoutes from "./routes/annunci.js";

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => res.json({ ok: true, service: "immobiliare-backend" }));

app.use("/api/auth", authRoutes);
app.use("/api/annunci", annunciRoutes);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`✅ Server avviato su porta ${PORT}`));
