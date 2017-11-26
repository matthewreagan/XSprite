# XSprite

This is a modified version of Xcode's cross-platform SpriteKit game template, ideal for beginning new Swift game projects in Xcode to target both iOS and macOS (but not watchOS or tvOS). This is distributed as a simple .xcodeproj which can be duplicated and then used as the starting point for new game projects.

How this project differs from the default Xcode template:

- Preconfigured for Swift + SpriteKit
- Built-in hooks for easier iOS device rotation handling or macOS window / screen resizing
- Adds optional action blocks on `SKNode` for automatic handling of basic mouse or touch actions
- Changes default GameScene and other classes to work slightly better for programmatic configuration
- Removes Storyboards, adds MainMenu.xib for macOS
- Removes ignoresSiblingOrder override
- Removes default demo code and scene files
- Removes tvOS and watchOS targets / code

## Author

**Matt Reagan** - Website: [http://sound-of-silence.com/](http://sound-of-silence.com/) - Twitter: [@hmblebee](https://twitter.com/hmblebee)

## License

Source code and related resources are Copyright (C) Matthew Reagan 2016. The source code is released under the [MIT License](https://opensource.org/licenses/MIT).
