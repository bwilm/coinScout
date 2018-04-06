//
//  ViewController.swift
//  CoinScout
//
//  Created by Brandon Wilmott on 4/6/18.
//  Copyright © 2018 Brandon Wilmott. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
 

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    
    var finalURL = ""
    
    @IBOutlet weak var bitcoinLabelPIcker: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       self.view.backgroundColor = RandomFlatColor()
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       finalURL = baseURL + currencyArray[row]
     
        currencySelected = currencySymbol[row]
        getBitcoinData(url: finalURL)
        
        
    }
//     MARK: - Networking
    
    func getBitcoinData( url: String){

        Alamofire.request(finalURL, method: .get)
            .responseJSON { response in
                if response.result.isSuccess{
                    print("data was success")
                    
                    let bitcoinJSON : JSON = JSON (response.result.value!)
                    self.updateBitcoinData(json:bitcoinJSON)
                    

                }else{
                    print("there was an error retrieving bitcoindata")
                    
                    self.bitcoinLabelPIcker.text = "Error"
                }

        }


    }

    
    
    
    
     //MARK: - JSON Parsing
    
    func updateBitcoinData (json: JSON){
        
        if let bitcoinResult = json["ask"].double{
            
            bitcoinLabelPIcker.text = currencySelected + String(bitcoinResult)
            
            
        }else{
        
            self.bitcoinLabelPIcker.text = "sorry,unavailable"
        
       
        }
        
        
    


}
}

