// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "device_info_plus", path: "/Users/pariz/.pub-cache/hosted/pub.dev/device_info_plus-11.3.3/ios/device_info_plus"),
        .package(name: "image_picker_ios", path: "/Users/pariz/.pub-cache/hosted/pub.dev/image_picker_ios-0.8.12+2/ios/image_picker_ios"),
        .package(name: "path_provider_foundation", path: "/Users/pariz/.pub-cache/hosted/pub.dev/path_provider_foundation-2.4.1/darwin/path_provider_foundation"),
        .package(name: "url_launcher_ios", path: "/Users/pariz/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.3/ios/url_launcher_ios")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios")
            ]
        )
    ]
)
