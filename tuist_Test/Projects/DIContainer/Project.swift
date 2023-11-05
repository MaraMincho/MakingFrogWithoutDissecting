//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/5/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
	name: "DIContainer",
  product: .framework,
	dependencies: [
		.Presentaion.home.project,
		.Presentaion.homeViewModel.project,
	],
	resources: ["Resources/**"]
)
