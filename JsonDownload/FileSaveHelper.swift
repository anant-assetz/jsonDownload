//
//  FileSaveHelper.swift
//  JsonDownload
//
//  Created by Anant on 09/05/2016.
//  Copyright © 2016 Anant. All rights reserved.
//

import Foundation
// 1
import UIKit

class FileSaveHelper {
    
    // MARK:- Error Types
    
    private enum FileErrors:ErrorType {
        case JsonNotSerialized
        case FileNotSaved
        case ImageNotConvertedToData
        case FileNotRead
        case FileNotFound
    }
    
    
    // MARK:- File Extension Types
    enum FileExension:String {
        case TXT = ".txt"
        case JPG = ".jpg"
        case JSON = ".json"
    }
    
    // MARK:- Private Properties
    private let directory:NSSearchPathDirectory
    private let directoryPath: String
    private let fileManager = NSFileManager.defaultManager()
    private let fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    
   
    var fileExists:Bool {
        get {
            return fileManager.fileExistsAtPath(fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExistsAtPath(filePath, isDirectory: &isDir )
        }
    }
    
    // 1
    convenience init(fileName:String, fileExtension:FileExension, subDirectory:String){
        // 2
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:subDirectory, directory:.DocumentDirectory)
    }

    // 1
    convenience init(fileName:String, fileExtension:FileExension){
        // 2
        self.init(fileName:fileName, fileExtension:fileExtension, subDirectory:"", directory:.DocumentDirectory)
    }
    
    init(fileName:String, fileExtension:FileExension, subDirectory:String, directory:NSSearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        //3
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        //4
        print(self.directoryPath)
        
        createDirectory()
    
    }
    
    private func createDirectory(){
        //1
        if !directoryExists {
            do {
                //2
                try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }
    
    //1
    func saveFile(string fileContents:String) throws{
        do {
            //2
            try fileContents.writeToFile(fullyQualifiedPath, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch  {
            //3
            throw error
        }
    }
    
    //1
    func saveFile(dataForJson dataForJson:AnyObject) throws{
        do {
            //2
            let jsonData = try convertObjectToData(dataForJson)
            if !fileManager.createFileAtPath(fullyQualifiedPath, contents: jsonData, attributes: nil){
                throw FileErrors.FileNotSaved
            }
        } catch {
            //3
            print(error)
            throw FileErrors.FileNotSaved
        }
        
    }
    
    // 1
    func saveFile(image:String) throws {
        
        var img:UIImage
        
        let pathFile = "http://investors.assetz.co.uk/prop-images/resp-listing/"

        let url = NSURL(string: "\(pathFile)\(image)")!
        if let data = NSData(contentsOfURL: url) {
            img = UIImage(data: data)!
        } else {
            img = UIImage(named: "logo")!
        }
        
        // 2
        guard let data = UIImageJPEGRepresentation(img, 1.0) else {
            throw FileErrors.ImageNotConvertedToData
        }
        // 3
        if !fileManager.createFileAtPath(fullyQualifiedPath, contents: data, attributes: nil){
            throw FileErrors.FileNotSaved
        }
    }
    
    //4
    private func convertObjectToData(data:AnyObject) throws -> NSData {
        
        do {
            //5
            let newData = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            return newData
        }
            //6
        catch {
            print("Error writing data: \(error)")
        }
        throw FileErrors.JsonNotSerialized
    }
    
    // 1
    func getContentsOfFile() throws -> String {
        // 2
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        // 3
        var returnString:String
        do {
            returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: NSUTF8StringEncoding)
        } catch {
            throw FileErrors.FileNotRead
        }
        // 4
        return returnString
    }
    
    func getImage() throws -> UIImage {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        print(fullyQualifiedPath)
        guard let image = UIImage(contentsOfFile: fullyQualifiedPath) else {
            throw FileErrors.FileNotRead
        }
        print(fullyQualifiedPath)
        
        return image
    }
    
    // 1
    func getJSONData() throws -> AnyObject {
        // 2
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        print("What is this")
        
        do {
            // 3
            let data = try NSData(contentsOfFile: fullyQualifiedPath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            // 4
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! AnyObject
            return jsonDictionary
            
        } catch {
            throw FileErrors.FileNotRead
        }
    }
    
}