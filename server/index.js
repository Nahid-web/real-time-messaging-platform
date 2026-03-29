require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { RtcTokenBuilder, RtcRole } = require('agora-token');

const app = express();
app.use(cors());
app.use(express.json());

const APP_ID = process.env.AGORA_APP_ID;
const APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE;
const PORT = process.env.PORT || 3001;

// Health check
app.get('/', (req, res) => {
  res.json({ status: 'Agora token server running ✅' });
});

/**
 * Generate an Agora RTC token
 *
 * GET /generate-token?channelName=<channelId>&uid=<uid>&role=publisher
 *
 * Query params:
 *   channelName  (required) — Agora channel ID (callId from Firebase)
 *   uid          (optional) — user ID (0 = let Agora assign one)
 *   role         (optional) — 'publisher' (default) or 'audience'
 *   expiry       (optional) — token lifetime in seconds (default: 3600 = 1 hour)
 */
app.get('/generate-token', (req, res) => {
  const { channelName, uid = 0, role = 'publisher', expiry = 3600 } = req.query;

  if (!channelName) {
    return res.status(400).json({ error: 'channelName query parameter is required' });
  }

  if (!APP_ID || !APP_CERTIFICATE) {
    return res.status(500).json({ error: 'Agora credentials are not configured on the server' });
  }

  const rtcRole =
    role === 'audience' ? RtcRole.SUBSCRIBER : RtcRole.PUBLISHER;

  const expirationTimeInSeconds = parseInt(expiry, 10);
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTime = currentTimestamp + expirationTimeInSeconds;

  try {
    const token = RtcTokenBuilder.buildTokenWithUid(
      APP_ID,
      APP_CERTIFICATE,
      channelName,
      parseInt(uid, 10),
      rtcRole,
      privilegeExpiredTime,
    );

    return res.json({ token, uid, channelName, expiresIn: expirationTimeInSeconds });
  } catch (err) {
    console.error('Token generation error:', err.message);
    return res.status(500).json({ error: 'Failed to generate token' });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Agora token server listening on http://localhost:${PORT}`);
  console.log(`   GET /generate-token?channelName=<id>&uid=<uid>`);
});
