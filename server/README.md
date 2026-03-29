# Agora Token Server

Express.js server to generate short-lived Agora RTC tokens for the Real-Time Messaging Platform.

## Setup

```bash
cd server
npm install
npm run dev       # development (auto-reload)
npm start         # production
```

## Environment Variables

Copy `.env` and fill in your real credentials:

| Variable | Value |
|----------|-------|
| `AGORA_APP_ID` | Your Agora App ID |
| `AGORA_APP_CERTIFICATE` | Your Agora App Certificate (**keep secret!**) |
| `PORT` | Port to run the server (default: 3001) |

## API Endpoints

### `GET /` — Health check
```json
{ "status": "Agora token server running ✅" }
```

### `GET /generate-token` — Generate an Agora RTC token

**Query Parameters:**

| Param | Required | Default | Description |
|-------|----------|---------|-------------|
| `channelName` | ✅ Yes | — | The Agora channel ID (use `callId` from Firebase) |
| `uid` | No | `0` | The user UID (0 = Agora assigns one) |
| `role` | No | `publisher` | `publisher` (caller/receiver) or `audience` |
| `expiry` | No | `3600` | Token lifetime in seconds |

**Example:**
```
GET http://localhost:3001/generate-token?channelName=abc123&uid=0
```

**Response:**
```json
{
  "token": "006a355f...",
  "uid": 0,
  "channelName": "abc123",
  "expiresIn": 3600
}
```

## Connecting Flutter to This Server

In your Flutter `.env`, update `serverBaseUrl` to this server's deployed URL. Then before joining a call, fetch the token:

```dart
final response = await http.get(Uri.parse(
  '${dotenv.env['serverBaseUrl']}/generate-token?channelName=$channelId&uid=0'
));
final token = jsonDecode(response.body)['token'];
```

## Deployment

This server can be deployed to any Node.js host:
- **Render**: Free tier, auto-deploys from GitHub
- **Railway**: Simple, generous free tier
- **Fly.io**: Fast global edge deployment
