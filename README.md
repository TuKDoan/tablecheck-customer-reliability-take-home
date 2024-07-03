# Simple Weather API and Monitoring Integration

## Overview
This is a simple Ruby on Rails application that exposes an API for retrieving weather data for a given city. The application integrates with OpenTelemetry for monitoring purposes.

## Use Cases
- Find the weather of a current user's location.
- Track weather changes over time for a specific location.
- Figure out the weather if you can't be bothered to go outside.

## Features
- Retrieve weather data for a given city (temperature, humidity, wind speed).
- Utilizes the OpenWeatherMap API to fetch weather data.
- Integrates with OpenTelemetry to collect metrics and traces.

## API Endpoint
### GET /weather
Retrieves weather data for a specified city.

#### Request
- `city` (string, required): The name of the city for which to retrieve weather data.

#### Example
```bash
curl -X GET "http://localhost:3000/weather/tokyo"
```

#### Response
```json
{
  "temperature": 25,
  "humidity": 60,
  "wind_speed": 5
}
```

## Setting Up the Application
### Prerequisites
- Ruby
- Rails
- OpenWeatherMap API key
   To make an API key go here and create an account and API key: https://home.openweathermap.org/

### Installation
1. Clone the repository.
   ```bash
   git clone https://github.com/TuKDoan/tablecheck-customer-reliability-take-home.git
   cd tablecheck-customer-reliability-take-home
   ```

2. Install dependencies.
   ```bash
   bundle install
   ```

3. Set up the database.
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Set up environment variables.
   Create a `.env` file and add your OpenWeatherMap API key.
   ```env
   OPENWEATHERMAP_API_KEY=your_api_key
   ```

5. Run the application.
   ```bash
   rails server
   ```

## Running Tests
To run the tests for this application, use the following command:
```bash
bundle exec rspec
```

## Monitoring Integration
The application integrates with OpenTelemetry to collect metrics and traces. The configuration can be found in `config/initializers/opentelemetry.rb`.

I was unable to find the time to include custom metrics (e.g., weather data requests per minute, average response time). However, the traces are there and can always add the functionality.

## Potential Improvements
- Add support for additional weather data fields.
- Implement caching to reduce the number of API requests.
- Add rate limiting to handle excessive requests.
- Provide support for multiple weather APIs to improve reliability.
- Export traces to a backend such as Prometheus.
- Support for multiple languages.
- Support for Zip-Codes (America)
- Support for city look up with country code.
- Support for different units of measurement.
