Pod::Spec.new do |spec|
spec.name             = "ToolsCode"
spec.version          = "0.0.5"
spec.license          = "MIT"
spec.homepage         = "https://github.com/kailunzhou/ToolsCode"
spec.author           = { "zklcode" => "372909335@qq.com" }
spec.summary          = "ToolsCode summary"
spec.source           = { :git => "https://github.com/kailunzhou/ToolsCode.git", :tag => "0.0.5"  }
spec.platform         = :ios, "9.0"
spec.source_files     = "Classes/**/*.{h,m,swift}", "Classes/Net/**/*.{h,m,swift}"
spec.swift_version   = "4.2"
spec.dependency       "Alamofire"
spec.dependency       "ObjectMapper"
spec.dependency       "MJRefresh"
spec.dependency       "IQKeyboardManagerSwift"
spec.dependency       "MBProgressHUD"
spec.dependency       "Reachability"
# spec.exclude_files = "Classes/Exclude"
# spec.public_header_files = "Classes/**/*.h"
# spec.resource  = "icon.png"
# spec.resources = "Resources/*.png"
# spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
# spec.library   = "iconv"
# spec.libraries = "iconv", "xml2"
# spec.requires_arc = true
# spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
