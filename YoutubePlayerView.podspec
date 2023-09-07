
Pod::Spec.new do |s|
  s.name             = 'YoutubePlayerView'
  s.version          = '0.1.3'
  s.summary          = 'Play YouTube videos through a WKWebView'

  s.description      = <<-DESC
Bridge JavaScript with WKWebView to utilize the YouTube IFrame Player API for playing YouTube content.
                       DESC

  s.homepage         = 'https://github.com/pokeduck/YoutubePlayerView'
 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pokeduck' => 'pokeduck@github.com' }
  s.source           = { :git => 'https://github.com/pokeduck/YoutubePlayerView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://pokeduck@github.com'

  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'YoutubePlayerView/Classes/*.swift'
  
  s.frameworks = 'WebKit', 'UIKit'
end
