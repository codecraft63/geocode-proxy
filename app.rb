require 'sinatra'
require 'httparty'
require 'json'

$geocache = {}


get '/geocode' do
  content_type :json
  query = {}
  query[:address] = params[:q] unless params[:q].nil?
  query[:components] = "country:BR|postal_code:#{params[:zip]}" unless params[:zip].nil?

  query_key = Digest::SHA1.hexdigest(query.to_s)

  if $geocache.has_key?(query_key)
    json = $geocache[query_key]
  else
    response = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json", query: {language: "pt-BR", sensor: "false", region: 'BR'}.merge!(query))
    $geocache[query_key] = json = response.body
  end

  json
end
