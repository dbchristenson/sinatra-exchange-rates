require "sinatra"
require "sinatra/reloader"
require "http"

def get_codes
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

  return currency_codes
end

get("/") do
  @currency_codes = get_codes()

  erb :index
end

get("/:currency1") do |currency1|
  @selected_currency1 = currency1
  @currency_codes = get_codes()

  erb :select_currency2
end

get("/:currency1/:currency2") do |currency1, currency2|
  @selected_currency1 = currency1
  @selected_currency2 = currency2

  # Logic to retrieve the exchange rate between currency1 and currency2
  access_key = ENV['EXCHANGE_RATE_KEY']
  api_url = "https://api.exchangerate.host/convert?access_key=#{access_key}&from=#{currency1}&to=#{currency2}"
  
  response = HTTP.get(api_url)
  result = response.parse(:json)

  erb :show_rate
end
