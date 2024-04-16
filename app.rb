require "sinatra"
require "sinatra/reloader"

get("/") do
  erk = ENV.fetch("EXCHANGE_RATE_KEY")
  api_url = "https://api.exchangerate.host/list?access_key=#{erk}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  currencies_hash = parsed_data.fetch("currencies")
  currency_codes = currencies_hash.keys

  erb :index
end
