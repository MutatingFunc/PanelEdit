//
//  Foundation.swift
//  Additions
//
//  Created by James Froggatt on 27.09.2016.
//
//

import Foundation

@available(*, deprecated, renamed: "+>")
public extension NSObjectProtocol {
	func setup(_ setup: (Self) -> ()) -> Self {
		setup(self)
		return self
	}
}

public extension IndexPath {
	init<I: BinaryInteger>(row: I) {
		self.init(indexes: [0, Int(row)])
	}
	init<I: BinaryInteger>(item: I) {
		self.init(indexes: [0, Int(item)])
	}
}

public extension JSONDecoder {
	func decode<Decodable: Swift.Decodable>(from data: Data) throws -> Decodable {
		return try self.decode(Decodable.self, from: data)
	}
}

public extension FileManager {
	///copies a file, renaming with an incrementing number on a FileExists error.
	func renamingCopy(at source: URL, to target: URL) throws {
		let fileManager = FileManager.default
		let (title, ext) = (target.deletingPathExtension().lastPathComponent, target.pathExtension)
		let targetFolder = target.deletingLastPathComponent()
		var target = target
		for num in 2 ... 100 {
			do {
				try fileManager.copyItem(at: source, to: target)
				return
			} catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == CocoaError.fileWriteFileExists.rawValue {
				target = targetFolder.appendingPathComponent("\(title) \(num).\(ext)")
			}
		}
		throw NSError(domain: NSCocoaErrorDomain, code: CocoaError.fileWriteFileExists.rawValue, userInfo: nil)
	}
}
