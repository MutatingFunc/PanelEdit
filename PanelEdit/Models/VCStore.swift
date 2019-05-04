//
//  VCStore.swift
//  PanelEdit
//
//  Created by James Froggatt on 04.05.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

protocol VCStoreKeyComponent {
	var vcStoreKeyComponent: String {get}
}
extension UIViewController: VCStoreKeyComponent {
	var vcStoreKeyComponent: String {return ObjectIdentifier(self).debugDescription}
}
extension UUID: VCStoreKeyComponent {
	var vcStoreKeyComponent: String {return uuidString}
}
extension String: VCStoreKeyComponent {
	var vcStoreKeyComponent: String {return self}
}

class VCStore: SelfReturning {
	static let shared = Self()
	
	struct Key<Robot, VC: UIViewController>: Equatable, Hashable, SelfReturning {
		fileprivate var stringValue: String
		init() {
			self.stringValue = ObjectIdentifier(Robot.self).debugDescription + ObjectIdentifier(VC.self).debugDescription
		}
		
		func appending(_ components: VCStoreKeyComponent...) -> Self {
			return self.appending(components)
		}
		func appending(_ components: [VCStoreKeyComponent]) -> Self {
			var copy = self
			copy.stringValue += components.map(\.vcStoreKeyComponent).joined()
			return copy
		}
	}
	
	private var vcs: [String: Weak<UIViewController>] = [:]
	private init() {}
	
	subscript<Robot, VC: UIViewController>(_ key: Key<Robot, VC>) -> VC? {
		get {return vcs[key.stringValue]?.target as? VC}
		set {vcs[key.stringValue] = newValue =>? Weak.init}
	}
	subscript<Robot, VC: UIViewController>(prefixedBy prefix: Key<Robot, VC>) -> VCs<VC> {
		return vcs.lazy.compactMap {key, value in
			key.hasPrefix(prefix.stringValue)
				? value.target as? VC
				: nil
		}
	}
}

typealias VCs<VC: UIViewController> = LazyMapSequence<LazyFilterSequence<LazyMapSequence<[String: Weak<UIViewController>], VC?>>, VC>
