//
//  Root.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

struct Root: Robot {
	private var root: RootVC {return self.vc(initial: RootVC.init)}
	
	@discardableResult
	func show(in window: UIWindow) -> Self {
		assert(vc(RootVC.self) == nil)
		
		if window.isKeyWindow == false {
			window.makeKeyAndVisible()
		}
		
		if window.rootViewController == nil {
			window.rootViewController = root
			//showSidebar(sender: nil, animated: false)
			showItem(at: nil)
		}
		return self
	}
	
	@discardableResult
	func showItem(at index: Int?) -> TextEditor {
		Sidebar()
			.select(sidebarsIn: root, itemAt: index)
		return TextEditor()
			.show(in: root, onChange: {Sidebar().reload(sidebarsIn: self.root, itemAt: $0)})
			.reload(editorIn: root, withIndex: index)
	}
	
	@discardableResult
	func showSidebar(sender: UIBarButtonItem?, animated: Bool) -> Sidebar {
		return Sidebar()
			.show(in: root, sender: sender, animated: animated)
			.reload(sidebarsIn: root)
	}
}
