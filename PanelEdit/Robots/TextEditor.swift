//
//  TextEditor.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

struct TextEditor: RootRobot {
	@discardableResult
	func show(onChange: @escaping (Int) -> ()) -> Self {
		if root.children.isEmpty {
			let textEditor = TextEditorVC(onChange: onChange)
			let nav = UINavigationController(rootViewController: textEditor)
			root.view.addSubview(nav.view.autolayout())
			root.addChild(nav)
		}
		return self
	}
	
	@discardableResult
	func reload(withIndex index: Int?) -> Self {
		textEditor?.index = index
		return self
	}
	
	var textEditorNav: UINavigationController? {return root.children.first as? UINavigationController}
	var textEditor: TextEditorVC? {return textEditorNav?.viewControllers.first as? TextEditorVC}
}
