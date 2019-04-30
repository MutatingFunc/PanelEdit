//
//  Sidebar.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

struct Sidebar: RootRobot, DataStoreSourced {
	@discardableResult
	func show() -> Self {
		if root.viewControllers.isEmpty {
			let nav = UINavigationController(rootViewController: SidebarVC())
			root.viewControllers.append(nav)
		}
		return self
	}
	
	@discardableResult
	func reload(index: Int? = nil) -> Self {
		sidebar?.reload(index: index)
		return self
	}
}

private extension Sidebar {
	var sidebarNav: UINavigationController? {return root.viewControllers.first as? UINavigationController}
	var sidebar: SidebarVC? {return sidebarNav?.viewControllers.first as? SidebarVC}
}
