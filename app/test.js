const assert = require('assert');
const axios = require('axios');

const API_URL = process.env.API_URL || 'http://localhost:3000';
const WEATHER_API_KEY = process.env.WEATHER_API_KEY || 'dummy-key';

describe('Weather App Tests', () => {
  // Add a check for required environment variables
  before(function() {
    if (!process.env.WEATHER_API_KEY) {
      console.warn('Warning: WEATHER_API_KEY environment variable not set');
    }
  });

  it('should return weather data for a city', async () => {
    try {
      const response = await axios.get(`${API_URL}/weather/london`);
      assert.strictEqual(response.status, 200);
      assert.ok(response.data.name);
      assert.ok(response.data.main);
      assert.ok(response.data.weather);
    } catch (error) {
      if (error.code === 'ECONNREFUSED') {
        this.skip();
      } else {
        throw error;
      }
    }
  });

  it('should handle invalid city names', async () => {
    try {
      await axios.get(`${API_URL}/weather/invalidcity123`);
      assert.fail('Expected an error for invalid city');
    } catch (error) {
      if (error.code === 'ECONNREFUSED') {
        this.skip();
      } else {
        assert.ok(error.response);
        assert.strictEqual(error.response.status, 500);
      }
    }
  });
}); 