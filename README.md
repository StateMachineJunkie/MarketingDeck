# MarketingDeck
**A simple app for mapping and printing mailing addresses for marketing purposes.**

## Overview

My wife was managing lists of customers in a spreadsheet for the purpose of sending out mailers for one of her clients.

I wrote this little tool in order to automate address verification and address label generation for her on her iPhone. It imports CSV data exported from Pages (or Excel) and provides a simple list of addresses that can be viewed in Maps or used for generating address-label output.

Regarding the two main functions, previously addresses were checked by typing them into a maps app and seeing if the address came back as valid. The program helps the workflow, slightly, by allowing the user to only enter the address once, that is, when entering the data into the spreadsheet. Once said data is imported, simply tapping on a entry in the table will perform the lookup and display the result using Apple Maps.

For the second function, that of printing labels, I use a modified PDF renderer, which is designed to output text properly formatted for 1"x2-5/8" label sheets, which can be fed into your average laser or ink-jet printer.

The code is a simple concoction of Swift, SwiftUI, SwiftData, MapKit, and CoreGraphics.

## Importing CSV Data
The import field sequence and column names are as follows:

```swift
    enum ImportField: String, CaseIterable {
        case name       = "Name"
        case address    = "Address"
        case city       = "City"
        case state      = "State"
        case zipcode    = "Zipcode"
    }
```
For more detail, see the implementation in `ModelContextExtension.swift`. Obviously, you can modify this to match whatever you need. Currently the importer overwrites any existing data in the [model context](https://developer.apple.com/documentation/swiftdata/modelcontext).

## License
AMCAPI is released under an MIT license. See [LICENSE](https://github.com/StateMachineJunkie/MarketingDeck/blob/main/LICENSE) for more information.
