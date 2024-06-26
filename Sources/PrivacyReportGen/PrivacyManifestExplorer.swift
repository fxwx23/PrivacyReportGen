import Foundation

enum PrivacyManifestExploringError: LocalizedError, CustomStringConvertible {
  case directoryEnumeratorInitializationFailed
  var description: String {
    switch self {
    case .directoryEnumeratorInitializationFailed:
      "failed to initialize directory enumerator"
    }
  }

  var errorDescription: String? {
    return description
  }
}

class PrivacyManifestExplorer {
  private static let fileManager = FileManager.default

  func exploreManifestURLs(at xcachiveURL: URL) throws -> [URL] {
    let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
    guard
      let directoryEnumerator = Self.fileManager.enumerator(
        at: xcachiveURL,
        includingPropertiesForKeys: Array(resourceKeys),
        options: [.skipsHiddenFiles, .producesRelativePathURLs]
      )
    else {
      throw PrivacyManifestExploringError.directoryEnumeratorInitializationFailed
    }

    var manifestURLs: [URL] = []
    for case let fileURL as URL in directoryEnumerator {
      guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
        let isDirectory = resourceValues.isDirectory,
        let name = resourceValues.name
      else {
        continue
      }

      if isDirectory {
        if shouldSkipDescendants(at: directoryEnumerator.level, name: name) {
          directoryEnumerator.skipDescendants()
        }
      } else if name == "PrivacyInfo.xcprivacy" {
        manifestURLs.append(fileURL)
      }
    }

    return manifestURLs
  }

  private func shouldSkipDescendants(at directoryLevel: Int, name: String) -> Bool {
    switch (directoryLevel, name) {
    case (1, "Products"), (2, "Applications"), (4, "Frameworks"):
      return false
    case (3, _) where name.hasSuffix(".app"):
      return false
    case _ where name.hasSuffix(".bundle") || name.hasSuffix(".framework"):
      return false
    default:
      return true
    }
  }
}
