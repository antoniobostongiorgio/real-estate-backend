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
