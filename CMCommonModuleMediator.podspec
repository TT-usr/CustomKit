#
# Be sure to run `pod lib lint MBCommonModuleMediator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CMCommonModuleMediator'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MBCommonModuleMediator.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/TT-usr/CustomKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '姚天成' => 'ytc19930125@gmail.com' }
  s.source           = { :git => 'https://github.com/TT-usr/CustomKit.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  
  s.source_files = 'CustomKit/Classes/ModuleMediator/**/*'
  
  s.dependency 'CustomKit'
  s.dependency 'Aspects'
end
