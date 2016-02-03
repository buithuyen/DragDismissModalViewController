#
#  Be sure to run `pod spec lint DragDismissModalViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "DragDismissModalViewController"
  s.version      = "0.0.2"
  s.summary      = "Drag to dismiss modal viewController"
  s.description      = <<-DESC
                        Custom TransitionViewController
                       DESC
  s.homepage     = "https://github.com/buithuyen/DragDismissModalViewController"
  s.license      = 'MIT'
  s.author       = { "ThuyenBV" => "buithuyen48dt@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/buithuyen/DragDismissModalViewController.git", :tag => s.version.to_s }
  s.source_files  = 'TransitionViewController/SourceFile/*.{h,m}'
  s.requires_arc = true
end
