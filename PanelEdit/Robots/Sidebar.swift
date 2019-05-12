//
//  Sidebar.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit
import PanelKit

import Additions

struct Sidebar: Robot, DataStoreSourced {
	private func sidebars(in root: RootVC) -> VCs<SidebarVC> {
		return childVCs(SidebarVC.self, uniquingPrefix: root)
	}
	
	@discardableResult
	func show(in root: RootVC, sender: UIBarButtonItem?, animated: Bool) -> Self {
		let sidebar = childVC(uniquedWith: root, UUID(), default: {SidebarVC()})
		let panel = PanelViewController(with: sidebar, in: root)
		sender
			=>? {panel.present(in: root, from: $0, animated: animated)}
			?? panel.present(in: root, animated: animated)
		root.addPanel(panel)
		return self
	}
	
	@discardableResult
	func select(sidebarsIn root: RootVC, itemAt index: Int? = nil) -> Self {
		sidebars(in: root).forEach{$0.select(itemAt: index)}
		return self
	}
	
	@discardableResult
	func reload(sidebarsIn root: RootVC, itemAt index: Int? = nil) -> Self {
		sidebars(in: root).forEach{$0.reload(itemAt: index)}
		return self
	}
}
