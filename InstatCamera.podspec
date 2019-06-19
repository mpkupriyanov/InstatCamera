#
# Be sure to run `pod lib lint InstatCamera.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InstatCamera'
  s.version          = '0.1.0'
  s.summary          = 'InstatCamera - video recording with seamless chunks by 5 seconds'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Video recording with seamless chunks by 5 seconds
                       DESC

  s.homepage         = 'https://github.com/mpkupriyanov/InstatCamera'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mikhail Kupriyanov' => 'mpkupriyanov@gmail.com' }
  s.source           = { :git => 'https://github.com/mpkupriyanov/InstatCamera.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'InstatCamera/Classes/**/*'
  
  # s.resource_bundles = {
  #   'InstatCamera' => ['InstatCamera/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
