require 'erb'
require 'compiler/template_processor'

module Compiler
  class MustacheProcessor < TemplateProcessor

    def handle_yield(section = :layout)
      case section
      when :page_title
        "{{pageTitle}}"
      when :head
        "{{head}}"
      when :body_classes
        "{{bodyClasses}}"
      when :content
        "{{content}}"
      when :body_end
        "{{bodyEnd}}"
      else 
        ""
      end
    end

    def asset_path(file, optons={})
      return file if @is_stylesheet
      case File.extname(file)
      when '.css'
        "{{assetPath}}stylesheets/#{file}"
      when '.js'
        "{{assetPath}}javascripts/#{file}"
      else
        "{{assetPath}}images/#{file}"
      end
    end

    def content_for?(*args)
      [:page_title, :content, :body_classes].include? args[0]
    end
  end
end
