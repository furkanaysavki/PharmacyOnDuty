//
//  ViewController.swift
//  PharmacyOnDuty
//
//  Created by Furkan Ayşavkı on 17.03.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var distArray = [String]()
    var addressArray = [String]()
    var phoneArray = [String]()
    var locArray = [String]()
    
    var chosenName = ""
    var chosenAdress = ""
    var chosenNumber = ""
    var chosenLocate = ""
    var il = ""
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sehirAdiLabel: UITextField!
    @IBAction func araButtonClicked(_ sender: Any) {
    
    
    if sehirAdiLabel.text != "" {
            
            il = sehirAdiLabel.text!
            title = "\(il) Nöbetçi Eczaneler".capitalized
            
            il = try! sehirAdiLabel.text!.lowercased().convertedToSlug()
            
            
            sehirAdiLabel.text = ""
            
            nameArray.removeAll()
            distArray.removeAll()
            addressArray.removeAll()
            phoneArray.removeAll()
            locArray.removeAll()
            tableView.reloadData()
            
            getData()
        }
        
        else{
            let alert = UIAlertController(title: "Error", message: "Lütfen bir şehir adı giriniz", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                  print(" ")
            }))
            present(alert, animated: true, completion: nil)
        }
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.timeZone = TimeZone(abbreviation: "UTC+3")!
        formatter.locale = Locale(identifier: "tr-TR")
        
        let utcTimeZoneStr = formatter.string(from: date)
       
        
        dateLabel.text = "\(utcTimeZoneStr) günü nöbetçi eczaneler"
        
        title = "\(il.capitalized) Nöbetçi Eczaneler"
        
        
       
        
       
    }
    
    func getData() {
        
        
        let headers = [
            "content-type": "application/json",
            "authorization": "apikey 5KKBUOO0aI7c8tHEalhWfa:0rb4sVRnEobwnEy6yj1M3W"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/health/dutyPharmacy?il=\(il)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            }
            else {
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                   
                    
                    if let pharmacyArray = jsonResponse!.value(forKey: "result") as? NSArray {
                        for pharmacy in pharmacyArray{
                            if let pond = pharmacy as? NSDictionary {
                                if let name = pond.value(forKey: "name") {
                                    self.nameArray.append(name as! String)
                                }
                                if let name = pond.value(forKey: "dist") {
                                    self.distArray.append(name as! String)
                                }
                                if let name = pond.value(forKey: "address") {
                                    self.addressArray.append(name as! String)
                                }
                                if let name = pond.value(forKey: "phone") {
                                    self.phoneArray.append(name as! String)
                                }
                                if let name = pond.value(forKey: "loc") {
                                    self.locArray.append(name as! String)
                                }
                            }
                        }
                    }
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                    
                }
                catch {
                    print("Error")
                }
            }
        })
        dataTask.resume()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
               return UITableView.automaticDimension
           } else {
               return 40
           }
       }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableCell
        
        cell.pharmacyNameLabel.text = nameArray[indexPath.row].uppercased()
        
        if cell.pharmacyNameLabel.text!.hasSuffix("Sİ") || cell.pharmacyNameLabel.text!.hasSuffix("SI")  == true {

        }
        else{
            cell.pharmacyNameLabel.text!.append(" ECZANESİ")
        }
        
        cell.districtName.text = "·" + distArray[indexPath.row].capitalized
        cell.adressName.text = addressArray[indexPath.row].capitalized
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        chosenName = nameArray[indexPath.row]
        chosenAdress = addressArray[indexPath.row]
        chosenNumber = phoneArray[indexPath.row]
        chosenLocate = locArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.selectedName = chosenName
            destinationVC.selectedAdrress = chosenAdress
            destinationVC.selectedPhone = chosenNumber
            destinationVC.selectedLoc = chosenLocate
        }
    }
    
    }


enum SlugConversionError: Error {
    case failedToConvert
}

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    private func convertedToSlugBackCompat() -> String? {
        if let data = self.data(using: .ascii, allowLossyConversion: true) {
            if let str = String(data: data, encoding: .ascii) {
                let urlComponents = str.lowercased().components(separatedBy: String.slugSafeCharacters.inverted)
                return urlComponents.filter { $0 != "" }.joined(separator: "-")
            }
        }
        return nil
    }

    public func convertedToSlug() throws -> String {
        var result: String? = nil

        #if os(Linux)
            result = convertedToSlugBackCompat()
        #else
            if #available(OSX 10.11, *) {
                if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
                    let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
                    result = urlComponents.filter { $0 != "" }.joined(separator: "-")
                }
            } else {
                result = convertedToSlugBackCompat()
            }
        #endif

        if let result = result {
            if result.count > 0 {
                return result
            }
        }

        throw SlugConversionError.failedToConvert
    }
}
