#
# Be sure to run `pod lib lint MJDevice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJDevice'
  s.version          = '0.1.2'
  s.summary          = 'MJDevice is use to get device info.'

  s.homepage         = 'https://github.com/Musjoy/MJDevice'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Raymomd' => 'Ray.musjoy@gmail.com' }
  s.source           = { :git => 'https://github.com/Musjoy/MJDevice.git', :tag => "v-#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MJDevice/Classes/**/*'
  
  s.user_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'MODULE_DEVICE'
  }
  s.dependency 'ModuleCapability'
  s.prefix_header_contents = '#import "ModuleCapability.h"'

end
