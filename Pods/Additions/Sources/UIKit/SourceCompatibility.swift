//
//  SourceCompatibility.swift
//  Additions
//
//  Created by James Froggatt on 30.01.2019.
//

#if canImport(UIKit)
import UIKit

#if !swift(>=4.2)
extension UIAlertController {
	public typealias Style = UIAlertControllerStyle
}
extension UIAlertAction {
	public typealias Style = UIAlertActionStyle
}
extension UITableView {
	public typealias RowAnimation = UITableViewRowAnimation
}
#endif

#endif
