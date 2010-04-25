# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless
   $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'nokogiri'
require 'uri'
require 'name-marker/html'


class NameMarker
  DELIMITERS = /(&nbsp;|[\s<>;.])/i
  TAG_TYPE = :tag
  WORD_TYPE = :word
  OTHER_TYPE = :other

  def initialize(html_text, opentag = nil, closetag = nil)
    
  end

  def self.untag_tokens
    ''
  end
  
  #splits html into tokenized elements
  def self.html_tokenize(str)
    tokens = []
    n = 0
    self.html_split(str.strip).each do |word, offset|
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
    tokens.map { |t| [t.offset, t.value] }
  end

private

  def self.html_split(str)
    data = []
    offset = 0
    i = str.index(DELIMITERS)
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
      i = str.index(DELIMITERS)
    end
    data
  end

  class Token < Struct.new(:offset, :value)
    def merge(token)
      value << token.value
    end
  end

end

