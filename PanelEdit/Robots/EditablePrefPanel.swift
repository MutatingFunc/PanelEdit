//
//  EditablePanel.swift
//  PanelEdit
//
//  Created by James Froggatt on 30.04.2019.
//  Copyright © 2019 James Froggatt. All rights reserved.
//

import UIKit

struct EditablePrefPanel: RootRobot {}

private extension EditablePrefPanel {
	var editablePrefPanel: UIViewController! {return root.presentedViewController}
}
