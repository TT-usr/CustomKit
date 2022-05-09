#
#  Be sure to run `pod spec lint CMDBManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CMTools"
  spec.version      = "0.0.1"
  spec.summary      = "CMTools"
  spec.description  = <<-DESC
  CMTools
                   DESC
  spec.homepage     = "https://github.com/TT-usr/CustomKit"
  spec.license      = "MIT"
  spec.authors      = { 
    '姚天成' => 'ytc19930125@gmail.com'
  }
  spec.platform     = :ios, "10.0"
  spec.source       = { 
    :git => "https://github.com/TT-usr/CustomKit",
    :tag => "#{spec.version}" 
  }
  spec.requires_arc = true
  spec.swift_versions = ['4.2', '5.0', '5.1', '5.2', '5.3']
  spec.source_files = "CustomKit/Classes/Tools/**/*.{h,m,swift}"
  spec.module_name = "#{spec.name}"
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

end
