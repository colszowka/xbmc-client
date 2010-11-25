# Sets up the environment for all examples by loading the library and configuring it
require 'pp'
require File.join(File.dirname(__FILE__), '../lib', 'xbmc-client')

Xbmc.base_uri "http://localhost:8435"
Xbmc.basic_auth "xbmc", "xbmc"

Xbmc.load_api!