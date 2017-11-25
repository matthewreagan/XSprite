## About XSpriteDemo

This is a modified version of Xcode's cross-platform SpriteKit game template, ideal for beginning new Swift game projects in Xcode to target iOS and macOS (but not watchOS or tvOS). This is distributed as a simple .xcodeproj which can be duplicated and then used as the starting point for new game projects.

How this project differs from the default Xcode template:

- Preconfigured for Swift + SpriteKit
- Built-in hooks for easier iOS device rotation handling or macOS window / screen resizing
- Changes default GameScene and other classes to work slightly better for programmatic configuration
- Removes Storyboards, adds MainMenu.xib for macOS
- Removes ignoresSiblingOrder override
- Removes default demo code and scene files
- Removes tvOS and watchOS targets / code
