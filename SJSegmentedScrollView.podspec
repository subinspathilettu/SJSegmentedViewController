Pod::Spec.new do |spec|
spec.name                   = 'SJSegmentedScrollView'
spec.version                = '1.0.0'
spec.license                = { :type => 'MIT', :file => 'LICENSE' }
spec.homepage               = 'https://github.com/subinspathilettu/SJSegmentedViewController'
spec.author                 = { 'Subins Jose' => 'subinsjose@gmail.com' }
spec.summary                = 'Custom segmented header scrollview controller.'
spec.source                 = { :git => 'https://github.com/subinspathilettu/SJSegmentedViewController.git', :tag => 'v1.0.0' }
spec.source_files           = 'SJSegmentedScrollView/Classes/**/*.swift'
spec.ios.deployment_target  = '8.0'
end