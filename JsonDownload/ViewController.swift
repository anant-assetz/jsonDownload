//
//  ViewController.swift
//  JsonDownload
//
//  Created by Anant on 05/05/2016.
//  Copyright © 2016 Anant. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var NumberofRows = 0
   
    var propArray = [Property]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJsonData("ViewDidLoad")
        //saveTextFile("Hello World")
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    func saveTextFile(newMsg:String){
        
        let testFile = FileSaveHelper(fileName: "testFile", fileExtension: .TXT, subDirectory: "SavingFiles", directory: .DocumentDirectory)
        
        print("Directory exists: \(testFile.directoryExists)")
        print("File exists: \(testFile.fileExists)")
        
        let fileText = newMsg
        do {
            
            try testFile.saveFile(string: fileText)
        }
        catch {
            
            print(error)
        }
        
        testFile.fileExists
        
        do {
            print(  try testFile.getContentsOfFile())
        } catch {
            print (error)
        }

    }
    
    func getJsonData(from:String){
        print(from)
        let jsonUrl = "http://www.assetz.co.uk/scripts/json-prop-list.php"
        let shotsUrl:NSURL = NSURL(string: jsonUrl)!
       
        let session = NSURLSession.sharedSession()
        //let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: shotsUrl)
        let task = session.dataTaskWithURL(shotsUrl) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
            
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                //self.propArray = jsonData as! [Property]
                
                let count = jsonData.count
                self.NumberofRows = count
                
                for index in 0..<count {
                    
                    let propID = jsonData[index]["propID"] as? String
                    var propName = jsonData[index]["propName"] as? String
                    let propMainImage = jsonData[index]["propMainImage"] as? String
                    //let propLowPrice = jsonData[index]["propLowPrice"] as? String
                    //let propHighPrice = jsonData[index]["propHighPrice"] as? String
                    //let propSummary:String! = jsonData[index]["propSummary"]!! as AnyObject as! String
                    //let propDescription:String! = jsonData[index]["propDescription"]!! as AnyObject as! String
                    //let propLocation:String! = jsonData[index]["propLocation"]!! as AnyObject as! String
                    
                    print(propID!)
                    print(propName!)
                    print(propMainImage!)
                    //print(propLowPrice!)
                    //print(propHighPrice!)
                    //print(propSummary!)
                    //print(propDescription!)
                    //print(propLocation!)
                    
                    //self.getImageFiles(propMainImage)
                    
                    if (propName == nil) {
                        propName = "none"
                    }
                    
                    var propertyline = Property(propID: propID!, propDesc: propName!, imagePath: propMainImage!)
                    self.propArray.append(propertyline)
                    print("This is counting \(self.propArray.count)")

                }
    
                let jsonDict = jsonData
                
                //2
                let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .DocumentDirectory)
                
                //3
                do {
                    try jsonFile.saveFile(dataForJson: jsonDict)
                }
                catch {
                    print(error)
                }
                

               /*do {
                    print(try jsonFile.getJSONData())
                } catch {
                    print(error)
                }
                */
                
                //4
                print("JSON file exists: \(jsonFile.fileExists)")
                
            } catch _ {
                print(error)
                // Error
            }
        }
        }
        task.resume()
    
    }
    
    var img: UIImage!
    //let imagePathFile = "http://investors.assetz.co.uk/prop-images/resp-listing/"
    
    func getImageFiles(imgName:String){
        
        var imgNameArray = imgName.characters.split{$0 == "."}.map(String.init)
        var imageNameOnly = imgNameArray[0]
        
        //let fullPathName = "\(self.imagePathFile)7726_1454581127.jpg"
        img = UIImage(named: imgName)
        
        // 1
        let imageToSave = FileSaveHelper(fileName: imageNameOnly, fileExtension: .JPG, subDirectory: "image", directory: .DocumentDirectory)
        
        // 2
        do {
            
            try imageToSave.saveFile(imgName)
            // 3
            guard let image = UIImage(named: imageNameOnly) else {
                print("Error getting image")
                return
            }
            // 4
            
        }
            // 5
        catch {
            print(error)
        }
        
    }
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("No of Rows \(self.propArray.count)")
        return self.propArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let jsonCount = self.propArray.count
        print("This is count \(jsonCount)")
       
        if let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell") as? propList {
        
            print("Checking Data")
            
            NumberofRows = jsonCount - 1
           
            if NumberofRows > 0 {
                
                    print("got Data")
                let property = self.propArray[indexPath.row]
                
                if let cell = tableView.dequeueReusableCellWithIdentifier("propertyCell") as? propList {
                    cell.configureCell(property)
                    print("A")
                    return cell
                }else{
                    let cell = propList()
                    cell.configureCell(property)
                    print("B")
                    return cell
                }


                    /*
                    for i in 0...NumberofRows {
            
                    do{
                        var propertyID = property["prop_ID"] as! String
                        var propertyImage = property["imagePath"] as! String
                        print("\(propertyID) - \(indexPath.row)")
                   
                        var imgName2Array = propertyImage.characters.split{$0 == "."}.map(String.init)
                        let imageName2Only = imgName2Array[0]
                        //print(imageName2Only)
                    
                        let testFile = FileSaveHelper(fileName: "\(imageName2Only)", fileExtension: .JPG, subDirectory: "image", directory: .DocumentDirectory)
                   
                        let img = try testFile.getImage()
                        print(img)
                        cell.configureCell(img , text: propertyID as! String)
                        
                        
                    //cell.propCellImage2.image = img
                    //cell.propCellName2.text = propertyID as! String
                    
                    } catch {
                        print(error)
                    }
                
                //cell.propCellImage = testFile as UIImage
                    
                }
            */
                
            }else{           //cell.configureCell(img, text: testFile)
                
                getJsonData("Table View Else Statement")
                print("getting Data")
                
            }
            return cell
        } else {
            return propList()
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}