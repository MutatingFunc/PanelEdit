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
	private var editorParents: VCs<UIViewController> {return vcs(UIViewController.self)}
	private func addParent(_ parent: UIViewController) {
		_ = vc(forKeyAppending: UUID(), initial: {parent})
	}
	private func editor(in parent: UIViewController) -> TextEditorVC? {
		return vc(forKeyAppending: parent)
	}
	private func nav(in parent: UIViewController) -> UINavigationController? {
		return vc(forKeyAppending: parent)
	}
	
	@discardableResult
	func show(in parent: UIViewController, onChange: @escaping (Int) -> ()) -> Self {
		guard vcs(TextEditorVC.self, matchingKeyPrefixByAppending: parent).isEmpty else {
			//Only present one editor per parent
			return self
		}
		
		addParent(parent)
		
		if parent.children.isEmpty {
			let textEditor = vc(forKeyAppending: parent, initial: {TextEditorVC(onChange: onChange)})
			let textEditorNav = vc(forKeyAppending: parent, initial: {UINavigationController(rootViewController: textEditor)})
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
