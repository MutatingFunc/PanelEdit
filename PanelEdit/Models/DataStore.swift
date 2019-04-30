//
//  DataStore.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation

class DataStore: SelfReturning {
	static let shared = Self()
	private static let keys: [PartialKeyPath<Self>: String] = [
		\Self.textItems: "TextItems"
	]
	
	private init() {
		self.textItems = Self.getTextItems(from: defaults)
	}
	
	//Dependencies
	private let defaults = UserDefaults.standard
	private var changes: [PartialKeyPath<Self>: Bool] = [:]
	
	func sync() {
		//Set
		for (keyPath, value) in changes where value == true {
			if let key = Self.keys[keyPath] {
				defaults.set(self[keyPath: keyPath], forKey: key)
			}
		}
		
		//Get
		textItems = Self.getTextItems(from: defaults)
		
		//Synced
		self.changes = [:]
	}
	
	//Items
	private static func getTextItems(from defaults: UserDefaults) -> [String] {
		return defaults.array(forKey: keys[\Self.textItems]!) as? [String] ?? []
	}
	var textItems: [String] {
		didSet {changes[\Self.textItems] = true}
	}
}
