class NameMarker
  # Allows to modify HTML code
  class Html
    def initialize(html_text, url)
      @html = fix_html(html_text)
      @url = url
      @url_domain = @url.match(/^(.*:\/\/[^\/]+)/)[1]
      @url_base_path = get_url_base_path
    end
    
    # returns current state of html text
    def html
      @html
    end

    #returns cleaned up html text
    def html_clean
      Nokogiri::HTML(@html).to_html
    end

    #changes base of a document and fixes local links
    def fix_links
      append_head(%Q|<base href="#{@url_domain}" />|) unless @html.index("<base ")
      update_rel_links
      self
    end
    
    private
    
    def fix_html(html_text)
      html_text.index("<html>") ? html_text : Nokogiri::HTML(html_text).to_html 
    end

    def append_head(content)
      @html.index("<head>") ? @html.sub!("<head>", "<head>#{content}") : @html.sub!("<html>", "<html><head>#{content}</head>")
    end

    def get_url_base_path
      uri = URI.parse(@url)
      path = (uri.path.split('?')[0].to_s + 'abc').split("/")[0...-1]
      path.join("/") + "/"
    end

    def update_rel_links
      @html.gsub!(/http:/, "/http:")
      @html.gsub!(/\s(href|src|action|background)\s*=\s*['"]([\w].*?)['"]/, " \\1=\"#{@url_base_path}\\2\"" )
      @html.gsub!(/\/http:/, "http:")
    end
  end
end
