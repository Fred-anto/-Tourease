OpenAI.configure do |config|
  config.access_token   = ENV["OPENAI_API_KEY"].presence || ENV["GITHUB_TOKEN"]
  config.request_timeout = 240
end
