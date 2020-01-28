//
//  Package.swift
//  Floaty
//
//  Created by Oleksandr Zarochintsev on 28.01.2020.
//  Copyright © 2019 Oleksandr Zarochintsev. All rights reserved.
//

import PackageDescription

let package = Package(name: "Floaty",
                      platforms: [.iOS(.v10)],
                      products: [.library(name: "Floaty", targets: ["Floaty"])],
                      targets: [.target(name: "Floaty", path: "Sources")], swiftLanguageVersions: [.v5])
