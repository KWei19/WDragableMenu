#
#  Be sure to run `pod spec lint DragableCollectionMenu.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name                   = "WDragableMenu"
s.version                = "1.0.0"
s.summary                = "Provide function of Add Menu item, Delete Menu item, and Rearrange of position menu"
s.homepage               = 'https://github.com/KWei19/WDragableMenu.git'
s.license                = 'MIT'
s.author                 = { "KWei" => "wei_b_5@hotmail.com" }
s.ios.deployment_target  = '9.0'
s.source = {:git => 'https://github.com/KWei19/WDragableMenu.git', :tag => s.version}
s.source_files  = 'WDragableMenu/**/*.{h,m}'
s.resources = 'WDragableMenu/**/*.png'
s.requires_arc           = true
s.static_framework       = true

end
