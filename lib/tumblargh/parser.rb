require 'treetop'
require 'open-uri'
require 'nokogiri'

module Tumblargh
  class ParserError < StandardError
  end

  class Parser
    grammar_file = File.join(File.dirname(__FILE__), 'grammar')

    if File.exists?("#{grammar_file}.rb")
      require "#{grammar_file}.rb"
    else
      Treetop.load("#{grammar_file}.treetop")
    end

    @@parser = TumblrParser.new

    def initialize(template=nil)
      self.file = template
    end

    attr_reader :file

    def file=(file)
      @file = file
      @html = nil
      @structure = nil
      @tree = nil
      @config = nil
    end

    def html=(html)
      self.file = nil
      @html = html
    end

    def html
      @html ||= open(@file).read
    end

    def tree
      @tree ||= parse
    end

    def options
      @options ||= extract_options
    end

    def to_s
      parse unless @structure
      @structure.to_s
    end

    private

    def parse
      @structure = @@parser.parse(html)

      if @structure.nil?
        raise ParserError, @@parser.failure_reason
      end

      @tree = @structure.to_tree
    end

    def extract_options
      opts = {}.with_indifferent_access

      doc = Nokogiri::HTML(html)
      doc.css('meta').each do |meta|
        next if !meta['name']
        meta_name = meta['name'].downcase
        type, variable = nil

        if meta_name.include?(':')
          type, variable = meta_name.split(':')
        else
          variable = meta_name
        end

        default = meta['content']

        default = case type
        when "if"
          default == "1"
        else
          default
        end

        if type
          opts[type] ||= {}
          opts[type][variable.gsub(/\s/, '')] = default
        else
          opts[variable.gsub(/\s/, '_')] = default
        end
      end

      opts
    end
  end
end
