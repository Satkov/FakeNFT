import Foundation

enum Localization {
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    // MARK: - Tab Bar
    static let catalogTab = localized("Tab.catalog")
    static let profileTab = localized("Tab.profile")

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

    
    // MARK: - Profile
    static let name = localized("Profile.Name")
    static let description = localized("Profile.Description")
    static let website = localized("Profile.Website")
    
    // MARK: - MyNft
    static let myNft = localized("MyNft.Title")
    
    // MARK: - Common
    static let close = localized("Close")
    static let price = localized("Price")
    static let sortByPrice = localized("Sort.Price")
    static let sortByRating = localized("Sort.Rating")
    static let sortByName = localized("Sort.Name")
}
