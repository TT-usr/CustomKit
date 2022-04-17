#
#  Be sure to run `pod spec lint CMSBaseFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CMSBaseFoundation"
  spec.version      = "0.0.13"
  spec.summary      = "Foundation层"
  spec.description  = <<-DESC
    Foundation基础库、常用扩展
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
  spec.prefix_header_file = false
  spec.swift_versions = ['4.2', '5.0', '5.1', '5.2', '5.3']
  spec.source_files = "CustomKit/Classes/SwiftFoundation/**/*.{h,m,swift}"
  spec.module_name = "#{spec.name}"
  spec.header_dir = "Source"
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

end
