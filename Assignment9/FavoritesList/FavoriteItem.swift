import Foundation

// Theme: countries I want to visit. Rating = how much I want to go there.
struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int      // 0...5
}

// The whole list lives here, in one place.
enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Australia", subtitle: "Canberra · Oceania", imageName: "australia", rating: 5),
        FavoriteItem(title: "Japan", subtitle: "Tokyo · East Asia", imageName: "japan", rating: 5),
        FavoriteItem(title: "Great Britain", subtitle: "London · Western Europe", imageName: "gb", rating: 5),
        FavoriteItem(title: "USA", subtitle: "Washington, D.C. · North America", imageName: "usa", rating: 5),
        FavoriteItem(title: "Poland", subtitle: "Warsaw · Central Europe", imageName: "poland", rating: 4),
        FavoriteItem(title: "South Korea", subtitle: "Seoul · East Asia", imageName: "korea", rating: 5),
        FavoriteItem(title: "New Zealand", subtitle: "Wellington · Oceania", imageName: "newzealand", rating: 5),
        FavoriteItem(title: "Sweden", subtitle: "Stockholm · Northern Europe", imageName: "sweden", rating: 5),
        FavoriteItem(title: "Iceland", subtitle: "Reykjavík · Northern Europe", imageName: "iceland", rating: 5),
        FavoriteItem(title: "Italy", subtitle: "Rome · Southern Europe", imageName: "italy", rating: 5),
        FavoriteItem(title: "France", subtitle: "Paris · Western Europe", imageName: "france", rating: 4),
        FavoriteItem(title: "Switzerland", subtitle: "Bern · Central Europe", imageName: "switzerland", rating: 5),
        FavoriteItem(title: "Norway", subtitle: "Oslo · Northern Europe", imageName: "norway", rating: 4),
        FavoriteItem(title: "Georgia", subtitle: "Tbilisi · Caucasus", imageName: "georgia", rating: 4),
        FavoriteItem(title: "Turkey", subtitle: "Ankara · Europe and Asia", imageName: "turkey", rating: 4),
        FavoriteItem(title: "Thailand", subtitle: "Bangkok · Southeast Asia", imageName: "thailand", rating: 4),
        FavoriteItem(title: "Greece", subtitle: "Athens · Southern Europe", imageName: "greece", rating: 4),
        FavoriteItem(title: "Vietnam", subtitle: "Hanoi · Southeast Asia", imageName: "vietnam", rating: 4),
        FavoriteItem(title: "Brazil", subtitle: "Brasília · South America", imageName: "brazil", rating: 3),
        FavoriteItem(title: "Morocco", subtitle: "Rabat · North Africa", imageName: "morocco", rating: 4)
    ]
}
