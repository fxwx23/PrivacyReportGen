import Foundation

/// AppPrivacyConfiguration is mapping for prvacy manifest named PrivacyInfo.xcprivacy.
///
/// refs:
///  - https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
///  - https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/adding_a_privacy_manifest_to_your_app_or_third-party_sdk
///  - https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests
///  - https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api
struct AppPrivacyConfiguration: Codable {
  var isTrackingEnabled: Bool?
  var trackingDomains: [String]?
  var privacyNutritionLabels: [PrivacyNutritionLabel]
  var privacyAccessedAPITypes: [PrivacyAccessedAPIType]

  enum CodingKeys: String, CodingKey {
    case isTrackingEnabled = "NSPrivacyTracking"
    case trackingDomains = "NSPrivacyTrackingDomains"
    case privacyNutritionLabels = "NSPrivacyCollectedDataTypes"
    case privacyAccessedAPITypes = "NSPrivacyAccessedAPITypes"
  }

  struct PrivacyNutritionLabel: Codable {
    var collectedDataType: CollectedDataType
    var isLinkedToUser: Bool
    var isUsedForTracking: Bool
    var collectionPurposes: [CollectionPurpose]

    enum CodingKeys: String, CodingKey {
      case collectedDataType = "NSPrivacyCollectedDataType"
      case isLinkedToUser = "NSPrivacyCollectedDataTypeLinked"
      case isUsedForTracking = "NSPrivacyCollectedDataTypeTracking"
      case collectionPurposes = "NSPrivacyCollectedDataTypePurposes"
    }

    enum CollectedDataType: String, Codable {
      case name = "NSPrivacyCollectedDataTypeName"
      case emailAddress = "NSPrivacyCollectedDataTypeEmailAddress"
      case phoneNumber = "NSPrivacyCollectedDataTypePhoneNumber"
      case physicalAddress = "NSPrivacyCollectedDataTypePhysicalAddress"
      case otherUserContactInfo = "NSPrivacyCollectedDataTypeOtherUserContactInfo"
      case health = "NSPrivacyCollectedDataTypeHealth"
      case fitness = "NSPrivacyCollectedDataTypeFitness"
      case paymentInfo = "NSPrivacyCollectedDataTypePaymentInfo"
      case creditInfo = "NSPrivacyCollectedDataTypeCreditInfo"
      case otherFinancialInfo = "NSPrivacyCollectedDataTypeOtherFinancialInfo"
      case preciseLocation = "NSPrivacyCollectedDataTypePreciseLocation"
      case coarseLocation = "NSPrivacyCollectedDataTypeCoarseLocation"
      case sensitiveInfo = "NSPrivacyCollectedDataTypeSensitiveInfo"
      case contacts = "NSPrivacyCollectedDataTypeContacts"
      case emailsOrTextMessages = "NSPrivacyCollectedDataTypeEmailsOrTextMessages"
      case photosOrVideos = "NSPrivacyCollectedDataTypePhotosorVideos"
      case audioData = "NSPrivacyCollectedDataTypeAudioData"
      case gameplayContent = "NSPrivacyCollectedDataTypeGameplayContent"
      case customerSupport = "NSPrivacyCollectedDataTypeCustomerSupport"
      case otherUserContent = "NSPrivacyCollectedDataTypeOtherUserContent"
      case browsingHistory = "NSPrivacyCollectedDataTypeBrowsingHistory"
      case searchHistory = "NSPrivacyCollectedDataTypeSearchHistory"
      case userId = "NSPrivacyCollectedDataTypeUserID"
      case deviceId = "NSPrivacyCollectedDataTypeDeviceID"
      case purchaseHistory = "NSPrivacyCollectedDataTypePurchaseHistory"
      case productInteraction = "NSPrivacyCollectedDataTypeProductInteraction"
      case advertisingData = "NSPrivacyCollectedDataTypeAdvertisingData"
      case otherUsageData = "NSPrivacyCollectedDataTypeOtherUsageData"
      case crashData = "NSPrivacyCollectedDataTypeCrashData"
      case performanceData = "NSPrivacyCollectedDataTypePerformanceData"
      case otherDiagnosticData = "NSPrivacyCollectedDataTypeOtherDiagnosticData"
      case environmentScanning = "NSPrivacyCollectedDataTypeEnvironmentScanning"
      case hands = "NSPrivacyCollectedDataTypeHands"
      case head = "NSPrivacyCollectedDataTypeHead"
      case otherDataTypes = "NSPrivacyCollectedDataTypeOtherDataTypes"
    }

    enum CollectionPurpose: String, Codable {
      case thirdPartyAdvertising = "NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising"
      case developerAdvertising = "NSPrivacyCollectedDataTypePurposeDeveloperAdvertising"
      case analytics = "NSPrivacyCollectedDataTypePurposeAnalytics"
      case productPersonalization = "NSPrivacyCollectedDataTypePurposeProductPersonalization"
      case appFunctionality = "NSPrivacyCollectedDataTypePurposeAppFunctionality"
      case purposeOther = "NSPrivacyCollectedDataTypePurposeOther"
    }
  }

  struct PrivacyAccessedAPIType: Codable {
    var accessedAPIType: String
    var accessedAPIReasons: [String]

    enum CodingKeys: String, CodingKey {
      case accessedAPIType = "NSPrivacyAccessedAPIType"
      case accessedAPIReasons = "NSPrivacyAccessedAPITypeReasons"
    }
  }
}
