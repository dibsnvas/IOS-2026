import UIKit

struct Favorite {
    let imageName: String
    let title: String
    let description: String
    let accentColor: UIColor
}

extension Favorite {
    static let all: [Favorite] = [
        Favorite(imageName: "lighthouse", title: "The Lighthouse",
                 description: "Two lighthouse keepers slowly lose their minds on a stormy island. Black-and-white, strange and unforgettable.",
                 accentColor: UIColor(red: 0.55, green: 0.56, blue: 0.60, alpha: 1)),
        Favorite(imageName: "tenet", title: "Tenet",
                 description: "A secret agent learns to move through time in reverse to stop a world war. Best watched twice.",
                 accentColor: UIColor(red: 0.33, green: 0.62, blue: 0.82, alpha: 1)),
        Favorite(imageName: "mickey17", title: "Mickey 17",
                 description: "A worker on an ice planet is cloned every time he dies, until two copies of him meet. Dark and funny.",
                 accentColor: UIColor(red: 0.33, green: 0.76, blue: 0.82, alpha: 1)),
        Favorite(imageName: "walktoremember", title: "A Walk to Remember",
                 description: "A popular boy falls for the quiet pastor's daughter in a small town. A tearjerker I still rewatch.",
                 accentColor: UIColor(red: 0.82, green: 0.46, blue: 0.23, alpha: 1)),
        Favorite(imageName: "howtolose", title: "How to Lose a Guy in 10 Days",
                 description: "She tries to drive him away in ten days, he bets he can make her fall in love. A perfect rom-com.",
                 accentColor: UIColor(red: 0.82, green: 0.72, blue: 0.33, alpha: 1)),
        Favorite(imageName: "azkaban", title: "Harry Potter and the Prisoner of Azkaban",
                 description: "Harry's third year at Hogwarts: an escaped prisoner, time travel and the best atmosphere of the series.",
                 accentColor: UIColor(red: 0.26, green: 0.65, blue: 0.82, alpha: 1)),
        Favorite(imageName: "hailmary", title: "Project Hail Mary",
                 description: "A teacher wakes up alone on a spaceship with no memory and has to save the Sun. And makes a friend.",
                 accentColor: UIColor(red: 0.82, green: 0.59, blue: 0.27, alpha: 1)),
        Favorite(imageName: "parasite", title: "Parasite",
                 description: "A poor family cleverly works its way into a rich household, until everything spins out of control.",
                 accentColor: UIColor(red: 0.33, green: 0.82, blue: 0.40, alpha: 1)),
        Favorite(imageName: "dune", title: "Dune",
                 description: "Paul Atreides arrives on the desert planet Arrakis, home of giant sandworms and the precious spice.",
                 accentColor: UIColor(red: 0.82, green: 0.52, blue: 0.33, alpha: 1)),
        Favorite(imageName: "rememberme", title: "Remember Me",
                 description: "A rebellious young man in New York falls in love while dealing with family grief. The ending stays with you.",
                 accentColor: UIColor(red: 0.82, green: 0.33, blue: 0.36, alpha: 1))
    ]
}
