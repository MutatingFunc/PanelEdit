//
//  Segue.swift
//  StandardAdditions
//
//  Created by James Froggatt on 26.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

#if canImport(UIKit)
import UIKit

//Segues
public extension UIViewController {
	func performSegue<Segue>(_ identifierConvertible: Segue, sender: Any? = nil) where
			Segue: RawRepresentable, Segue.RawValue == String {
		return performSegue(withIdentifier: identifierConvertible.rawValue, sender: sender)
	}
}
#endif
