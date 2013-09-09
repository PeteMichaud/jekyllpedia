module Jekyll
  class MissingPage < Page

    def initialize(site, base, title)

      @site = site
      @base = File.join(base, 'missing')
      @name = fileize(title)

      self.data['title'] = title
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'missing.html')

    end

    private

    def fileize(title)
      title.strip do |name|
        # NOTE: File.basename doesn't work right with Windows paths on Unix
        # get only the filename, not the whole path
        name.gsub!(/^.*(\\|\/)/, '')

        # Strip out the non-ascii character
        name.gsub!(/[^0-9A-Za-z.\-]/, '-')
      end + ".html"
    end
  end
end