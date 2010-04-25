require File.dirname(__FILE__) + "/spec_helper"

describe NameMarker::Html do
  before(:all) do
    @html1 = '<html>hi</html>'
    @html2 = '<html><head></head><body></body></html>'
    @html3 = '<html><a href="abc">a</a><img src="/abc"/><form action="http://example.com/action"></form>'
    @url1 = "http://example.com/pages/3.html"
    @url2 = "http://example.com"
  end

  describe "#html" do
    it "should return html back" do
      h = NameMarker::Html.new(@html1, @url1)
      h.html.should == @html1
    end

    it "should return fixed html if there was no html tag" do
      h = NameMarker::Html.new("hi", @url1)
      h.html.should == "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body><p>hi</p></body></html>\n"
    end
  end

  describe "#html_clean" do
    it "should return cleaned up html back" do
      h = NameMarker::Html.new(@html1, @url1)
      h.html_clean.should == "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body><p>hi</p></body></html>\n"
    end
  end

  describe "#fix_links" do
    it "should append head with base tag" do
      h = NameMarker::Html.new(@html2, @url1)
      h.fix_links.html.should == "<html><head><base href=\"http://example.com\" /></head><body></body></html>"
      h = NameMarker::Html.new(@html1, @url1)
      h.fix_links.html.should == "<html><head><base href=\"http://example.com\" /></head>hi</html>"
      h = NameMarker::Html.new(@html3, @url1)
      h.fix_links.html.should == "<html><head><base href=\"http://example.com\" /></head><a href=\"/pages/abc\">a</a><img src=\"/abc\"/><form action=\"http://example.com/action\"></form>"
    end

    it "should not change base tag if it exists already" do
      html_with_base = "<html><head><base href='http://example.com'/></head></html>"
      h = NameMarker::Html.new(html_with_base, @url1)
      h.fix_links.html.should == html_with_base
    end

    it "it should operate with urls without paths" do 
      h = NameMarker::Html.new(@html3, @url2)
      h.fix_links.html.should == "<html><head><base href=\"http://example.com\" /></head><a href=\"/pages/abc\">a</a><img src=\"/abc\"/><form action=\"http://example.com/action\"></form>"
    end
  end
end
