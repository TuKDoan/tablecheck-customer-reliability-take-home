# spec/controllers/weather_controller_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #show' do
    let(:city) { 'Tokyo' }
    let(:api_key) { 'test_api_key' }

    before do
      allow(ENV).to receive(:[]).with('OPENWEATHERMAP_API_KEY').and_return(api_key)
    end

    context 'when the geo API returns a successful response' do
      before do
        stub_request(:get, "http://api.openweathermap.org/geo/1.0/direct")
          .with(query: { q: city, limit: 1, appid: api_key })
          .to_return(
            status: 200,
            body: [{ lat: 35.6895, lon: 139.6917 }].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      context 'when the weather API returns a successful response' do
        before do
          stub_request(:get, "http://api.openweathermap.org/data/2.5/weather")
            .with(query: { lat: 35.6895, lon: 139.6917, appid: api_key })
            .to_return(
              status: 200,
              body: { main: { temp: 25, humidity: 60 }, wind: { speed: 5 } }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        it 'returns the weather data' do
          get :show, params: { city: city }
          expect(response).to have_http_status(:success)
          data = JSON.parse(response.body)
          expect(data['temperature']).to eq('25 °C')
          expect(data['humidity']).to eq('60 %')
          expect(data['wind_speed']).to eq('5 m/s')
        end
      end

      context 'when the weather API returns an error response' do
        before do
          stub_request(:get, "http://api.openweathermap.org/data/2.5/weather")
            .with(query: { lat: 35.6895, lon: 139.6917, appid: api_key })
            .to_return(status: 500, body: '')

          it 'returns an error message' do
            get :show, params: { city: city }
            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)['error']).to eq('Unable to fetch weather data')
          end
        end
      end
    end

    context 'when the geo API returns an error response' do
      before do
        stub_request(:get, "http://api.openweathermap.org/geo/1.0/direct")
          .with(query: { q: city, limit: 1, appid: api_key })
          .to_return(status: 500, body: '')

        it 'returns an error message' do
          get :show, params: { city: city }
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)['error']).to eq('Unable to fetch coordinates')
        end
      end
    end
  end
end
