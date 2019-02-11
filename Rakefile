# frozen_string_literal: true

require_relative 'lib/utils.rb'

DATA_DIR = '_data'.freeze

namespace :reports do
  desc 'Generate a preliminary report of submitted resources'
  task all: %(manifests)

  desc 'Check manifiests in DATA_DIR'
  task :manifests do
    Dir["#{DATA_DIR}/*.xlsx"].each do |file|
      parse_manifest(file)

      contents = render_erb('templates/report.html.erb')
      write_file(@filename, contents)
    end
  end
end
