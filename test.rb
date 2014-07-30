#!/usr/bin/env ruby 
# Test module - run ./test.rb and inspect output
require './lib/main'

class App
  include Stringifier

  def initialize
    compare(0, 100, 'one hundred')
    compare(1, 1000, 'one thousand')
    compare(2, 10000, 'ten thousand')
    compare(3, 100000, 'one hundred thousand')
    compare(4, 1000000, 'one million')
    compare(5, 10000000, 'ten million')
    compare(6, 90000021, 'ninety million twenty-one')
    compare(7, 90000021, 'eighty million twenty-one', false)
    compare(7, 92000021.33, 'ninety-two million twenty-one and 33/100')
  end

  private

  def compare(test_number, number, expected_result, expect_valid = true)
    output = stringify(number.to_s)
    is_valid = expected_result == output

    if is_valid || !expect_valid
      puts "test number " + test_number.to_s + " is true"
      return
    end

    puts 'test number ' + test_number.to_s + ' expected "' + expected_result + '" but returned "' + output + '"'
  end
end

tests = App.new
