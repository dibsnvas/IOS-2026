import Foundation

struct Track {
    let title: String
    let artist: String
    let fileName: String        // audio file in the bundle, without extension
    let coverImageName: String  // image in the bundle or in Assets.xcassets
}

enum TrackLibrary {
    static let supportedExtensions = ["m4a", "mp3"]

    // The list the player uses. My personal playlist is used when its files are in the app;
    // otherwise (for example in a fresh clone of the repo) the royalty-free tracks play.
    static var tracks: [Track] {
        let personal = myPlaylist.filter { url(for: $0) != nil }
        return personal.isEmpty ? royaltyFree : personal
    }

    static func url(for track: Track) -> URL? {
        for ext in supportedExtensions {
            if let url = Bundle.main.url(forResource: track.fileName, withExtension: ext) {
                return url
            }
        }
        return nil
    }

    // Royalty-free tracks generated for this project (Audio/ folder, committed to Git).
    static let royaltyFree: [Track] = [
        Track(title: "Morning Steppe", artist: "Aral Waves", fileName: "morning_steppe", coverImageName: "morning_steppe_cover"),
        Track(title: "Neon Rain", artist: "Night Bus", fileName: "neon_rain", coverImageName: "neon_rain_cover"),
        Track(title: "Paper Planes", artist: "Little Orbit", fileName: "paper_planes", coverImageName: "paper_planes_cover"),
        Track(title: "Mountain Tea", artist: "Alatau Lo-Fi", fileName: "mountain_tea", coverImageName: "mountain_tea_cover"),
        Track(title: "Late Library", artist: "Quiet Pages", fileName: "late_library", coverImageName: "late_library_cover"),
        Track(title: "Pixel Garden", artist: "8-Bit Bloom", fileName: "pixel_garden", coverImageName: "pixel_garden_cover"),
        Track(title: "Snow on Abay", artist: "Winter Tram", fileName: "snow_on_abay", coverImageName: "snow_on_abay_cover"),
        Track(title: "Desert Signal", artist: "Caravan FM", fileName: "desert_signal", coverImageName: "desert_signal_cover"),
        Track(title: "Sunday Bicycle", artist: "Green Lights", fileName: "sunday_bicycle", coverImageName: "sunday_bicycle_cover"),
        Track(title: "Starlight Code", artist: "Swift Echo", fileName: "starlight_code", coverImageName: "starlight_code_cover")
    ]

    // My own playlist. Files go to MusicPlayer/MyMusic/ (ignored by Git, stays on my Mac only):
    // <fileName>.mp3 or .m4a and a cover <fileName>.jpg
    static let myPlaylist: [Track] = [
        Track(title: "To Be Hunted", artist: "Childish Gambino", fileName: "to_be_hunted", coverImageName: "to_be_hunted.jpg"),
        Track(title: "Sierra Leone", artist: "Frank Ocean", fileName: "sierra_leone", coverImageName: "sierra_leone.jpg"),
        Track(title: "Cinderella", artist: "Mac Miller", fileName: "cinderella", coverImageName: "cinderella.jpg"),
        Track(title: "Baby Blue", artist: "Daniel Caesar", fileName: "baby_blue", coverImageName: "baby_blue.jpg"),
        Track(title: "Moment of Your Life", artist: "Brent Faiyaz", fileName: "moment_of_your_life", coverImageName: "moment_of_your_life.jpg"),
        Track(title: "four seasons", artist: "Brent Faiyaz", fileName: "four_seasons", coverImageName: "four_seasons.jpg"),
        Track(title: "Blind", artist: "SZA", fileName: "blind", coverImageName: "blind.jpg"),
        Track(title: "10%", artist: "Kaytranada", fileName: "ten_percent", coverImageName: "ten_percent.jpg"),
        Track(title: "Let Me Go", artist: "Daniel Caesar", fileName: "let_me_go", coverImageName: "let_me_go.jpg"),
        Track(title: "BEST INTEREST", artist: "Tyler, The Creator", fileName: "best_interest", coverImageName: "best_interest.jpg")
    ]
}
