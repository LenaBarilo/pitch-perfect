//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Yelena Barilo on 3/27/15.
//  Copyright (c) 2015 Yelena Barilo. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {

    var filePathURL: NSURL!
    var title: String!
    
    init(path: NSURL!, name: String!){
        filePathURL = path
        title = name
    }
}
