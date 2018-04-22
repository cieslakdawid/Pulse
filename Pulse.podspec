#
# Be sure to run `pod lib lint Pulse.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'Pulse'
    s.version          = '0.1.3'
    s.summary          = 'Pulse is a powerful tool for creating smooth, value-based animations from your real-time dataset. It\'s based on concept of PID Controller'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = "Pulse is a powerful tool for creating smooth, value-based animations when your data set is not continuous or it needs additional interpolation. Especially useful when working with values provided in real-time like - gyroscope, force touch or gestures. It's based on the concept of PID Controller - control loop feedback mechanism."
    
    s.homepage         = 'https://github.com/cieslakdawid/Pulse'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'cieslakdawid' => 'cieslakdawid@gmail.com' }
    s.source           = { :git => 'https://github.com/cieslakdawid/Pulse.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '10.3'
    
    s.swift_version = '4.1'
    s.source_files = 'Pulse/Classes/**/*'
    
    s.resource_bundles = {
        'Pulse' => ['Pulse/Assets/*.xcassets']
    }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
