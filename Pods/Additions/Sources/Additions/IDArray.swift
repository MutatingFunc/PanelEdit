//
//  IDArray.swift
//  StandardAdditions
//
//  Created by James Froggatt on 14.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

import Foundation

///a collection providing unique identifiers for its contents
public struct IDArray<Element>: ExpressibleByArrayLiteral {
	
	private var data = OrderedDictionary<UUID, Element>()
	
	public init() {}
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	public init<S>(_ sequence: S) where S: Sequence, S.Iterator.Element == Element {
		for element in sequence {
			data.append((UUID(), element))
		}
	}
	public init<S>(idPairs: S) where S: Sequence, S.Iterator.Element == (UUID, Element) {
		data = OrderedDictionary(idPairs)
	}
	public init(_ data: OrderedDictionary<UUID, Element>) {
		self.data = data
	}
}

extension IDArray: Codable where Element: Codable {
	public init(from decoder: Decoder) throws {
		self.data = try decoder.singleValueContainer().decode(OrderedDictionary<UUID, Element>.self)
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(data)
	}
}

public extension IDArray {
	///accesses the element with the given identifier
	subscript(_ id: UUID) -> Element? {
		get {return data[id]}
		set {data[id] = newValue}
	}
	///returns the index for the given ID
	func index(ofID id: UUID) -> Int? {
		return data.keys.firstIndex(of: id)
	}
	var idPairs: OrderedDictionary<UUID, Element> {
		return self.data
	}
	
	func contains(id: UUID) -> Bool {
		return data[id] != nil
	}
}

extension IDArray: RangeReplaceableCollection, RandomAccessCollection {}
public extension IDArray {
	var startIndex: Int {return data.startIndex}
	var endIndex: Int {return data.endIndex}
	func index(after i: Int) -> Int {return i+1}
	mutating func reserveCapacity(_ n: Int) {
		data.reserveCapacity(n)
	}
	
	var underestimatedCount: Int {return data.underestimatedCount}
	
	///accesses the element at the given position
	subscript(_ position: Int) -> Element {
		get {return data[position].value}
		set {data.updateValue(newValue, at: position)}
	}
	mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where
			C: Collection, C.Iterator.Element == Element {
		data.replaceSubrange(subrange, with: newElements.map{(UUID(), $0)})
	}
}

extension IDArray: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return "\(IDArray.self): [" + data.map{"\($0.value)"}.joined(separator: ", ") + "]"
	}
	public var debugDescription: String {
		return self.description
	}
}
