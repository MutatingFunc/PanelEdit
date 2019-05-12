//
//  ModelSourcing.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import Foundation
import UIKit

import Additions

protocol DataStoreSourced {}

extension DataStoreSourced {
	var dataStore: DataStore {return .shared}
}

protocol VCStoreSourced {
	var vcStore: VCStore {get}
}

extension VCStoreSourced {
	var vcStore: VCStore {return .shared}
	
	func childVC<VC: UIViewController>(uniquedWith components: VCStoreKeyComponent..., default create: () -> VC) -> VC {
		return childVC(for: VCStore.Key<Self, VC>().appending(components), default: create)
	}
	func childVC<VC: UIViewController>(for key: VCStore.Key<Self, VC>, default create: () -> VC) -> VC {
		if let vc = vcStore[key] {
			return vc
		}
		let vc = create()
		vcStore[key] = vc
		return vc
	}
	
	func childVC<VC: UIViewController>(_ type: VC.Type = VC.self, uniquedWith components: VCStoreKeyComponent...) -> VC? {
		return childVC(for: VCStore.Key<Self, VC>().appending(components))
	}
	func childVC<VC: UIViewController>(for key: VCStore.Key<Self, VC>) -> VC? {
		return vcStore[key]
	}
	
	func childVCs<VC: UIViewController>(_ type: VC.Type = VC.self, uniquingPrefix components: VCStoreKeyComponent...) -> VCs<VC> {
		return childVCs(uniquingPrefix: VCStore.Key<Self, VC>().appending(components))
	}
	func childVCs<VC: UIViewController>(uniquingPrefix key: VCStore.Key<Self, VC>) -> VCs<VC> {
		return vcStore[prefixedBy: key]
	}
}

