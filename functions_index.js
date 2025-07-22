
const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI("process.env.GEMINI_API_KEY");

exports.chatIA = functions.https.onRequest(async (req, res) => {
  const prompt = req.body.prompt;
  const model = genAI.getGenerativeModel({ model: "gemini-pro" });
  const result = await model.generateContent(prompt);
  const response = await result.response;
  const text = response.text();
  res.send({ response: text });
});
