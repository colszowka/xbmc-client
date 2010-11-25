# Some example calls for interacting with the Audio Library in XBMC

require "./" + File.join(File.dirname(__FILE__), 'example_environment')

pp Xbmc::AudioLibrary.get_artists
puts "="*60
pp Xbmc::AudioLibrary.get_albums(:artistid => Xbmc::AudioLibrary.get_artists.first[:artistid])
puts "="*60
pp Xbmc::AudioLibrary.get_songs(:albumid => 1)

pp Xbmc::AudioPlayer.play_pause