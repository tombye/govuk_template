$:.unshift File.expand_path('../lib', __FILE__)
$:.unshift File.expand_path('../build_tools', __FILE__)
require "govuk_template/version"
require "gem_publisher"

desc "Compile template and assets from ./source into ./app"
task :compile do
  require 'compiler/asset_compiler'
  puts "Compiling assets and templates into ./app"
  Compiler::AssetCompiler.compile
end

desc "Build both gem and tar version"
task :build => ["build:gsp"]

namespace :build do
  desc "Build gsp_govuk_template-#{GovukTemplate::VERSION} into the pkg directory"
  task :gsp => :compile do
    puts "Building pkg/gsp_govuk_template-#{GovukTemplate::VERSION}"
    require 'packager/gsp_packager'
    Packager::GSPPackager.build
  end

  desc "Build and release if version has been updated"
  task :and_release_if_updated => :build do
    require 'publisher/release_publisher'
    q = Publisher::ReleasePublisher.new
    if q.version_released?
      puts "Github release v#{GovukTemplate::VERSION} already released. Not pushing."
    else
      puts "Pushing Github release v#{GovukTemplate::VERSION}"
      q.publish
    end
  end
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :spec => :compile
task :default => :spec
