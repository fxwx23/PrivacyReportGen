import Foundation
import PackagePlugin

/// Generate privacy report from xcarchive.
@main struct PrivacyReportGenerate: CommandPlugin {

  func performCommand(context: PluginContext, arguments: [String]) throws {
    var argumentExtractor = ArgumentExtractor(arguments)

    let xcachiveURL = try argumentExtractor.extractXCArchiveURL()

    let jsonFlag = argumentExtractor.extractFlag(named: "json")
    let outputDirectoryPathOption = argumentExtractor.extractOption(named: "output-directory")
    let reportNameOption = argumentExtractor.extractOption(named: "report-name")

    let privacyReportGen = PrivacyReportGen(
      arguments: .init(
        outputFileType: jsonFlag == 1 ? .json : .plist,
        outputDirectoryPath: outputDirectoryPathOption.first,
        reportName: reportNameOption.first
      )
    )

    try privacyReportGen.generateReportFromXCArchive(at: xcachiveURL)
  }
}
