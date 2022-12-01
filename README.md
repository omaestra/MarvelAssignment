# MarvelAssignment

# Intro

This repository provides an example iOS app using the Marvel's API as datasource and aims to explain some of the best common practices when developing an iOS app.

The app was built using XCode v13.2.1 and iOS 15.2 as development target.

# How to build:

1. Install dependencies using Cocoapods.

`pod install`

2. Provide Marvel's API public and private keys on the `MarvelAssignmentInfo.plist` file filling up the `MARVEL_API_PRIVATE_KEY` and `MARVEL_API_PUBLIC_KEY` properties values.

3. Select the `MarvelAssignment` target build.

# Architecture:

The application follows the Model-View-Presenter-Coordinator (MVP-C) architecture pattern demostrating a simple but quite organized way of working and fostering separation of concerns.
It is important to point out, that the app implements the Coordinator/Navigator pattern that manages the navigation logic into a separate layer.

Regarding the networking layer, it is also isolated into a separated layer ensuring separation of concerns and abstracting the networking logic. 
The networking layer is composed by two main classes:

1. AlamofireNetworking: This is the main networking class in charge of making http(s) request to the API using Alamofire library.
2. MockNetworking: This is the mock networking class which provides the ability to read a local JSON file (API mock response) localted on the `Resources` folder. Normally used for testing purposes.

Given that there are just a few endpoints, all this logic is handled by the `Endpoint` enum which implements the `URLRequestConvertible` protocol from `Alamofire` which provides all the information to make the API request.
In a real-world app, this would need to be more abstracted using dedicated endpoint enums for each API service.

# Features:

The main features of the app are:

1. Provides a list of characters using the Marvel's API (https://developer.marvel.com/docs)
2. There is a search feature which allows the user to filter characters by name.
3. Character details displaying character relevant information and comics related.
4. Navigating out of the app to an url of interest using Safari.
4. Comic details displaying comic relevant information.

# Testing:

For demostrating purposes, the app implements unit testing only for the business-logic layer, specifically covering the `CharactersListPresenter` class.

# Utils:

There are many Utils classes and extensions to make development easier.

# Third-party libraries:

1. [Alamofire](https://github.com/Alamofire/Alamofire): Networking.
2. [Kingfisher](https://github.com/onevcat/Kingfisher): Image download and caching.
3. [Hero](https://github.com/HeroTransitions/Hero): Animations and transitions.

# Dependency manager:

The app uses `Cocoapods` as dependency manager.
