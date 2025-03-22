enum MyNftSortOption: CaseIterable {
    case name
    case price
    case rating
    
    var title: String {
        switch self {
        case .price: return Localization.sortByPrice
        case .rating: return Localization.sortByRating
        case .name: return Localization.sortByName
        }
    }
}
