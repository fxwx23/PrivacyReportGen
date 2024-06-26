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
  private let propertyListEncoder: PropertyListEncoder
  private let jsonEncoder: JSONEncoder
  private let arguments: Arguments

  public init(arguments: Arguments) {
    self.arguments = arguments

    self.propertyListEncoder = PropertyListEncoder()
    self.propertyListEncoder.outputFormat = .xml

    self.jsonEncoder = JSONEncoder()
    self.jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
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
      let data = try propertyListEncoder.encode(privacyReport)
      let fileURL = URL(
        fileURLWithPath:
          "\(arguments.outputDirectoryPath)/\(arguments.reportName).\(arguments.outputFileType.rawValue)"
      )
      try data.write(to: fileURL)
    case .json:
      let data = try jsonEncoder.encode(privacyReport)
      let fileURL = URL(
        fileURLWithPath:
          "\(arguments.outputDirectoryPath)/\(arguments.reportName).\(arguments.outputFileType.rawValue)"
      )
      try data.write(to: fileURL)
    }
  }
}
