Pod::Spec.new do |s|

s.name         = "Inch"
s.version      = "1.0.0"
s.summary      = "优雅的iPhone 精准/等比例 适配工具"

s.homepage     = "https://github.com/lixiang1994/Inch"

s.license      = "GPL"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/lixiang1994/Inch.git", :tag => "1.0.0"}

s.source_files  = "Inch/**/*.swift"

s.requires_arc = true

s.swift_version = "4.2"

end
