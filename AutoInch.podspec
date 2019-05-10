Pod::Spec.new do |s|

s.name         = "AutoInch"
s.version      = "1.2.0"
s.summary      = "优雅的iPhone 等比例/全尺寸 适配工具"

s.homepage     = "https://github.com/lixiang1994/AutoInch"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/lixiang1994/AutoInch.git", :tag => s.version }

s.source_files  = "Sources/**/*.swift"

s.requires_arc = true

s.frameworks = "UIKit", "Foundation"

s.swift_version = "4.2"
s.swift_versions = ["4.2", "5.0"]

end
