#
# Be sure to run `pod lib lint XAssets.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "XAssets"
  s.version          = "0.1.2"
  s.summary          = "Assets for iOS."
  s.description      = <<-DESC
                       Assets repo for iOS app.
                       DESC
  s.homepage         = "https://bitbucket.org/zenchat/xassets"
  s.license          = 'MIT'
  s.author           = { "Lance Zhu" => "lance.zhu@zenchatapp.com" }
  s.source           = { :git => "git@bitbucket.org:zenchat/xassets.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'XAssets' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
