require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NameMarker" do
  describe "#untag_tokens" do
    it "should clean tokens from elements" do
      tokens = [[0, "<?xml "], [6, "version "], [14, "=\"0."], [18, "1\"?>"], [22, "<html>"], [28, "</body>"], [35, "<a "], [38, "href "], [43, "=\"http://example."], [60, "com\">"], [65, "my "], [68, "pictre"], [74, "</a> "], [79, "this "], [84, "one "], [88, "without "], [96, "tag "], [100, "<img "], [105, "src=\"my-pix\"/> "], [120, "<div "], [125, "style "], [131, "= "], [133, "\"color:red; "], [145, "width:16px\"> "], [158, "something "], [168, "else "], [173, "</body>"], [180, "</html>"]]
      NameMarker.untag_tokens.should == ''
    end
  end
  describe "#html_tokenize" do
    it "should tokenize html-like strings" do
      html = "<hello>, ; djdkdj. djdJlkjlkj. </slslk>&nbsp;"
      n = NameMarker.html_tokenize(html).should == [[0, "<hello>"], [7, ", ; "], [11, "djdkdj. "], [19, "djdJlkjlkj. "], [31, "</slslk>"], [39, "&nbsp;"]]
      html = '<?xml version ="0.1"?><html></body><a href ="http://example.com">my pictre</a> this one without tag <img src="my-pix"/> <div style = "color:red; width:16px"> something else </body></html>'
      n = NameMarker.html_tokenize(html).should == [[0, "<?xml "], [6, "version "], [14, "=\"0."], [18, "1\"?>"], [22, "<html>"], [28, "</body>"], [35, "<a "], [38, "href "], [43, "=\"http://example."], [60, "com\">"], [65, "my "], [68, "pictre"], [74, "</a> "], [79, "this "], [84, "one "], [88, "without "], [96, "tag "], [100, "<img "], [105, "src=\"my-pix\"/> "], [120, "<div "], [125, "style "], [131, "= "], [133, "\"color:red; "], [145, "width:16px\"> "], [158, "something "], [168, "else "], [173, "</body>"], [180, "</html>"]]
    end
  end
end
