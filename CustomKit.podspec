#
# Be sure to run `pod lib lint CustomKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CustomKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CustomKit.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/TT-usr/CustomKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yao.tiancheng' => 'ytc19930125@gmail.com' }
  s.source           = { :git => 'https://github.com/TT-usr/CustomKit.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  
#  s.source_files = 'CustomKit/Classes/**/*'
  
  s.subspec 'Header' do |s|
    s.name                = 'Header'
    s.framework           = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/CMFoundation.h'
  end
  
  s.subspec 'NSObject' do |s|
    s.name                = 'NSObject'
    s.framework           = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSObject/**/*.{h,m}'
    s.private_header_files = 'CustomKit/Classes/Foundation/NSObject/NSObject+MFDictionaryAdapterPrivate.h'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSString' do |s|
    s.name                = 'NSString'
    s.framework           = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSString/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
    s.dependency 'CustomKit/NSDictionary'
  end
  
  s.subspec 'NSArray' do |s|
    s.name                = 'NSArray'
    s.framework           = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSArray/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSDictionary' do |s|
    s.name                = 'NSDictionary'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSDictionary/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSSet' do |s|
    s.name                = 'NSSet'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSSet/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSData' do |s|
    s.name                = 'NSData'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSData/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSDate' do |s|
    s.name                = 'NSDate'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSDate/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSFileManager' do |s|
    s.name                = 'NSFileManager'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSFileManager/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'JSON' do |s|
    s.name                = 'JSON'
    s.frameworks          = 'UIKit', 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/JSON/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'NSNull' do |s|
    s.name                = 'NSNull'
    s.frameworks          = 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/NSNull/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'Invocation' do |s|
    s.name                = 'Invocation'
    s.frameworks          = 'Foundation'
    s.source_files        = 'CustomKit/Classes/Foundation/Invocation/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
  
  s.subspec 'Device' do |s|
    s.name                = 'Device'
    s.frameworks          = 'UIKit'
    s.source_files        = 'CustomKit/Classes/Foundation/Device/**/*.{h,m}'
    s.dependency 'CustomKit/Header'
  end
end
