Pod::Spec.new do |s|

  s.name         = "SARUnArchiveANY"
  s.version      = "0.0.1"
  s.summary      = 'UnArchiving Library for iOS'

  s.homepage     = "https://github.com/saru2020/SARUnArchiveANY"

  s.license  = { :type => 'Custom', :text => 'Copyright (C) 2010 Apple Inc. All Rights Reserved.' }

  s.platform     = :ios

s.author = {
    'Saravanan' => 'saru2020@gmail.com'
  }

s.source = {
    :git => 'https://github.com/saru2020/SARUnArchiveANY',
    :tag => s.version.to_s
  }


  s.source_files  = 'SARUnarchiveANY/*.{h,m}'


end
