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

struct Sidebar: RootRobot, DataStoreSourced {
	@discardableResult
	func show(sender: UIBarButtonItem?) -> Self {
		let sidebar = SidebarVC()
		let panel = PanelViewController(with: sidebar, in: root)
		sender
			=>? {panel.present(in: root, from: $0, animated: true)}
			?? panel.present(in: root, animated: true)
		root.addPanel(panel)
		return self
	}
	
	@discardableResult
	func reload(index: Int? = nil) -> Self {
		sidebars.forEach{$0.reload(index: index)}
		return self
	}
}

private extension Sidebar {
	var sidebars: [SidebarVC] {return root.panels.compactMap{$0.contentViewController as? SidebarVC}}
}
