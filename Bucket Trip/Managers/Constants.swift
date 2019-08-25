//
//  Extensions.swift
//  Funny Snap
//
//  Created by Dulal Hossain on 2/21/17.
//  Copyright © 2017 deveyes. All rights reserved.
//

import UIKit

struct Constants {
   
    struct Text {
        static let PROGRESS_TITLE = "Caricamento..."
        
        static let EMPTY_GALLERY_TITLE = "Non hai ancora creato nessuno Snap!\nApri il menu e scegli Fai una foto” per iniziare. Se hai qualche dubbio puoi riguardare il tutorial"
        static let GALLERY_EMPTY_ACTION_TITLE = "Tutorial"
    }
    
    struct ScreenSize
    {
        static let WIDTH         = UIScreen.main.bounds.size.width
        static let HEIGHT        = UIScreen.main.bounds.size.height
        static let MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
        static let MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    }
}
