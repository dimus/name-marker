require File.dirname(__FILE__) + "/spec_helper"

describe NameMarker::Html do
  before(:all) do
    @html1 = '<html>hi</html>'
    @html2 = '<html><head></head><body></body></html>'
    @url1 = "http://example.com/pages/3.html"
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
    end
  end
end
