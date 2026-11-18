import Foundation

// Theme: my favorite movies and TV series.
struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int      // 0...5
}

// The whole list lives here, in one place.
enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "The Lighthouse", subtitle: "Movie · Robert Eggers · 2019", imageName: "lighthouse", rating: 4),
        FavoriteItem(title: "Tenet", subtitle: "Movie · Christopher Nolan · 2020", imageName: "tenet", rating: 5),
        FavoriteItem(title: "Mickey 17", subtitle: "Movie · Bong Joon-ho · 2025", imageName: "mickey17", rating: 4),
        FavoriteItem(title: "A Walk to Remember", subtitle: "Movie · Adam Shankman · 2002", imageName: "walktoremember", rating: 5),
        FavoriteItem(title: "How to Lose a Guy in 10 Days", subtitle: "Movie · Donald Petrie · 2003", imageName: "howtolose", rating: 4),
        FavoriteItem(title: "Harry Potter and the Prisoner of Azkaban", subtitle: "Movie · Alfonso Cuarón · 2004", imageName: "azkaban", rating: 5),
        FavoriteItem(title: "Project Hail Mary", subtitle: "Movie · Phil Lord & Christopher Miller · 2026", imageName: "hailmary", rating: 5),
        FavoriteItem(title: "Parasite", subtitle: "Movie · Bong Joon-ho · 2019", imageName: "parasite", rating: 5),
        FavoriteItem(title: "Dune", subtitle: "Movie · Denis Villeneuve · 2021", imageName: "dune", rating: 5),
        FavoriteItem(title: "Remember Me", subtitle: "Movie · Allen Coulter · 2010", imageName: "rememberme", rating: 4),
        FavoriteItem(title: "The Mentalist", subtitle: "TV series · CBS · 2008–2015", imageName: "mentalist", rating: 5),
        FavoriteItem(title: "Lupin", subtitle: "TV series · Netflix · 2021–", imageName: "lupin", rating: 5),
        FavoriteItem(title: "Alice in Borderland", subtitle: "TV series · Netflix · 2020–2025", imageName: "borderland", rating: 5),
        FavoriteItem(title: "Stranger Things", subtitle: "TV series · Netflix · 2016–2025", imageName: "strangerthings", rating: 5),
        FavoriteItem(title: "100 Days of Deception", subtitle: "TV series · tvN · 2026", imageName: "deception", rating: 4),
        FavoriteItem(title: "The Queen's Gambit", subtitle: "Miniseries · Netflix · 2020", imageName: "queensgambit", rating: 5),
        FavoriteItem(title: "Alchemy of Souls", subtitle: "TV series · tvN · 2022–2023", imageName: "alchemy", rating: 5),
        FavoriteItem(title: "American Manhunt: O.J. Simpson", subtitle: "Documentary · Netflix · 2025", imageName: "manhunt", rating: 4),
        FavoriteItem(title: "Money Heist", subtitle: "TV series · Netflix · 2017–2021", imageName: "moneyheist", rating: 5),
        FavoriteItem(title: "Bridgerton", subtitle: "TV series · Netflix · 2020–", imageName: "bridgerton", rating: 4)
    ]
}
