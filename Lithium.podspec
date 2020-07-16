Pod::Spec.new do |s|

  s.name         = "Lithium"
  s.version      = "9.0.5"
  s.author       = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "http://www.e-sites.nl"
  s.summary      = "_The_ E-sites logging framework"
  s.source       = { :git => "https://github.com/e-sites/Lithium.git", :tag => "v#{s.version}" }
  s.source_files  = "Sources/**/*.{h,swift}"
  s.public_header_files  = "Sources/Lithium.h"
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.dependency 'Logging'
  s.swift_versions = [ '5.0', '5.1', '5.2' ]
end
