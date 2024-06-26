import Foundation
import PackagePlugin

enum ArgumentParsingError: LocalizedError, CustomStringConvertible {
  case missingValue(option: String)
  case unintendedValue(option: String)

  var description: String {
    switch self {
    case .missingValue(let option):
      return "missing value for the option named --\(option)"
    case .unintendedValue(let option):
      return "unintended value for the option named --\(option)"
    }
  }

  var errorDescription: String? {
    return description
  }
}

extension ArgumentExtractor {
  mutating func extractXCArchiveURL() throws -> URL {
    let optionName = "xcarchive-path"
    let xcarchivePath = extractOption(named: optionName)
    guard let path = xcarchivePath.first else {
      throw ArgumentParsingError.missingValue(option: optionName)
    }
    guard path.hasSuffix(".xcarchive") else {
      throw ArgumentParsingError.unintendedValue(option: optionName)
    }
    return URL(fileURLWithPath: path, isDirectory: true)
  }
}
