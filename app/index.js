const express = require('express');
const redis = require('redis');
const axios = require('axios');

const app = express();
const port = process.env.PORT || 3000;

// Redis client setup
const redisClient = redis.createClient({
  url: `rediss://:${process.env.REDIS_PASSWORD}@${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
  socket: {
    tls: true,
    rejectUnauthorized: false
  }
});

redisClient.connect().catch(console.error);

app.get('/', (req, res) => {
  res.json({ message: 'Weather App is running!' });
});

app.get('/weather/:city', async (req, res) => {
  const { city } = req.params;
  
  try {
    // Check cache first
    const cachedData = await redisClient.get(`weather:${city}`);
    if (cachedData) {
      return res.json(JSON.parse(cachedData));
    }

    // If not in cache, fetch from OpenWeatherMap
    const response = await axios.get(`http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${process.env.WEATHER_API_KEY}`);
    const weatherData = response.data;

    // Cache the result for 5 minutes
    await redisClient.setEx(`weather:${city}`, 300, JSON.stringify(weatherData));

    res.json(weatherData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Weather app listening at http://localhost:${port}`);
}); 