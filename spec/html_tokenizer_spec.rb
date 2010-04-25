require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe NameMarker::HtmlTokenizer do
  describe "#tokenize" do
    it "should tokenize html-like strings" do
      html = "<hello>, ; djdkdj. djdJlkjlkj. </slslk>&nbsp;"
      ht = NameMarker::HtmlTokenizer.new(html)
      ht.tokenize.should == [[", ;", 7], ["djdkdj.", 11], ["djdJlkjlkj.", 19], ["&nbsp;", 39], ["tf_stop", -1]]
      html = '<?xml version ="0.1"?><html></body><a href ="http://example.com">my pictre</a> this one without tag <img src="my-pix"/> <div style = "color:red; width:16px"> something else </body></html>'
      ht = NameMarker::HtmlTokenizer.new(html)
      ht.tokenize.should == [["my", 65], ["pictre", 68], ["this", 79], ["one", 84], ["without", 88], ["tag", 96], ["something", 158], ["else", 168], ["tf_stop", -1]]
    end
  end
end
