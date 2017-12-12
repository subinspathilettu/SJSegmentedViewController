Pod::Spec.new do |spec|
spec.platform               = :ios
spec.ios.deployment_target  = '9.0'
spec.name                   = 'SJSegmentedScrollView'
spec.summary                = 'Custom segmented header scrollview controller.'
spec.requires_arc           = true
spec.version                = '1.3.9'
spec.license                = { :type => 'MIT', :file => 'LICENSE' }
spec.homepage               = 'https://github.com/subinspathilettu/SJSegmentedViewController'
spec.author                 = { 'Subins Jose' => 'subinsjose@gmail.com' }
spec.source                 = { :git => 'https://github.com/subinspathilettu/SJSegmentedViewController.git', :tag => 'v1.3.9' }
spec.source_files           = 'SJSegmentedScrollView/Classes/*.{swift}'
spec.social_media_url       = 'https://twitter.com/subinsjose'
spec.framework              = "UIKit"
end
