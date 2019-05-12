//
//  TextEditor.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

import Additions

struct TextEditor: Robot {
	private var editorParents: VCs<UIViewController> {return childVCs(UIViewController.self)}
	private func addParent(_ parent: UIViewController) {
		_ = childVC(uniquedWith: UUID(), default: {parent})
	}
	private func editor(in parent: UIViewController) -> TextEditorVC? {
		return childVC(uniquedWith: parent)
	}
	private func nav(in parent: UIViewController) -> UINavigationController? {
		return childVC(uniquedWith: parent)
	}
	
	@discardableResult
	func show(in parent: UIViewController, onChange: @escaping (Int) -> ()) -> Self {
		guard childVCs(TextEditorVC.self, uniquingPrefix: parent).isEmpty else {
			//Only present one editor per parent
			return self
		}
		
		addParent(parent)
		
		if parent.children.isEmpty {
			let textEditor = childVC(uniquedWith: parent, default: {TextEditorVC(onChange: onChange)})
			let textEditorNav = childVC(uniquedWith: parent, default: {UINavigationController(rootViewController: textEditor)})
			parent.view.addSubview(textEditorNav.view.autolayout())
			parent.addChild(textEditorNav)
		}
		return self
	}
	
	@discardableResult
	func reload(editorIn parent: UIViewController, withIndex index: Int?) -> Self {
		editor(in: parent)?.index = index
		return self
	}
	
}
