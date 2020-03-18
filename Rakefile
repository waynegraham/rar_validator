# frozen_string_literal: true
require 'resque/tasks'
require_relative 'lib/StatusWorker.rb'
require_relative 'lib/utils.rb'

DATA_DIR = '_data'.freeze

task default: ["reports:all"]

namespace :validate do
  desc 'Validate the manifests'
  task :manifests do
    Dir["#{DATA_DIR}/*.xlsx"].each do |file|
      puts "Validating #{file}".green
      validate_manifest(file)
    end
  end
end

require 'rubygems'
require 'resque'
require 'uri'
require 'net/http'

class StatusWorker
  @queue = :compute

  def self.perform(url)
    puts "Work started for #{url}"
    sleep 5
    # puts "#{a} #{operation} #{b} = #{a.send(operation, b)}"
  end
end

namespace :reports do
  desc 'Generate a preliminary report of submitted resources'
  task all: %(manifests)

  desc 'queue version'
  task :queue do
    Dir["#{DATA_DIR}/*.xlsx"].each do |file|
      # put URLs in queue
      worksheet = Roo::Spreadsheet.open(file)
      worksheet.default_sheet = worksheet.sheets[1]

      parse_headers(worksheet)

      ((worksheet.first_row + 1)..worksheet.last_row).each do |row|
        values =
          {
            url: worksheet.row(row)[@headers['DIRECT URL TO FILE']],
            checksum: worksheet.row(row)[@headers['CHECKSUM']],
          }

          Resque.enqueue(StatusWorker, values)
      end


    end
  end

  desc 'Generate report for specific file'
  task :manifest do
    ARGV.each { |a| task a.to_sym do ; end }
    file = ARGV[1]
    puts "Processing #{file}".green
    parse_manifest(file)
    contents = render_erb('templates/report.html.erb')
    write_file(@markdown_filename, contents)
  end

  desc 'Check manifiests in DATA_DIR'
  task :manifests do

    files = FileList.new("#{DATA_DIR}/*.xlsx").exclude(/\~\$/)
    files.to_a.each do |file|
      puts "Processing #{file}".green
      parse_manifest(file)

      contents = render_erb('templates/report.html.erb')
      write_file(@markdown_filename, contents)
    end
  end
end
