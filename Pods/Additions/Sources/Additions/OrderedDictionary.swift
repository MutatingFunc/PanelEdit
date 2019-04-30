//
//  OrderedDictionary.swift
//  StandardAdditions
//
//  Created by James Froggatt on 28.06.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

///a dictionary with an ordered set of keys
public struct OrderedDictionary<Key: Hashable, Value>: ExpressibleByDictionaryLiteral {
	public typealias KeyValue = (key: Key, value: Value)
	
	public private(set) var keys = [Key]()
	private(set) var values = [Key: Value]()
	
	public init() {}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		self.init(elements)
	}
	public init<S>(_ sequence: S) where
		S: Sequence, S.Iterator.Element == (Key, Value) {
			for (key, value) in sequence {
				self.updateValue(value, forKey: key)
			}
	}
}
//Due to an Xcode 10.2 bug, this can't be a nested type
private struct KeyValueCodable<Key: Codable, Value: Codable>: Codable {var key: Key, value: Value}
extension OrderedDictionary: Codable where Key: Codable, Value: Codable {
	public init(from decoder: Decoder) throws {
		try self.init(decoder.singleValueContainer().decode([KeyValueCodable<Key, Value>].self).map{($0.key, $0.value)})
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(self.map(KeyValueCodable<Key, Value>.init))
	}
}

public extension OrderedDictionary {
	///accesses the value for the given key,
	///with nil indicating the absence of a value
	subscript(_ key: Key) -> Value? {
		get {return values[key]}
		set {
			if let newValue = newValue {
				self.updateValue(newValue, forKey: key)
			} else {
				self.removeValue(forKey: key)
			}
		}
	}
	
	///returns a new OrderedDictionary containing the keys of this OrderedDictionary with the values transformed by the given closure
	func mapValues<Result>(_ transform: (Value) throws -> Result) rethrows -> OrderedDictionary<Key, Result> {
		var result = OrderedDictionary<Key, Result>()
		result.keys = self.keys
		result.values = try self.values.mapValues(transform)
		return result
	}
	
	///updates the value at the given position
	@discardableResult mutating func updateValue(_ newValue: Value, at position: Int) -> Value {
		return values.updateValue(newValue, forKey: keys[position])! //safe unwrap of value for known key
	}
	
	///updates the value for the given key, or adds a new key-value pair if the key does not exist
	@discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		let oldValue = values.updateValue(value, forKey: key)
		if oldValue == nil {keys.append(key)}
		return oldValue
	}
	///removes the value for the given key
	@discardableResult mutating func removeValue(forKey key: Key) -> (index: Int, value: Value)? {
		guard
			values[key] != nil, //O(1) failure shortcut
			let index = keys.firstIndex(of: key)
		else {return nil}
		keys.remove(at: index)
		return values.removeValue(forKey: key).map{(index, $0)}
	}
}

extension OrderedDictionary: RangeReplaceableCollection, RandomAccessCollection {}
public extension OrderedDictionary {
	var startIndex: Int {return keys.startIndex}
	var endIndex: Int {return keys.endIndex}
	func index(after i: Int) -> Int {return i+1}
	mutating func reserveCapacity(_ n: Int) {
		keys.reserveCapacity(n)
		values.reserveCapacity(n)
	}
	
	var underestimatedCount: Int {return keys.underestimatedCount}
	
	///accesses the key-value pair at the given index
	subscript(_ position: Int) -> KeyValue {
		get {
			let key = keys[position]
			return (key, values[key]!) //safe unwrap of value for known key
		}
		set {
			self.replaceSubrange(position...position, with: CollectionOfOne(newValue))
		}
	}
	mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where
			C: Collection, R: RangeExpression, Element == C.Element, Int == R.Bound {
		for key in self.keys[subrange] {
			self.values.removeValue(forKey: key)
		}
		let keys = newElements.map {(key, value) -> Key in
			precondition(values[key] == nil, uniqueKeyRequired)
			values[key] = value
			return key
		}
		self.keys.replaceSubrange(subrange, with: keys)
	}
}

extension OrderedDictionary: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return "\(OrderedDictionary.self): [" + self.keys.map {key in
			"\(key): \(self.values[key].debugDescription)"
		}.joined(separator: ", ") + "]"
	}
	public var debugDescription: String {
		return self.description
	}
}

private let uniqueKeyRequired = "Inserted keys must be unique"
