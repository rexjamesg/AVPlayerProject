//
//  VideoSource.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

protocol VideoDetail {
    var description:String { get }
    var sources:String { get }
    var subtitle:String { get }
    var title:String { get }
    var fullImagePath:String { get }
}

enum VideoSourceType:Int, CaseIterable {
    case bigBuckBunny
    case elephantDream
    case forBiggerBlazes
    case forBiggerEscape
    case forBiggerFun
    case forBiggerJoyrides
    case forBiggerMeltdowns
    case sintel
    case subaruOutbackOnStreetAndDirt
    case tearsOfSteel
    case volkswagenGTIReview
    case weAreGoingOnBullrun
    case whatCareCanYouGetForAGrand
}

extension VideoSourceType: VideoDetail {
    
    var description:String {
        switch self {
        case .bigBuckBunny:
            return "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org"
            
        case .elephantDream:
            return "The first Blender Open Movie from 2006"
            
        case .forBiggerBlazes:
            return "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast."
                        
        case .forBiggerEscape:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For $35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast."
            
        case .forBiggerFun:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For $35. Find out more at google.com/chromecast."
        
        case .forBiggerJoyrides:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for the times that call for bigger joyrides. For $35. Learn how to use Chromecast with YouTube and more at google.com/chromecast."
            
        case .forBiggerMeltdowns:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when you want to make Buster's big meltdowns even bigger. For $35. Learn how to use Chromecast with Netflix and more at google.com/chromecast."
            
        case .sintel:
            return "Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film.\nThis 15 minute film has been realized in the studio of the Amsterdam Blender Institute, by an international team of artists and developers. In addition to that, several crucial technical and creative targets have been realized online, by developers and artists and teams all over the world.\nwww.sintel.org"
            
        case .subaruOutbackOnStreetAndDirt:
            return "Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers."
            
        case .tearsOfSteel:
            return "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands. The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras. (CC) Blender Foundation - http://www.tearsofsteel.org"
            
        case .volkswagenGTIReview:
            return "The Smoking Tire heads out to Adams Motorsports Park in Riverside, CA to test the most requested car of 2010, the Volkswagen GTI. Will it beat the Mazdaspeed3's standard-setting lap time? Watch and see..."
            
        case .weAreGoingOnBullrun:
            return "The Smoking Tire is going on the 2010 Bullrun Live Rally in a 2011 Shelby GT500, and posting a video from the road every single day! The only place to watch them is by subscribing to The Smoking Tire or watching at BlackMagicShine.com"
            
        case .whatCareCanYouGetForAGrand:
            return "The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car."
        }
    }
    
    var sources:String {
        switch self {
        case .bigBuckBunny:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
            
        case .elephantDream:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
            
        case .forBiggerBlazes:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
            
        case .forBiggerEscape:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
            
        case .forBiggerFun:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
        
        case .forBiggerJoyrides:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
            
        case .forBiggerMeltdowns:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
            
        case .sintel:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
            
        case .subaruOutbackOnStreetAndDirt:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4"
            
        case .tearsOfSteel:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
            
        case .volkswagenGTIReview:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4"
            
        case .weAreGoingOnBullrun:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"
            
        case .whatCareCanYouGetForAGrand:
            return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"            
        }
    }
    
    var subtitle:String {
        switch self {
        case .bigBuckBunny:
            return "By Blender Foundation"
            
        case .elephantDream:
            return "By Blender Foundation"
            
        case .forBiggerBlazes:
            return "By Google"
            
        case .forBiggerEscape:
            return "By Google"
            
        case .forBiggerFun:
            return "By Google"
        
        case .forBiggerJoyrides:
            return "By Google"
            
        case .forBiggerMeltdowns:
            return "By Google"
            
        case .sintel:
            return "By Blender Foundation"
            
        case .subaruOutbackOnStreetAndDirt:
            return "By Garage419"
            
        case .tearsOfSteel:
            return "By Blender Foundation"
            
        case .volkswagenGTIReview:
            return "By Garage419"
            
        case .weAreGoingOnBullrun:
            return "By Garage419"
            
        case .whatCareCanYouGetForAGrand:
            return "By Garage419"
        }
    }
    
    var thumb:String {
        switch self {
        case .bigBuckBunny:
            return "images/BigBuckBunny.jpg"
            
        case .elephantDream:
            return "images/ElephantsDream.jpg"
            
        case .forBiggerBlazes:
            return "images/ForBiggerBlazes.jpg"
            
        case .forBiggerEscape:
            return "images/ForBiggerEscapes.jpg"
            
        case .forBiggerFun:
            return "images/ForBiggerFun.jpg"
        
        case .forBiggerJoyrides:
            return "images/ForBiggerJoyrides.jpg"
            
        case .forBiggerMeltdowns:
            return "images/ForBiggerMeltdowns.jpg"
            
        case .sintel:
            return "images/Sintel.jpg"
            
        case .subaruOutbackOnStreetAndDirt:
            return "images/SubaruOutbackOnStreetAndDirt.jpg"
            
        case .tearsOfSteel:
            return "images/TearsOfSteel.jpg"
            
        case .volkswagenGTIReview:
            return "images/SubaruOutbackOnStreetAndDirt.jpg"
            
        case .weAreGoingOnBullrun:
            return "images/WeAreGoingOnBullrun.jpg"
            
        case .whatCareCanYouGetForAGrand:
            return "images/WhatCarCanYouGetForAGrand.jpg"
        }
    }
    
    var title:String {
        switch self {
        case .bigBuckBunny:
            return "Big Buck Bunny"
            
        case .elephantDream:
            return "Elephant Dream"
            
        case .forBiggerBlazes:
            return "For Bigger Blazes"
            
        case .forBiggerEscape:
            return "For Bigger Escape"
            
        case .forBiggerFun:
            return "For Bigger Fun"
        
        case .forBiggerJoyrides:
            return "For Bigger Joyrides"
            
        case .forBiggerMeltdowns:
            return "For Bigger Meltdowns"
            
        case .sintel:
            return "Sintel"
            
        case .subaruOutbackOnStreetAndDirt:
            return "Subaru Outback On Street And Dirt"
            
        case .tearsOfSteel:
            return "Tears of Steel"
            
        case .volkswagenGTIReview:
            return "Volkswagen GTI Review"
            
        case .weAreGoingOnBullrun:
            return "We Are Going On Bullrun"
            
        case .whatCareCanYouGetForAGrand:
            return "What care can you get for a grand?"
            
        }
    }
    
    var fullImagePath:String {
        /*
        if self == .bigBuckBunny {
            
        } else {
         
        }
        */
        return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/"+thumb
    }
}

class VideoSource: NSObject {
    
    private(set) var videos:[Video] = []
    
    override init() {
        super.init()
        
        for sourceType in VideoSourceType.allCases {
            
            let video = Video.init(description: sourceType.description,
                                   sources: sourceType.sources,
                                   subtitle: sourceType.subtitle,
                                   thumb: sourceType.fullImagePath,
                                   title: sourceType.title)
            videos.append(video)
        }
    }
    
    func getVideos() -> Categories {
        return Categories.init(name: "Movies", videos: videos)
    }
}
