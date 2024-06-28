import Foundation

public struct PrivacyReportGen {
  public struct Arguments {
    public enum OutputFileType: String {
      case plist, json
    }

    let outputFileType: OutputFileType
    let outputDirectoryPath: String
    let reportName: String

    public init(
      outputFileType: OutputFileType?,
      outputDirectoryPath: String?,
      reportName: String?
    ) {
      self.outputFileType = outputFileType ?? .plist
      self.outputDirectoryPath = outputDirectoryPath ?? "."
      self.reportName = reportName ?? "PrivacyReport"
    }
  }

  private let privacyManifestExplorer = PrivacyManifestExplorer()
  private let propertyListDecoder = PropertyListDecoder()
  private let arguments: Arguments

  public init(arguments: Arguments) {
    self.arguments = arguments
  }

  public func generateReportFromXCArchive(at xcarchiveURL: URL) throws {
    let manifestURLs = try privacyManifestExplorer.exploreManifestURLs(at: xcarchiveURL)
    let manifestFiles = try manifestURLs.compactMap {
      let data = try Data(contentsOf: $0)
      let configuration = try propertyListDecoder.decode(AppPrivacyConfiguration.self, from: data)
      return PrivacyManifestFile(path: $0.relativePath, configuration: configuration)
    }

    let privacyReport = try PrivacyReport(manifestFiles: manifestFiles)
    switch arguments.outputFileType {
    case .plist:
      let encoder = PropertyListEncoder()
      encoder.outputFormat = .xml
      let data = try encoder.encode(privacyReport)
      let fileURL = URL(
        fileURLWithPath:
          "\(arguments.outputDirectoryPath)/\(arguments.reportName).\(arguments.outputFileType.rawValue)"
      )
      try data.write(to: fileURL)
    case .json:
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
      let data = try encoder.encode(privacyReport)
      let fileURL = URL(
        fileURLWithPath:
          "\(arguments.outputDirectoryPath)/\(arguments.reportName).\(arguments.outputFileType.rawValue)"
      )
      try data.write(to: fileURL)
    }
  }
}
