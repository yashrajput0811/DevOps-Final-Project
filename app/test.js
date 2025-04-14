const assert = require('assert');
const axios = require('axios');

describe('Weather App Tests', () => {
  it('should return weather data for a city', async () => {
    const response = await axios.get('http://localhost:3000/weather/london');
    assert.strictEqual(response.status, 200);
    assert.ok(response.data.name);
    assert.ok(response.data.main);
    assert.ok(response.data.weather);
  });

  it('should handle invalid city names', async () => {
    try {
      await axios.get('http://localhost:3000/weather/invalidcity123');
      assert.fail('Expected an error for invalid city');
    } catch (error) {
      assert.strictEqual(error.response.status, 500);
    }
  });
}); 