# Author: Pete Michaud
# Site: http://petemichaud.github.io
# Plugin Source: http://github.com/PeteMichaud/jekyllpedia
# Plugin License: MIT

require 'lib/missing_page'
require 'lib/disambiguation_page'

module Jekyll

  class Jekyllpedia < Transformer

    WIKI_REGEX = /\[\[(?<title>[^\]\|]+)\|?(?<anchor>[^\]\|]+)?\]\]/i
    DIR_DELIMIT = /\A[\/]+|[\/]+\Z/
    def dir_regex(d)
      /(?:\A|\/)#{d}(?:\/|\Z)/i
    end

    def initialize(context)
      default_opts = {
          extensions: nil,
          directories: nil,
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
        matching_pages, title = get_page_from_title(title)
        anchor = $~[:anchor] || title
        render_anchor(anchor, matching_pages)
      end
    end

    private

    # Finds the page or pages that have the given title
    #
    # The title might be simple like "Page Title", in
    # which case this method looks through all pages.
    # The title might also be qualified like
    # "category::subcategory::Page Title". In that
    # case, this method ensures that it only returns
    # pages under the "category" and "subcategory"
    # folders
    #
    def get_page_from_title(title)
      qualified_title = title.split('::')

      return @site.pages.select { |page|
        page.name == qualified_title.last && under_directory(page.path, qualified_title[0...-1])
      }, qualified_title.last
    end

    def render_anchor(title, pages)
      case pages.size
        when 1
          "<a href='#{pages.first.url}'>#{title}</a>"
        when 0
          "<a href='#{generate_missing_page(title)}'>#{title}</a>"
        else
          "<a href='#{generate_page(pages)}'>#{title}</a>"
      end
      return "#{title}[?]" unless path.is_a? String
      "<a href='#{path}'>#{title}</a>"
    end

    def generate_missing_page(title)
      missing_page = MissingPage.new(site, site.source, title)
      @site.pages << missing_page
      puts "Missing Page: [#{title}](#{missing_page.url})"
      missing_page.url
    end

    def generate_disambiguation_page(pages)
      dis_page = DisambiguationPage.new(site, site.source, pages)
      @site.pages << dis_page
      dis_page.url
    end

    def matches_extension(ext)
        (@config[:extensions] || [ext]).include?(ext)
    end

    def matches_directory(file_path)
      dir = File.dirname(file_path)
      directory_array = @config[:directories] || [dir_strip(dir)]
      directory_array.select do |d|
        dir =~ dir_regex(d)
      end.size > 0
    end

    # Takes a file path and an array of directories, and determines
    # if the file is "loosely" under those directories.
    # For example:
    #
    # under_directory('path/to/file.md', %w(path to)) #=> true
    # under_directory('path/to/file.md', %w(other_path)) #=> false
    # under_directory('path/leading/to/file.md', %w(leading)) #=> true
    # under_directory('path/leading/to/file.md', %w(path to)) #=> true
    # under_directory('path/leading/to/file.md', %w(to path)) #=> false
    #
    def under_directory(file_path, directory_array)
      dir = File.dirname(file_path)

      directory_array.each do |d|

        match = dir_regex(d).match(dir)

        if match
          dir = dir[dir.index(match.to_s)+match.to_s.size..-1]
        else
          return false
        end
      end

      return true
    end

    def dir_strip(dir)
      dir.gsub(DIR_DELIMIT, '')
    end
  end
end