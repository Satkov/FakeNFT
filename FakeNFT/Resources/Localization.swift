import Foundation

enum Localization {
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    // MARK: - Tab Bar
    static let catalogTab = localized("Tab.catalog")
    static let cartTab = localized("Tab.cart")

    // MARK: - Catalog
    static let openNft = localized("Catalog.openNft")

    // MARK: - Errors
    static let networkError = localized("Error.network")
    static let unknownError = localized("Error.unknown")
    static let repeatAction = localized("Error.repeat")
    static let errorTitle = localized("Error.title")

    // MARK: - Filters
    static let filterTableTitle = localized("Filter.table.title")
    static let filterChoiceRating = localized("Filter.choice.rating")
    static let filterChoiceName = localized("Filter.choice.name")
    static let filterChoicePrice = localized("Filter.choice.price")

    // MARK: - Common
    static let close = localized("Close")
}
