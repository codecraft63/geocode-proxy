require 'sinatra'
require 'httparty'
require 'json'

$geocache = {}


get '/address' do
  content_type :json
  query = {
    address: params[:q]
  }

  query_key = Digest::SHA1.hexdigest(query.to_s)

  if $geocache.has_key?(query_key)
    json = $geocache[query_key]
  else
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json", query: {language: "pt-BR", sensor: "false", region: 'BR'}.merge!(query))
    $geocache[query_key] = json = JSON.load(response.body)
  end

  json
end

get '/zipcode' do
  content_type :json
  query = {
    components: "country:BR|postal_code:#{params[:zip]}"
  }

  query_key = Digest::SHA1.hexdigest(query.to_s)

  if $geocache.has_key?(query_key)
    json = $geocache[query_key]
  else
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json", query: {language: "pt-BR", sensor: "false", region: 'BR'}.merge!(query))
    $geocache[query_key] = json = JSON.load(response.body)
  end

  json
end
