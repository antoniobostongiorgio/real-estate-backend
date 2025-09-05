import express from "express";
import authRoutes from "./routes/auth.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use("/auth", authRoutes);

app.get("/", (req, res) => {
  res.send("Hello from Render 🚀 with Auth Route");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
