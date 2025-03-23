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
    static let imageLoadingError = localized("Error.imageLoading")
    static let cannotLoadProfileError = localized("Error.cannotLoadProfile")

    // MARK: - Filters
    static let filterTableTitle = localized("Filter.table.title")
    static let filterChoiceRating = localized("Filter.choice.rating")
    static let filterChoiceName = localized("Filter.choice.name")
    static let filterChoicePrice = localized("Filter.choice.price")

    
    // MARK: - Profile
    static let name = localized("Profile.Name")
    static let description = localized("Profile.Description")
    static let website = localized("Profile.Website")
    static let favouriteNft = localized("Profile.FavouriteNft")
    static let noFavouriteNft = localized("Profile.NoFavouriteNft")
    static let profileMyNft = localized("Profile.MyNft")
    static let profileFavouriteNft = localized("Profile.FavouriteNft")
    static let profileAboutDeveloper = localized("Profile.AboutDeveloper")
    
    // MARK: - MyNft
    static let myNft = localized("MyNft.Title")
    static let noMyNft = localized("MyNft.NoNft");
    static let cannotLoadMyNftData = localized("MyNft.CannotLoadNftData")
    
    // MARK: - Common
    static let close = localized("Close")

    // MARK: - Delete NFC Confirmation
    static let deleteNftConfirmationLabel = localized("DeleteNfc.confirmation.label")
    static let delete = localized("Delete")
    static let getBack = localized("GetBack")
    static let price = localized("Price")

    // MARK: - Agreement
    static let agreementTextLabel = localized("Agreement.textLabel")
    static let agreementLinkLabel = localized("Agreement.linkLabel")

    // MARK: - Payment
    static let pay = localized("Pay")
    static let paymentPageTitle = localized("PaymentPage.title")
    static let sortByPrice = localized("Sort.Price")
    static let sortByRating = localized("Sort.Rating")
    static let sortByName = localized("Sort.Name")
    static let by = localized("By");
    static let loading = localized("Loading");
    static let sort = localized("Sort");
    static let changeAvatar = localized("ChangeAvatar");
}
