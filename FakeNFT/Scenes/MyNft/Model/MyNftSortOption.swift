enum MyNftSortOption: CaseIterable {
    case name
    case price
    case rating
    
    var title: String {
        switch self {
        case .price: return "По цене"
        case .rating: return "По рейтингу"
        case .name: return "По названию"
        }
    }
}
