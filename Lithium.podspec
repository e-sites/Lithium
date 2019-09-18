Pod::Spec.new do |s|

  s.name         = "Lithium"
  s.version      = "8.0.0"
  s.author       = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "http://www.e-sites.nl"
  s.summary      = "_The_ E-sites logging framework"
  s.source       = { :git => "https://github.com/e-sites/Lithium.git", :tag => "v#{s.version}" }
  s.source_files  = "Sources/Lithium.h"
  s.public_header_files  = "Sources/Lithium.h"
  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files  = "Sources/Core/**/*.*"
  end

  s.subspec 'Dysprosium' do |ss|
    ss.dependency 'Lithium/Core'
    ss.dependency 'Dysprosium'
    ss.source_files  = "Sources/Lithium/Dysprosium/**/*.*"
  end

  s.subspec 'Papertrail' do |ss|
    ss.dependency 'CocoaAsyncSocket', '~> 7.5'
    ss.source_files  = "Sources/Papertrail/**/*.*"
    ss.public_header_files  = "Sources/Papertrail/PapertrailLogger.h"
  end

  s.subspec 'Cobalt' do |ss|
    ss.dependency 'Lithium/Core'
    ss.dependency 'Cobalt'
    ss.source_files  = "Sources/Lithium/Cobalt/**/*.*"
    ss.public_header_files  = "Sources/Lithium/Cobalt/CobaltLogger.h"
  end

  s.default_subspec = 'Core'
end
