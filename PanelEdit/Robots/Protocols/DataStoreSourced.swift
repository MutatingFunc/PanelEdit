//
//  DataStoreSourced.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation

protocol DataStoreSourced {}

extension DataStoreSourced {
	var store: DataStore {return .shared}
}
