Pod::Spec.new do |s|

s.name         = "AutoInch"
s.version      = "2.4.1"
s.summary      = "优雅的iPhone 等比例/精准 适配工具"

s.homepage     = "https://github.com/lixiang1994/AutoInch"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios, "9.0"

s.source       = { :git => "https://github.com/lixiang1994/AutoInch.git", :tag => s.version }

s.source_files  = "Sources/**/*.swift"

s.requires_arc = true

s.frameworks = "UIKit", "Foundation"

s.swift_versions = ["5.0"]

end
