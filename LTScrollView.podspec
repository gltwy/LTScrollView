#
# Be sure to run `pod lib lint LTScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LTScrollView'
  s.version          = '0.1.3'
  s.summary          = 'LTScrollView'

  s.description      = <<-DESC
TODO: Add long description of the pod here.A short description of LTScrollView.
                       DESC

  s.homepage         = 'https://github.com/gltwy/LTScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1282990794@qq.com' => '1282990794@qq.com' }
  s.source           = { :git => 'https://github.com/gltwy/LTScrollView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Example/LTScrollView/Lib/**/*'
end
