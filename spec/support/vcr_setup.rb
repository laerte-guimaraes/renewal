if defined?(VCR)
  require 'webmock/rspec'

  RSpec.configure do |config|
    config.include WebMock::API
  end

  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures'
    config.hook_into :webmock
  end
end
