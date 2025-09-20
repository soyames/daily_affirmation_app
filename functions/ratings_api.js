// Simple REST API for app ratings
// Requires: express, cors, body-parser, lowdb (for file-based storage)

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { Low, JSONFile } = require('lowdb');
const { nanoid } = require('nanoid');

const app = express();
const port = 3000;

// Setup DB
const db = new Low(new JSONFile('ratings.json'));

app.use(cors());
app.use(bodyParser.json());

// Initialize DB with empty ratings array if not present
(async () => {
  await db.read();
  db.data = db.data || { ratings: [] };
  await db.write();
})();

// POST /ratings { stars, comment, deviceId }
app.post('/ratings', async (req, res) => {
  const { stars, comment, deviceId } = req.body;
  if (!stars || stars < 1 || stars > 5) {
    return res.status(400).json({ error: 'Stars must be 1-5' });
  }
  // Optionally prevent duplicate ratings per device
  const existing = db.data.ratings.find(r => r.deviceId === deviceId);
  if (existing) {
    return res.status(409).json({ error: 'Device already rated' });
  }
  const rating = {
    id: nanoid(),
    stars,
    comment: comment || '',
    deviceId,
    createdAt: new Date().toISOString(),
  };
  db.data.ratings.push(rating);
  await db.write();
  res.json({ success: true });
});

// GET /ratings/summary
app.get('/ratings/summary', async (req, res) => {
  await db.read();
  const ratings = db.data.ratings;
  const count = ratings.length;
  const avg = count ? (ratings.reduce((sum, r) => sum + r.stars, 0) / count) : 0;
  res.json({ average: avg, count });
});

// GET /ratings
app.get('/ratings', async (req, res) => {
  await db.read();
  // Return most recent first
  res.json(db.data.ratings.slice().reverse());
});

app.listen(port, () => {
  console.log(`Ratings API listening at http://localhost:${port}`);
});
