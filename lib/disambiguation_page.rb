module Jekyll
  class DisambiguationPage < Page

    def initialize(site, base, pages)

      @site = site
      @base = File.join(base, 'disambiguation')
      @name = File.basename(pages.first.path)

      self.data['title'] = pages.first.name
      self.data['pages'] = pages
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'disambiguation.html')

    end

  end
end