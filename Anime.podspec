Pod::Spec.new do |s|
  s.name             = 'Anime'
  s.version          = '0.1.0'
  s.summary          = 'UIView animation from the Far East.'
  s.description      = 'Simple UIView animation library, but not any simpler.'
  s.homepage         = 'https://github.com/hlfcoding/Anime'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peng Wang' => 'peng@pengxwang.com' }
  s.source           = { :git => 'https://github.com/hlfcoding/Anime.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hlfcoding'

  s.ios.deployment_target = '10.0'
  s.source_files = 'Anime/Classes/**/*'
  s.frameworks = 'UIKit'
end
