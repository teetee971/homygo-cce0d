const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");

exports.chatIA = functions.https.onRequest(async (req, res) => {
  res.set("Cache-Control", "no-store");

  if (req.method !== "POST") {
    res.status(405).send({ error: "Méthode non autorisée." });
    return;
  }

  const apiKey = process.env.GEMINI_API_KEY;
  const modelName = process.env.GEMINI_MODEL;

  if (!apiKey || !modelName) {
    res.status(503).send({ error: "Service IA non configuré." });
    return;
  }

  const prompt = typeof req.body?.prompt === "string" ? req.body.prompt.trim() : "";
  if (!prompt || prompt.length > 4000) {
    res.status(400).send({ error: "Prompt invalide." });
    return;
  }

  try {
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: modelName });
    const result = await model.generateContent(prompt);
    const response = await result.response;
    res.status(200).send({ response: response.text() });
  } catch (error) {
    console.error("chatIA failed", error);
    res.status(502).send({ error: "Le service IA est temporairement indisponible." });
  }
});
