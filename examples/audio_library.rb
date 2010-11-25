require 'pp'
require './' + File.join(File.dirname(__FILE__), '../lib', 'xbmc-client')

Xbmc.base_uri "http://localhost:8435"
Xbmc.basic_auth "xbmc", "xbmc"

Xbmc.load_api!

pp Xbmc::AudioLibrary.get_artists
puts "="*60
pp Xbmc::AudioLibrary.get_albums(:artistid => Xbmc::AudioLibrary.get_artists.first[:artistid])
puts "="*60
pp Xbmc::AudioLibrary.get_songs(:albumid => 1)

pp Xbmc::AudioPlayer.play_pause
