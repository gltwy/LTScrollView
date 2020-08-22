
Pod::Spec.new do |s|
  s.name             = 'LTScrollView'
  s.version          = '0.3.0'
  s.summary          = 'LTScrollView'

  s.description      = <<-DESC
TODO: ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC / Swift，实现原理：http://blog.csdn.net/glt_code/article/details/78576628
                       DESC

  s.homepage         = 'https://github.com/gltwy/LTScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1282990794@qq.com' => '1282990794@qq.com' }
  s.source           = { :git => 'https://github.com/gltwy/LTScrollView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'Example/LTScrollView/Lib/**/*'
end
