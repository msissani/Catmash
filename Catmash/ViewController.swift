//
//  ViewController.swift
//  Catmash
//
//  Created by MacBook on 27/01/2018.
//  Copyright © 2018 DataMind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //json url file
    let URL_CATS = "https://latelier.co/data/cats.json";
    let URL_IMAGE = URL(string: "http://www.simplifiedtechy.net/wp-content/uploads/2017/07/simplified-techy-default.png")
    //label containing cats list
    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var imageViewCat: UIImageView!
    
    
    var nameArray = [String]()
    var urlArray = [String]()
    var imageCatArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //function that will fetch the JSON
        getJsonFromUrl();
        showImage();
        
        
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        self.imageViewCat.image = image
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getJsonFromUrl(){
        let url = NSURL(string: URL_CATS)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response,error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                //printing the json in console
                print(jsonObj!.value(forKey: "images")!)
                
                //getting the avengers tag array from json and converting it to NSArray
                if let catArray = jsonObj!.value(forKey: "images") as? NSArray {
                    //looping through all the elements
                    for cat in catArray{
                        
                        //converting the element to a dictionary
                        if let catDict = cat as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if let name = catDict.value(forKey: "id") {
                                
                                //adding the name to the array
                                self.nameArray.append((name as? String)!)
                            }
                            
                            //GETTING THE URL OF IMAGE CAT FROM DICTIONARY
                            if let url = catDict.value(forKey: "url") {
                                
                                //adding the url to the array
                                self.urlArray.append((url as? String)!)
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.showNames()
                    print(self.nameArray.count)
               //     self.showImage()
                })
            }
        }).resume()
    }
    
    func showNames(){
        //looing through all the elements of the array
        for url in urlArray{
            
            //appending the names to label
            labelTest.text = labelTest.text! + url + "\n";

        }
    }
    
    func showImage(){
    
         //   imageViewCat.image = imageCatArray[0]
        

        
    }
}

