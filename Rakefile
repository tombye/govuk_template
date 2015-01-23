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

  desc "Build and release gem to gemfury if version has been updated"
  task :and_release_if_updated => :build do
    p = GemPublisher::Publisher.new('govuk_template.gemspec')
    if p.version_released?
      puts "govuk_template-#{GovukTemplate::VERSION} already released.  Not pushing."
    else
      puts "Pushing govuk_template-#{GovukTemplate::VERSION} to gemfury"
      p.pusher.push "pkg/govuk_template-#{GovukTemplate::VERSION}.gem", :rubygems
      p.git_remote.add_tag "v#{GovukTemplate::VERSION}"
      puts "Done."

      require 'publisher/docs_publisher'
      q = Publisher::DocsPublisher.new
      puts "Pushing docs #{GovukTemplate::VERSION} to git repo"
      q.publish
      puts "Done."
    end

    require 'publisher/release_publisher'
    q = Publisher::ReleasePublisher.new
    if q.version_released?
      puts "Github release v#{GovukTemplate::VERSION} already released. Not pushing."
    else
      puts "Pushing Github release v#{GovukTemplate::VERSION}"
      q.publish
    end

    require 'publisher/play_publisher'
    q = Publisher::PlayPublisher.new
    if q.version_released?
      puts "govuk_template_play #{GovukTemplate::VERSION} already released. Not pushing."
    else
      puts "Pushing govuk_template_play #{GovukTemplate::VERSION} to git repo"
      q.publish
    end

    require 'publisher/mustache_publisher'
    q = Publisher::MustachePublisher.new
    if q.version_released?
      puts "govuk_template_mustache #{GovukTemplate::VERSION} already released. Not pushing."
    else
      puts "Pushing govuk_template_mustache #{GovukTemplate::VERSION} to git repo"
      q.publish
    end

    require 'publisher/ejs_publisher'
    q = Publisher::EJSPublisher.new
    if q.version_released?
      puts "govuk_template_ejs #{GovukTemplate::VERSION} already released. Not pushing."
    else
      puts "Pushing govuk_template_ejs #{GovukTemplate::VERSION} to git repo"
      q.publish
    end
  end
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :spec => :compile
task :default => :spec
