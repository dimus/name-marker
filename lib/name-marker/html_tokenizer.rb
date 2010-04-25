class NameMarker
  class HtmlTokenizer
    def initialize(html_text, taxon_finder_stop_keyword = 'tf_stop')
      @html = html_text
      @taxon_finder_stop_array = [taxon_finder_stop_keyword, -1]
      @tokenized_html = nil
    end

    def tokenize
      tokens = html_to_words_and_tags
      @tokenized_html = remove_tags(tokens)
    end

    def tokens
      @tokenized_html ||= tokenize
    end
    
    def html
      @html
    end
    
  private

    def remove_tags(tokens)
      res = []
      within_tag = false
      tokens.each do |t|
        if within_tag 
          if t[0].match(/^(.*)>\z/m) # ...tag>
            res = tag2element(Regexp.last_match[1], res)
            within_tag = false
          end
        elsif t[0].match(/^<([\/\?]?.*[a-z0-9-][\/\?]?)>\z/im) # <tag>
          res = tag2element(Regexp.last_match[1], res)
        elsif t[0].match(/^<([?a-z0-9!].*)\z/m) # <tag ...
          res = tag2element(Regexp.last_match[1], res)
          within_tag = true
        else
          res << t
        end
      end
      res << @taxon_finder_stop_array
    end

    def tag2element(tag, array)
      tag = tag.downcase.gsub(/^\//, '')
      array << @taxon_finder_stop_array if ["p","td", "tr", "table", "hr"].include? tag  
      array
    end

    #splits html into tokenized elements
    def html_to_words_and_tags
      tokens = []
      n = 0
      html_split(@html.strip).each do |word, offset|
        if word == "<" 
          tokens[n] = Token.new(offset, word)
        elsif word.match(/^[>.;\s]$/)
          tokens[n-1].merge Token.new(offset, word)
        else
          token = Token.new(offset, word)
          tokens[n] ? tokens[n].merge(token) : tokens[n] = token
          n += 1
        end
      end
      tokens.map { |t| [t.value.strip, t.offset] }
    end

    def html_split(str)
      delimiters = /(&nbsp;|[\s<>;.])/i
      data = []
      offset = 0
      i = str.index(delimiters)
      while i do
        if i > 0
          value = str[0...i]
          data << [value, offset] 
          offset += i
        end
        delimiter = str[i..i] == '&' ? str[i..i+6] : str[i..i]
        data << [delimiter, offset]
        offset += delimiter.size
        str = str[(i + delimiter.size)..-1]
        i = str.index(delimiters)
      end
      data
    end

    class Token < Struct.new(:offset, :value)
      def merge(token)
        value << token.value
      end
    end

  end
end
