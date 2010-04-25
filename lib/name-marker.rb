# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless
   $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'nokogiri'
require 'socket'
require 'rest_client'
require 'uri'
require 'name-marker/html'
require 'name-marker/html_tokenizer'


class NameMarker

  # initializer
  def initialize(url, opts = {})
    @url = url
    @opts = { :open_tag => '<span class="nm_name_open"/>', 
              :close_tag => '<span class="nm_name_close"/>', 
              :fix_links => true
            }.merge(opts)
    @taxon_finder = initialize_taxon_finder
  end

  def mark_names
    html = RestClient.get(params[:url]).body
    html_obj = NameMarker::Html.new(html, params[:url])
    html_obj.fix_links if @opts[:fix_links]
    @html_in = html_obj.html
    @tokens = NameMarker::HtmlTokenizer.new(html_obj.html).tokens
  end

  private
  
  def find_and_markup_names
    @html_out = @html_in
    @offset = 0
    parameters = {}
    name_start_index = name_last_index = word_list_matches = 0
    @tokens.each do |word, offset|
      parameters[:word] = word
      parameters = @taxon_finder.check_word(parameters)
    end
  end

  def initialize_taxon_finder
    
  end
end
