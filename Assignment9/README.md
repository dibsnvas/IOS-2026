# Favorites List · My Movies & TV Shows

Lab · Favorites List — UITableView & Custom Cells. A UIKit app with a list of my 20 favorite movies and TV series: the 10 movies from my Movie Roulette (Assignment 6) plus 10 series. Each row is a custom cell with the poster, the title, the type, director or network and year, and my rating from 0 to 5 stars.

## Screenshots

| iPhone SE (3rd gen) | iPhone 16 Pro Max |
|---|---|
| <img src="Screenshots/iphone-se.png" width="250"> | <img src="Screenshots/iphone-16-pro-max.png" width="250"> |

Screen recording, scrolling through the whole list: [Screenshots/scroll.mp4](Screenshots/scroll.mp4)

## Requirements checklist

**Theme and data**
- Theme: my favorite movies and TV series, 20 items (10 movies + 10 series)
- Each item has a title, a subtitle, an image and a rating 0–5
- `FavoriteItem` struct, the array lives in one place: `FavoritesLibrary.items` (`FavoriteItem.swift`)
- Every item has its own poster in `Assets.xcassets` (low-resolution posters from the English Wikipedia articles, used for an educational project)

**Custom cell**
- `FavoriteCell: UITableViewCell` in its own file, only `@IBOutlet`s and `configure(with:)`, no layout code
- Poster `UIImageView` with a fixed size (60 × 90)
- Title and subtitle `UILabel`s
- Rating: a horizontal stack of 5 SF Symbol image views (`star.fill` / `star`), connected as an outlet collection

**Table view**
- One `UITableView` pinned to the Safe Area
- Prototype cell inside the table view in `Main.storyboard`, class `FavoriteCell`, reuse identifier `FavoriteCell`
- `UITableViewDataSource`: one row per item, `dequeueReusableCell(withIdentifier:for:)` cast to `FavoriteCell`
- Every dequeued cell is fully reset from its item

**Layout (Main.storyboard only)**
- Poster on the left; a vertical stack with title, subtitle and the rating row on the right
- Constraints only on the image and the outer stack; the stack is pinned top-to-bottom, so the row height follows the content
- Long titles wrap (`Lines = 0`) and never overlap the poster
- Zero Auto Layout warnings, no constraint conflicts in the console, checked on iPhone SE (3rd gen) and iPhone 16 Pro Max

## Project structure

```
FavoritesList/
├── FavoritesViewController.swift   // table view data source
├── FavoriteCell.swift              // custom cell: outlets + configure(with:)
├── FavoriteItem.swift              // struct + the 20 movies and series
├── Assets.xcassets                 // 20 posters, AppIcon, colors
├── Main.storyboard
└── LaunchScreen.storyboard
```

## How to run

Open `FavoritesList.xcodeproj`, pick an iPhone simulator and press **⌘R**.
