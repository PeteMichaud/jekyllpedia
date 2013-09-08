# Author: Pete Michaud
# Site: http://petemichaud.github.io
# Plugin Source: http://github.com/PeteMichaud/jekyllpedia
# Plugin License: MIT

module Jekyll

  class Jekyllpedia < Transformer

    WIKI_REGEX = /\[\[(?<title>[^\]]+)\]\]/i
    DIR_DELIMIT = /\A[\/]+|[\/]+\Z/
    def dir_regex(d)
      /(?:\A|\/)#{d}(?:\/|\Z)/i
    end

    def initialize(context)
      default_opts = {
          extensions: nil,
          directories: nil,
          #generate_missing: false
      }

      @context = context
      @site = @context.registers[:site]
      @config = default_opts.merge(@context.config[:wiki])
    end

    def matches(page)
      matches_extension(page.ext) && matches_directory(page.path)
    end

    def transform(content)
      content.gsub WIKI_REGEX do |_|
        title = $~[:title]
        path = get_path_from_title(title)
        render_anchor(title, path)
      end
    end

    private

    def get_path_from_title(title)
      @site.pages.select { |page| page.name == title }
    end

    def render_anchor(title, path)
      return "#{title}[?]" unless path.is_a? String
      "<a href='#{path}'>#{title}</a>"
    end

    def matches_extension(ext)
        (@config[:extensions] || [ext]).include?(ext)
    end

    def matches_directory(file_path)
      dir = File.dirname(file_path)
      (@config[:directories] || [dir_strip(dir)]).select do |d|
        dir =~ dir_regex(d)
      end.size > 0
    end

    def dir_strip(dir)
      dir.gsub(DIR_DELIMIT, '')
    end
  end
end