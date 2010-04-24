module NameMarker
  # Allows to modify HTML code
  class Html
    def initialize(html_text, url)
      @html = fix_html(html_text)
      @url = url
      @url_domain = @url.match(/^(.*:\/\/[^\/]+)/)[1]
    end
    
    # returns html in cleaned and modified state
    def html
      @html
    end

    def html_clean
      Nokogiri::HTML(@html).to_html
    end

    def fix_links
      append_head(%Q|<base href="#{@url_domain}" />|) 
      self
    end
    
    private

    def fix_html(html_text)
      html_text.index("<html>") ? html_text : Nokogiri::HTML(html_text).to_html 
    end

    def append_head(content)
      @html.index("<head>") ? @html.sub!("<head>", "<head>#{content}") : @html.sub!("<html>", "<html><head>#{content}</head>")
    end
  end
end
