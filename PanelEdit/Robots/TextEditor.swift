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
		if root.viewControllers.count < 2 {
			let textEditor = TextEditorVC(onChange: onChange)
			let nav = UINavigationController(rootViewController: textEditor)
			root.showDetailViewController(nav, sender: nil)
		}
		return self
	}
	
	@discardableResult
	func reload(withIndex index: Int?) -> Self {
		textEditor?.index = index
		return self
	}
}

private extension TextEditor {
	var textEditorNav: UINavigationController? {return root.viewControllers[ifPresent: 1] as? UINavigationController}
	var textEditor: TextEditorVC? {return textEditorNav?.viewControllers.first as? TextEditorVC}
}
