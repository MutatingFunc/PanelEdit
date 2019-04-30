//
//  RootRobot.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

protocol RootRobot: Robot {}
extension RootRobot {
	@discardableResult
	func showItem(_ index: Int?) -> TextEditor {
		return TextEditor()
			.show(onChange: {Sidebar().reload(index: $0)})
			.reload(withIndex: index)
	}
	
	@discardableResult
	func showSidebar(sender: UIBarButtonItem?) -> Sidebar {
		return Sidebar()
			.show(sender: sender)
			.reload()
	}
}
extension RootRobot {
	var window: UIWindow! {return UIApplication.shared.keyWindow}
	var root: RootVC! {return window?.rootViewController as? RootVC}
}
