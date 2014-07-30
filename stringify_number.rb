#!/usr/bin/env ruby 

# == Synopsis
#   This cli app accepts an amount (including decimal) less than
#   999 trillion and outputs a string representation
#
# == Examples
#   stringify_number 1010.45
#   >> one thousand ten and 45/100
#
# == Usage
#   stringify_number [options] amount
#
#   For help use: stringify_number -h
#
# == Options
#   -h, --help          Displays help message
#   -v, --version       Display the version, then exit
#
# == Author
#   Doug Farre
#   dougfarre@gmail.com
#
# == Copyright
#   Copyright (c) 2014 Doug Farre. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php

require 'rubygems'
require 'rdoc/usage'
require 'optparse'
require 'ostruct'
require 'date'
require './lib/main'

class App
  include Stringifier
  VERSION = '0.0.1'
  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin

    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    puts 'initialized'
  end

  # Parse options, check arguments, then process the command
  def run
    if parsed_options? && arguments_valid?
      puts "Start at #{DateTime.now}\n\n" if @options.verbose
      output_options if @options.verbose

      process_command

      puts "\nFinished at #{DateTime.now}" if @options.verbose
    else
      output_usage
    end
  end

  protected

    def parsed_options?
      # Specify options
      opts = OptionParser.new 
      opts.on('-v', '--version')    { output_version ; exit 0 }
      opts.on('-h', '--help')       { output_help }
      opts.on('-V', '--verbose')    { @options.verbose = true }  

      opts.parse!(@arguments) rescue return false

      true
    end

    def output_options
      puts "Options:\n"

      @options.marshal_dump.each do |name, val|
        puts "  #{name} = #{val}"
      end
    end

    def arguments_valid?
      one_argument = @arguments.length == 1

      return one_argument
    end

    def output_help
      output_version
      RDoc::usage() #exits app
    end

    def output_usage
      RDoc::usage('usage') # gets usage from comments above
    end

    def output_version
      puts "#{File.basename(__FILE__)} version #{VERSION}"
    end

    def process_command
      puts 'starting process_command'
      output = stringify(@arguments)
      puts output
    end
end

# Create and run the application
app = App.new(ARGV, STDIN)
app.run
