import Foundation

struct PrivacyDataUsage: Encodable {
  let bundlePath: String
  let isLinkedToUser: Bool
  let isUsedForTracking: Bool
  let collectionPurposes: [AppPrivacyConfiguration.PrivacyNutritionLabel.CollectionPurpose]

  init(relativePath: String, nutritionLabel: AppPrivacyConfiguration.PrivacyNutritionLabel) {
    self.bundlePath = relativePath.replacingOccurrences(
      of: "Products/Applications/", with: ""
    )
    self.isLinkedToUser = nutritionLabel.isLinkedToUser
    self.isUsedForTracking = nutritionLabel.isUsedForTracking
    self.collectionPurposes = nutritionLabel.collectionPurposes
  }
}

enum PrivacyReportError: LocalizedError, CustomStringConvertible {
  case supportedBundleNotFound
  var description: String {
    switch self {
    case .supportedBundleNotFound:
      "supported bundle types are not found"
    }
  }

  var errorDescription: String? {
    return description
  }
}
typealias PrivacyReport = [String: [String: PrivacyDataUsage]]

extension PrivacyReport {
  init(manifestFiles: [PrivacyManifestFile]) throws {
    self = try manifestFiles.reduce(PrivacyReport()) { (report, manifest) in
      var newReport = report
      for nutritionLabel in manifest.configuration.privacyNutritionLabels {
        var bundleName: String?
        for component in manifest.path.components(separatedBy: "/").reversed() {
          guard bundleName == nil else {
            break
          }
          switch component {
          case _ where component.hasSuffix(".app"):
            bundleName = component
          case _ where component.hasSuffix(".framework"):
            bundleName = component
          case _ where component.hasSuffix(".bundle"):
            bundleName = component
          default:
            continue
          }
        }

        guard let bundleName else {
          throw PrivacyReportError.supportedBundleNotFound
        }

        let dataUsage = PrivacyDataUsage(
          relativePath: manifest.path, nutritionLabel: nutritionLabel
        )

        if newReport.keys.contains(nutritionLabel.collectedDataType.rawValue) {
          newReport[nutritionLabel.collectedDataType.rawValue]![bundleName] = dataUsage
        } else {
          newReport[nutritionLabel.collectedDataType.rawValue] = [
            bundleName: dataUsage
          ]
        }
      }

      return newReport
    }
  }
}
