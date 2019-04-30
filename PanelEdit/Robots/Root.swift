//
//  Root.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

struct Root: RootRobot {
	@discardableResult
	func show(in window: UIWindow) -> Self {
		if window.isKeyWindow == false {
			window.makeKeyAndVisible()
		}
		if window.rootViewController == nil {
			window.rootViewController = RootVC()
			//showSidebar(sender: nil)
			showItem(nil)
		}
		return self
	}
}
