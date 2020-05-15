if defined?(VCR)
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures'
    config.hook_into :webmock
  end
end
