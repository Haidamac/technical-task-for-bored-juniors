# frozen_string_literal: true

require 'rest-client'

class BoredApiWrapper
  BASE_URL = 'https://www.boredapi.com/api/activity'

  def self.random_activity(options = {})
    query_params = options.to_query
    url = "#{BASE_URL}?#{query_params}"

    begin
      response = RestClient.get(url)
      parsed_response = JSON.parse(response.body)

      if parsed_response['error'] == 'No activity found with the specified parameters'
        puts "API returned an error: #{parsed_response['error']}"
        return nil
      end

      parsed_response
    rescue RestClient::ExceptionWithResponse => e
      puts "RestClient error: #{e.message}"
      nil
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      nil
    end
  end
end
