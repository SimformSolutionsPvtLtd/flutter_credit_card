#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_credit_card.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_credit_card'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Credit Card Widget Plugin Package'
  s.description      = <<-DESC
A Credit Card widget package with support of entering card details, and animations like card flip
and float.
                       DESC
  s.homepage         = 'https://github.com/simformsolutions/flutter_credit_card'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Simform Solutions' => 'developer@simform.com' }
  s.source           = { :http => 'https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/tree/master' }
  s.source_files = 'flutter_credit_card/Sources/flutter_credit_card/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
