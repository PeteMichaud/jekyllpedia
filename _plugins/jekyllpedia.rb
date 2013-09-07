# Author: Pete Michaud
# Site: http://petemichaud.github.io
# Plugin Source: http://github.com/PeteMichaud/jekyllpedia
# Plugin License: MIT

module Jekyll

  class Jekyllpedia < Transformer

    WIKI_REGEX = /\[\[(?<title>[^\]]+)\]\]/i

    def initialize(context)
      @context = context
      @site = @context.registers[:site]
    end

    def matches(file_with_path)

      # file_with_path => "/path/to/file-name.md"

      # maybe check the extension, like a converter

      # or compare the filepath with config options
      # if you want to limit the transformation to
      # certain directories

      # you could even search the file itself for
      # certain keywords or front matter

      # in this case, I'm just going to convert all

      true
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

  end
end