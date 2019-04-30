//
//  RootVC.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit
import PanelKit

class RootVC: UIViewController, PanelManager {
	var panelContentWrapperView: UIView {return view}
	var panelContentView: UIView {return self.children.first!.view}
	var panels: [PanelViewController] = []
	
	func maximumNumberOfPanelsPinned(at side: PanelPinSide) -> Int {
		return Int(floor(self.view.bounds.height / 320))
	}
	
	func addPanel(_ panel: PanelViewController) {
		panels = panels.filter{$0.contentViewController?.view.superview != nil}
		panels.append(panel)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		enableTripleTapExposeActivation()
	}
}
