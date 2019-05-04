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
	
	func vc<VC: UIViewController>(forKeyAppending components: VCStoreKeyComponent..., initial create: () -> VC) -> VC {
		return vc(for: VCStore.Key<Self, VC>().appending(components), initial: create)
	}
	func vc<VC: UIViewController>(for key: VCStore.Key<Self, VC>, initial create: () -> VC) -> VC {
		if let vc = vcStore[key] {
			return vc
		}
		let vc = create()
		vcStore[key] = vc
		return vc
	}
	
	func vc<VC: UIViewController>(_ type: VC.Type = VC.self, forKeyAppending components: VCStoreKeyComponent...) -> VC? {
		return vc(for: VCStore.Key<Self, VC>().appending(components))
	}
	func vc<VC: UIViewController>(for key: VCStore.Key<Self, VC>) -> VC? {
		return vcStore[key]
	}
	
	func vcs<VC: UIViewController>(_ type: VC.Type = VC.self, matchingKeyPrefixByAppending components: VCStoreKeyComponent...) -> VCs<VC> {
		return vcs(matchingPrefix: VCStore.Key<Self, VC>().appending(components))
	}
	func vcs<VC: UIViewController>(matchingPrefix key: VCStore.Key<Self, VC>) -> VCs<VC> {
		return vcStore[prefixedBy: key]
	}
}

