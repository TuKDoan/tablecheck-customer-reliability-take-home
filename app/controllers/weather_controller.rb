# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
    include HTTParty
  
    def show
      tracer = OpenTelemetry.tracer_provider.tracer('weather_app')
      city = params[:city]
      api_key = ENV['OPENWEATHERMAP_API_KEY']
      lat = nil
      lon = nil
  
      tracer.in_span("Fetch Coordinates for #{city}") do |span|
        start_time = Time.now
        geo_response = fetch_coordinates(city, api_key)
        end_time = Time.now
        span.set_attribute('response_time', end_time - start_time)
        span.add_event('Coordinates fetched')
  
        if geo_response.success?
          coordinates = geo_response.parsed_response.first
          Rails.logger.info("Coordinates: #{coordinates}")
          if coordinates
            lat = coordinates['lat']
            lon = coordinates['lon']
            Rails.logger.info("Lat: #{lat}, Lon: #{lon}")
          else
            render json: { error: 'No coordinates found' }, status: :bad_request and return
          end
        else
          render json: { error: 'Unable to fetch coordinates' }, status: :bad_request and return
        end
      end
  
      tracer.in_span("Fetch Weather Data for #{city}") do |span|
        start_time = Time.now
        weather_response = fetch_weather_data(lat, lon, api_key)
        end_time = Time.now
        span.set_attribute('response_time', end_time - start_time)
        span.add_event('Weather data fetched')
  
        if weather_response.success?
          weather_data = weather_response.parsed_response
          render json: {
            temperature: "#{weather_data['main']['temp']} °C",
            humidity: "#{weather_data['main']['humidity']} %",
            wind_speed: "#{weather_data['wind']['speed']} m/s"
          }
        else
          render json: { error: 'Unable to fetch weather data' }, status: :bad_request
        end
      end
    end
  
    private
  
    def fetch_coordinates(city, api_key)
      HTTParty.get("http://api.openweathermap.org/geo/1.0/direct", query: { q: city, limit: 1, appid: api_key })
    end
  
    def fetch_weather_data(lat, lon, api_key)
      HTTParty.get("http://api.openweathermap.org/data/2.5/weather", query: { lat: lat, lon: lon, appid: api_key })
    end
  end
  