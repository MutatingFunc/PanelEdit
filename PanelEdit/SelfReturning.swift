//
//  SelfReturning.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation

protocol SelfReturning {}
extension SelfReturning {
	typealias `Self` = Self
}
