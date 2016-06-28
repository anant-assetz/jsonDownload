//
//  Property.swift
//  JsonDownload
//
//  Created by Anant on 22/06/2016.
//  Copyright © 2016 Anant. All rights reserved.
//

import Foundation

class Property {
    
    private var _propID: String
    private var _propDesc: String
    private var _imagePath: String
    
    var propID: String{
        return _propID
    }
    
    var propDesc: String {
        return _propDesc
    }
    
    var imagePath: String {
        return _imagePath
    }
    
    init(propID: String, propDesc: String, imagePath:String ){
        self._propID = propID
        self._propDesc = propDesc
        self._imagePath = imagePath
        
        //print(self._propID)
    }
    
}