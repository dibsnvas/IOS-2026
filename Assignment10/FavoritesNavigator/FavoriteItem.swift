import Foundation

// Theme: countries I want to visit. Rating = how much I want to go there.
struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int      // 0...5
    let description: String
}

// The whole list lives here, in one place.
enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Australia", subtitle: "Canberra · Oceania", imageName: "australia", rating: 5,
                     description: "Australia is a whole continent of adventures. I want to see the Sydney Opera House, snorkel at the Great Barrier Reef and meet kangaroos and koalas. The red desert around Uluru looks like nothing else on Earth."),
        FavoriteItem(title: "Japan", subtitle: "Tokyo · East Asia", imageName: "japan", rating: 5,
                     description: "Japan mixes neon cities with quiet temples and gardens. I want to ride the Shinkansen from Tokyo to Kyoto and see the cherry blossoms in spring. The food alone is a reason to go: ramen, sushi and tiny bakeries on every corner."),
        FavoriteItem(title: "Great Britain", subtitle: "London · Western Europe", imageName: "gb", rating: 5,
                     description: "Great Britain is full of places I know from books and films. I want to walk around London, visit the Harry Potter studio and take a train to Edinburgh. Afternoon tea with scones is a must."),
        FavoriteItem(title: "USA", subtitle: "Washington, D.C. · North America", imageName: "usa", rating: 5,
                     description: "The USA is huge and every state feels different. New York, the Golden Gate Bridge in San Francisco and a road trip to the Grand Canyon are my top plans. I also want to see a real basketball game live."),
        FavoriteItem(title: "Poland", subtitle: "Warsaw · Central Europe", imageName: "poland", rating: 4,
                     description: "Poland is beautiful and easy to reach. The old town of Kraków, the rebuilt center of Warsaw and the Baltic coast near Gdańsk are on my list. I also want to try real pierogi in a small family restaurant."),
        FavoriteItem(title: "South Korea", subtitle: "Seoul · East Asia", imageName: "korea", rating: 5,
                     description: "South Korea mixes old palaces with the newest technology. I want to walk around Seoul at night, wear a hanbok at Gyeongbokgung Palace and eat Korean barbecue. Jeju Island with its volcano and beaches is the next stop."),
        FavoriteItem(title: "New Zealand", subtitle: "Wellington · Oceania", imageName: "newzealand", rating: 5,
                     description: "New Zealand looks like the set of a fantasy film, because it was one. I want to visit Hobbiton, see the fjords of Milford Sound and the glowworm caves. It is one of the best places in the world for hiking."),
        FavoriteItem(title: "Sweden", subtitle: "Stockholm · Northern Europe", imageName: "sweden", rating: 5,
                     description: "Sweden is calm, stylish and very green. Stockholm is built on islands, so you can explore it by boat. I also want to try a real fika with cinnamon buns and coffee."),
        FavoriteItem(title: "Iceland", subtitle: "Reykjavík · Northern Europe", imageName: "iceland", rating: 5,
                     description: "Iceland feels like another planet. There are volcanoes, black sand beaches, geysers and huge waterfalls on one small island. I want to drive the Ring Road and swim in a hot spring under the snow."),
        FavoriteItem(title: "Italy", subtitle: "Rome · Southern Europe", imageName: "italy", rating: 5,
                     description: "Italy is a whole museum under the open sky. I dream of walking through Rome, eating real pizza in Naples and watching the sunset on the Amalfi Coast. Every small town there seems to have its own pasta and its own story."),
        FavoriteItem(title: "France", subtitle: "Paris · Western Europe", imageName: "france", rating: 4,
                     description: "France is more than the Eiffel Tower. I would like to spend a week in Paris and then take a train to the lavender fields of Provence. Croissants for breakfast every day sound like a perfect plan."),
        FavoriteItem(title: "Switzerland", subtitle: "Bern · Central Europe", imageName: "switzerland", rating: 5,
                     description: "Switzerland looks like a postcard from every window. Lakes, glaciers and mountain trains make it ideal for a slow trip. I want to see the Matterhorn and try fondue in a small Alpine village."),
        FavoriteItem(title: "Norway", subtitle: "Oslo · Northern Europe", imageName: "norway", rating: 4,
                     description: "Norway is the land of fjords and the northern lights. A cruise along the fjords and a winter night in Tromsø are on my list. The nature there is wild, clean and very quiet."),
        FavoriteItem(title: "Georgia", subtitle: "Tbilisi · Caucasus", imageName: "georgia", rating: 4,
                     description: "Georgia is close to home and famous for its hospitality. Old Tbilisi with its balconies, the mountains of Kazbegi and long dinners with khachapuri are what I want to see. People say you always leave Georgia with new friends."),
        FavoriteItem(title: "Turkey", subtitle: "Ankara · Europe and Asia", imageName: "turkey", rating: 4,
                     description: "Turkey sits on two continents at once. I want to explore the bazaars of Istanbul and fly in a hot air balloon over Cappadocia at sunrise. The sea coast in the south is great for a warm vacation."),
        FavoriteItem(title: "Thailand", subtitle: "Bangkok · Southeast Asia", imageName: "thailand", rating: 4,
                     description: "Thailand is bright, warm and full of flavor. Bangkok street food, golden temples and the islands of the Andaman Sea are all on my map. I also want to visit Chiang Mai and its night markets."),
        FavoriteItem(title: "Greece", subtitle: "Athens · Southern Europe", imageName: "greece", rating: 4,
                     description: "Greece is where white houses meet a very blue sea. I want to see the Acropolis in Athens and then hop between islands like Santorini and Crete. Ancient history and beach days fit into one trip there."),
        FavoriteItem(title: "Vietnam", subtitle: "Hanoi · Southeast Asia", imageName: "vietnam", rating: 4,
                     description: "Vietnam has some of the most beautiful landscapes in Asia. I want to sail through Ha Long Bay and walk the lantern streets of Hoi An. And of course I want to eat a real bowl of pho in Hanoi."),
        FavoriteItem(title: "Brazil", subtitle: "Brasília · South America", imageName: "brazil", rating: 3,
                     description: "Brazil is huge and full of energy. Rio de Janeiro with its beaches and the Christ the Redeemer statue is the first stop. One day I would also like to see the Amazon rainforest and Iguaçu Falls."),
        FavoriteItem(title: "Morocco", subtitle: "Rabat · North Africa", imageName: "morocco", rating: 4,
                     description: "Morocco is a mix of colors, spices and old cities. I want to get lost in the medina of Marrakech and sleep in a desert camp in the Sahara. The blue streets of Chefchaouen are a dream for photos.")
    ]
}
