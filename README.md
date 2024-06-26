# PrivacyReportGen

PrivacyReportGen is an open-source tool that generates JSON or plist files from xcarchive files, containing the same data as the [privacy peport](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests#4239187) PDF file that can be generated from Xcode. This allows for easy comparison of differences between reports.

## Features

- Extracts privacy report data from xcarchive files
- Generates JSON and plist format files
- Facilitates comparison of privacy report data

## Installation

To use PrivacyReportGen, install it via Swift Package Manager. Add PrivacyReportGen as plugin in your `Package.swift`.

```Package.swift
let package = Package(
    name: "Tools",
    platforms: [.macOS(.v14)],
    products: [ ... ],
    dependencies: [
        ...
        .package(url: "https://github.com/fxwx23/PrivacyReportGen", exact: "0.0.0"),
    ],
    targets: [ ... ]
)
```

## Usage

To generate a privacy report in JSON or plist format, run the following command plugin:
```bash
$ swift package plugin --allow-writing-to-package-directory generate-privacy-report --xcarchive-path '/path/to/your/App.xcarchive'
```

### Command Options
- `--xcarchive-path` : Specifies the path to the xcarchive file from which to generate the privacy report data. (Required)
- `--json` : Specifies JSON as the output format for the generated privacy report. (default is plist)
- `--output-directory` : Specifies the directory where the generated privacy report file will be saved. (default is package path)
  - If using this option, also include `--allow-writing-to-directory` to allow writing to the specified directory. 
- `--report-name` : Specifies the name of the generated privacy report file. (default is `PrivacyReport` )

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your improvements.

## License

PrivacyReportGen is released under the MIT License. See LICENSE for more information.