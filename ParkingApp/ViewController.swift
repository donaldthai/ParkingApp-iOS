//
//  ViewController.swift
//  ParkingApp
//
//  Created by user141581 on 7/1/18.
//  Copyright © 2018 dthai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startDateTime: UIDatePicker!
    @IBOutlet weak var endDateTime: UIDatePicker!
    @IBOutlet weak var yourRateLabel: UILabel!
    @IBOutlet weak var yourRateValue: UILabel!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func GetRatesBtnPressed(_ sender: Any) {
        self.yourRateLabel.isHidden = true;
        self.yourRateValue.isHidden = true;
        self.loadingIcon.isHidden = false;
        self.loadingIcon.startAnimating()
        
        // Format date time
        let dateformatter = DateFormatter()
        //yyyy-MM-ddTHH:mm:ssZ
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var urlString = "http://localhost:33337/api/rates?"
        urlString += "startDateTime=" + dateformatter.string(for: startDateTime.date)!
        urlString += "&endDateTime=" + dateformatter.string(for: endDateTime.date)!
        
        //make the request to our WEB API
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }            
            //Decode retrived data with JSONDecoder and assing type of string
            let parkingRateData = String( data:data, encoding:String.Encoding.utf8)!
                
            //Get back to the main queue
            DispatchQueue.main.async {
                self.yourRateLabel.isHidden = false;
                self.yourRateValue.isHidden = false;
                self.loadingIcon.isHidden = true;
                self.loadingIcon.stopAnimating()
                
                //print(articlesData)
                let num = Int(parkingRateData)
                if num != nil {
                    let price = (parkingRateData as NSString).doubleValue / 100
                    self.yourRateValue.text = String(format: "$%.02f", price)
                    self.yourRateValue.reloadInputViews()
                }
                else {
                   print(parkingRateData) //debug
                   self.yourRateValue.text = "unavailable"
                   self.yourRateValue.reloadInputViews()
                }
            }
        }.resume()
        
    }
    
    
}

