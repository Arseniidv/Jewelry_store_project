/**
 * Support API — receives POST /api/v1/support from the iOS app
 * and forwards to Telegram Bot.
 *
 * All secrets come from environment variables (never hardcoded).
 *
 * ─── Quick Start ─────────────────────────────────────
 *   1. npm install
 *   2. cp .env.example .env   # fill in your tokens
 *   3. node support.js        # → http://0.0.0.0:5678
 * ─────────────────────────────────────────────────────
 */

require("dotenv").config();

const express = require("express");

const app = express();
app.use(express.json());

// ─── Environment ─────────────────────────────────────

const {
  TELEGRAM_BOT_TOKEN,
  TELEGRAM_CHAT_ID,
  PORT = 5678,
} = process.env;

if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_CHAT_ID) {
  console.error("❌ Missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID");
  console.error("   Check your .env file or environment variables.");
  process.exit(1);
}

// ─── Helpers ─────────────────────────────────────────

function escapeMarkdown(text) {
  return text.replace(/[_*[\]()~`>#+\-=|{}.!]/g, "\\$&");
}

// ─── Telegram ────────────────────────────────────────

async function sendToTelegram(subject, message, deviceInfo) {
  const text = [
    "📩 *New Support Request*",
    "",
    "*Subject:* " + escapeMarkdown(subject),
    "*Message:* " + escapeMarkdown(message),
    "*Device:* " + escapeMarkdown(deviceInfo || "unknown"),
    "*Date:* " + new Date().toISOString().replace("T", " ").split(".")[0] + " UTC",
  ].join("\n");

  const botToken = TELEGRAM_BOT_TOKEN;
  const chatId = TELEGRAM_CHAT_ID;

  console.log("[Telegram] Sending to chat_id:", chatId);
  console.log("[Telegram] Bot token (last 4 chars): ..." + botToken.slice(-4));

  const url = `https://api.telegram.org/bot${botToken}/sendMessage`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      chat_id: chatId,
      text,
      parse_mode: "Markdown",
    }),
  });

  if (!res.ok) {
    const body = await res.text();
    console.error("[Telegram] API error:", res.status, body);
    if (res.status === 401) {
      console.error("[Telegram] ❌ Bot token is invalid or revoked.");
    } else if (res.status === 400) {
      console.error("[Telegram] ❌ Chat ID is invalid or bot is not a member.");
    }
    throw new Error(`Telegram API ${res.status}: ${body}`);
  }

  console.log("[Telegram] ✅ Message sent successfully");
}

// ─── POST /api/v1/support ────────────────────────────

app.post("/api/v1/support", async (req, res) => {
  const { subject, message, device_info } = req.body;

  if (!subject || !message) {
    return res.status(400).json({ error: "subject and message are required" });
  }

  try {
    await sendToTelegram(subject, message, device_info);
    res.status(200).json({ status: "ok" });
  } catch (err) {
    console.error("Delivery failed:", err);
    res.status(500).json({ error: "Failed to deliver message" });
  }
});

// ─── Start ───────────────────────────────────────────

const os = require("os");

app.listen(PORT, "0.0.0.0", () => {
  const interfaces = os.networkInterfaces();
  let localIP = "unknown";
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name] || []) {
      if (iface.family === "IPv4" && !iface.internal) {
        localIP = iface.address;
        break;
      }
    }
    if (localIP !== "unknown") break;
  }

  console.log("─".repeat(50));
  console.log(`🚀 Support API running`);
  console.log(`   Local:   http://localhost:${PORT}`);
  console.log(`   Network: http://${localIP}:${PORT}`);
  console.log(`   Endpoint: POST /api/v1/support`);
  console.log("─".repeat(50));
});
