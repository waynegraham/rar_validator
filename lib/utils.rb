# frozen_string_literal: true

require 'chronic'
require 'roo'
require 'to_bool'
# https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L492
require 'rack'

require 'erb'
require 'uri'
require 'net/http'
require 'yaml'

def filename(spreadsheet)
   formatted_date = Chronic.parse(spreadsheet.sheet(0).row(6)[1]).strftime('%Y-%m-%d')
   grant_number = spreadsheet.sheet(0).row(1)[1]
   "_manifests/#{formatted_date}-#{grant_number}.md"
end

def render_erb(template_path)
  template = File.open(template_path, 'r').read
  erb = ERB.new(template)
  erb.result(binding)
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

def parse_grant_info(worksheet)
  @grant = {
    grant_number: worksheet.sheet(0).row(1)[1],
    title:        worksheet.sheet(0).row(2)[1],
    institution:  worksheet.sheet(0).row(3)[1],
    contact:      worksheet.sheet(0).row(4)[1],
    email:        worksheet.sheet(0).row(5)[1],
    submission:   worksheet.sheet(0).row(6)[1]
  }
end

def parse_headers(worksheet)
  @headers = {}
  worksheet.row(1).each_with_index { |header, i| @headers[header] = i }
end

def check_url(url)
  begin
    return URI.parse(url)
  rescue
    "Invalid URL"
  end
end

def parse_url_info(worksheet)
  worksheet.default_sheet = worksheet.sheets[1]
  parse_headers(worksheet)

  @assets = { }

  ((worksheet.first_row + 1)..worksheet.last_row).each do |row|
    @assets[worksheet.row(row)[@headers['ACCESS  FILENAME']]] =
      {
        filename: worksheet.row(row)[@headers['ACCESS  FILENAME']].strip,
        url: worksheet.row(row)[@headers['DIRECT URL TO FILE']],
        checksum: worksheet.row(row)[@headers['CHECKSUM']],
        checked: DateTime.now,
        # checked: worksheet.row(row)[@headers['DATE LAST CHECKED']],
        restricted: worksheet.row(row)[@headers['RESTRICTED? (Y/N)']].to_bool,
        comments: worksheet.row(row)[@headers['COMMENTS ABOUT RESTRICTIONS']],
        preservation_filename: worksheet.row(row)[@headers['PRESERVATION FILENAME']],
        preservation_file_location: worksheet.row(row)[@headers['PRESERVATION FILE LOCATION']],
        online_url: check_url(worksheet.row(row)[@headers['DIRECT URL TO FILE']]),
        # if worksheet.row(row)[@headers['DIRECT URL TO FILE']].start_with?('http')
        #   response: Net::HTTP.get_response(uri).code
        # end
      }

  end


end

def parse_manifest(file)
  xlsx = Roo::Spreadsheet.open(file)
  @filename = filename(xlsx)
  parse_grant_info(xlsx)
  parse_url_info(xlsx)


end
