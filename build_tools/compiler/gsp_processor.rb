require 'erb'
require_relative 'template_processor'

module Compiler
  class GSPProcessor < TemplateProcessor

    @@yield_hash = {
      after_header: "<g:render template='/common/afterHeader'/>",
      body_classes: "${bodyClassed?:''}",
      body_end: "<g:render template='/common/javascripts'/>\n    <r:layoutResources />",
      content: "<g:render template='/common/content'/>",
      cookie_message: "<g:render template='/common/cookieMessage'/>",
      footer_support_links: "<g:render template='/common/footerSupportLinks'/>",
      footer_top: "<g:render template='/common/footerTop'/>",
      head: "<g:render template='/common/stylesheets'/>\n    <g:layoutHead/>\n    <r:layoutResources />",
      header_class: "with-proposition",
      html_lang: "<g:htmlLang default='en'/>",
      inside_header: "${insideHeader}",
      page_title: "<g:layoutTitle default='GOV.UK - The best place to find government services and information'/>",
      proposition_header: "<g:render template='/common/propositionHeader'/>"
    }

    def render_erb
      f=File.read(@file)
      f.gsub!(/<head>/, "<head>\n    <g:set var='entityName' value='Supplier' />") unless @is_stylesheet
      ERB.new(f).result(binding)
    end

    def handle_yield(section = :layout)
      @@yield_hash[section]
    end

    def asset_path(file, options={})
      query_string = GovukTemplate::VERSION
      return "#{file}?#{query_string}" if @is_stylesheet
      case File.extname(file)
      when '.css'
        "${resource(dir: 'css', file: '#{file}')}"
      when '.js'
        "${resource(dir: 'js', file: '#{file}')}"
      else
        "${resource(dir: 'img', file: '#{file}')}"
      end
    end

    def content_for?(*args)
      @@yield_hash.include? args[0]
    end
  end
end
