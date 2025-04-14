// Weather App - A simple weather service with Redis caching
const express = require('express');
const axios = require('axios');
const Redis = require('redis');
const { promisify } = require('util');

const app = express();
const port = process.env.PORT || 3000;
const WEATHER_API_KEY = process.env.WEATHER_API_KEY;

// Redis setup
const redisClient = Redis.createClient({
  url: process.env.REDIS_URL || 'redis://localhost:6379'
});

redisClient.on('error', (err) => console.log('Redis Client Error', err));

const getAsync = promisify(redisClient.get).bind(redisClient);
const setAsync = promisify(redisClient.set).bind(redisClient);

app.get('/', (req, res) => {
  res.json({ message: 'Weather App is running!' });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Weather endpoint with caching
app.get('/weather/:city', async (req, res) => {
  try {
    const { city } = req.params;
    
    // Check cache first
    const cachedData = await getAsync(city);
    if (cachedData) {
      console.log('Cache hit for city:', city);
      return res.json(JSON.parse(cachedData));
    }

    // If not in cache, fetch from API
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${WEATHER_API_KEY}&units=metric`
    );

    // Cache the result for 5 minutes
    await setAsync(city, JSON.stringify(response.data), 'EX', 300);
    
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching weather data:', error.message);
    if (error.response && error.response.status === 404) {
      res.status(404).json({ error: 'City not found' });
    } else {
      res.status(500).json({ error: 'Failed to fetch weather data' });
    }
  }
});

app.listen(port, () => {
  console.log(`Weather app listening at http://localhost:${port}`);
}); 