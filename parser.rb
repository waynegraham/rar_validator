# frozen_string_literal: true

require 'roo'
require 'to_bool'

require 'erb'
require 'uri'
require 'net/http'
# https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L492
require 'rack'

def check_url(url)
  uri = if url.start_with?('http')
          url
        else
          ''
        end
  uri
end

def render_erb(template_path)
  template = File.open(template_path, 'r').read
  puts template
  # erb = ERB.new(template)
  # erb.result(binding)
end

def write_file(path, contents)
  file = File.open(path, 'w')
  file.write(contents)
rescue IOError => error
  puts 'File not writable. Check your permissions'
  puts error.inspect
ensure
  file.close unless file.nil?
end

def map_status_code(code); end

def check_file(uri, restricted); end

xlsx = Roo::Spreadsheet.open('./CLIR_Digitization_File_Manifest.xlsx')

## Grant data
@grant = {
  grant_number: xlsx.sheet(0).row(1)[1],
  title: xlsx.sheet(0).row(2)[1],
  institution: xlsx.sheet(0).row(3)[1],
  contact: xlsx.sheet(0).row(4)[1],
  email: xlsx.sheet(0).row(5)[1],
  submission: xlsx.sheet(0).row(6)[1]
}

puts "Checking file components"

## file data
xlsx.default_sheet = xlsx.sheets[1]
headers = {}
xlsx.row(1).each_with_index { |header, i| headers[header] = i }

((xlsx.first_row + 1)..xlsx.last_row).each do |row|
  filename = xlsx.row(row)[headers['ACCESS  FILENAME']]
  url = xlsx.row(row)[headers['DIRECT URL TO FILE']]
  checksum = xlsx.row(row)[headers['CHECKSUM']]
  checked = xlsx.row(row)[headers['DATE LAST CHECKED']]
  restricted = xlsx.row(row)[headers['RESTRICTED? (Y/N)']].to_bool
  comments = xlsx.row(row)[headers['COMMENTS ABOUT RESTRICTIONS']]
  preservation_filename = xlsx.row(row)[headers['PRESERVATION FILENAME']]
  preservation_file_location = xlsx.row(row)[headers['PRESERVATION FILE LOCATION']]

  online_url = check_url(url)
  # unless online_url.empty?
  #   uri = URI.parse(online_url)
  #   response = Net::HTTP.get_response(uri)
  #   puts response.code
  # end
end


contents = render_erb('templates/report.html.erb')
