# LGSharing

iOS helper for easy sharing with email, message or social networks like facebook, twitter, google+ and vkontakte. 

## Installation

### With source code

- [Download repository](https://github.com/Friend-LGA/LGSharing/archive/master.zip), then add [LGSharing directory](https://github.com/Friend-LGA/LGSharing/blob/master/LGSharing/) to your project.
- Also you need to install libraries:
  - [Google+](https://developers.google.com/+/mobile/ios/)
  - [VKontakte](https://github.com/VKCOM/vk-ios-sdk)

### With CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the "Get Started" section for more details.

#### Podfile

```
platform :ios, '6.0'
pod 'LGSharing', :git => 'https://github.com/Friend-LGA/LGSharing.git'
```

## Usage

First read "Get started" guides of:
- [Google+](https://developers.google.com/+/mobile/ios/getting-started)
- [VKontakte](http://vk.com/dev/ios_sdk)

In the AppDelegate.m import header file and call the LGSharing URL handler from your app delegate's URL handler

```objective-c
#import "LGSharing.h"

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [LGSharing application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
}
```

In the source files where you need to use the library, import the header file:

```objective-c
#import "LGSharing.h"
```

### Initialization

```objective-c
+ (instancetype)sharedManagerWithNavigationController:(UINavigationController *)navigationController
                                              vkAppId:(NSString *)vkAppId               // pass nil if you don't want to use it
                                   googlePlusClientId:(NSString *)googlePlusClientId    // pass nil if you don't want to use it
                                 googlePlusDeepLinkId:(NSString *)googlePlusDeepLinkId; // pass nil if you don't want to use it
```

### More

For more details see [LGSharing.h](https://github.com/Friend-LGA/LGSharing/blob/master/LGSharing/LGSharing.h)

## License

LGSharing is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGSharing/master/LICENSE) for details.
