Pod::Spec.new do |s|

s.name         = "AutoInch"
s.version      = "1.0.6"
s.summary      = "优雅的iPhone 等比例/全尺寸 适配工具"

s.homepage     = "https://github.com/lixiang1994/AutoInch"

s.license      = "GPL"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/lixiang1994/AutoInch.git", :tag => "1.0.6"}

s.source_files  = "AutoInch/**/*.swift"

s.requires_arc = true

s.swift_version = "4.2"

end
