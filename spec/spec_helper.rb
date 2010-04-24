$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'name-marker'
require 'spec'
require 'spec/autorun'
require 'ruby-debug'

Spec::Runner.configure do |config|
  
end
