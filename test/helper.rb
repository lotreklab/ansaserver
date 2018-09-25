require 'simplecov'

SimpleCov.command_name 'Unit Tests'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start do
  add_filter '../lib/'
end

require 'minitest/autorun'
