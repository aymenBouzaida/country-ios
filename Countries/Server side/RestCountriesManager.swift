//
//  RestCountriesManager.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class RestCountriesManager{
    
    private init() { }
    
    // MARK: Shared Instance
    static let sharedInstance = RestCountriesManager()
    
    private let mainUrl = "https://restcountries.eu/rest/v2/"
    
    private var countries = [CountryOBJ]()
    
    func getCountriesFromServer(completionHandler: @escaping ([CountryOBJ], Error?) -> ()) {

        let endpoint = mainUrl + "all"
      
        Alamofire.request(endpoint).responseJSON { response in
            switch response.result {
            case .success:

                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)

                    if let countriesJsonArray = swiftyJsonVar.array{

                        for i in 0 ..< countriesJsonArray.count{

                            let newCountry = CountryOBJ()
                                newCountry.flagUrl = countriesJsonArray[i]["flag"].stringValue
                                newCountry.name = countriesJsonArray[i]["name"].stringValue
                                newCountry.capital = countriesJsonArray[i]["capital"].stringValue
                            self.countries.append(newCountry)
                        }
                        
                    }
                    completionHandler(self.countries,nil)
                }
            case .failure(let error):
                print(error)
                completionHandler([],error)
            }
        }
    }
    
    // get full country detail
    func getSingleCountryDetails(name : String , completionHandler: @escaping (CountryOBJ?, Error?) -> ()) {
        
        let endpoint = mainUrl + "name/" + name + "?fullText=true"

        // fixing spaces and special chars to fit url needs
        guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        
        Alamofire.request(encoded).responseJSON { response in
            switch response.result {
            case .success:
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    let newCountry = CountryOBJ()
                    
                    if let countriesJsonArray = swiftyJsonVar.array ,let firstCountry = countriesJsonArray.first{
                        
                        newCountry.flagUrl = firstCountry["flag"].stringValue
                        newCountry.name = firstCountry["name"].stringValue
                        newCountry.capital = firstCountry["capital"].stringValue
                        newCountry.population = firstCountry["population"].intValue
                       
                        let _ = firstCountry["borders"].arrayValue.map{ newCountry.borders.append($0.stringValue)}
                        
                        if let currenciesJsonArray = firstCountry["currencies"].array , currenciesJsonArray.count > 0{
                            
                            let newCurrency = CurrencyOBJ()
                            newCurrency.name = currenciesJsonArray[0]["name"].stringValue
                            newCurrency.symbol = currenciesJsonArray[0]["symbol"].stringValue
                            newCurrency.code = currenciesJsonArray[0]["code"].stringValue
                            newCountry.currency = newCurrency
                        }
                    }
                    completionHandler(newCountry,nil)
                }
            case .failure(let error):
                
                print(error)
                completionHandler(nil,error)
            }
        }
    }
    
    // get countries (borders) using each one's code
    func getBorders(borders : [String] , completionHandler: @escaping ([CountryOBJ], Error?) -> ()) {
        
        var endpoint = mainUrl + "alpha?codes="
        
        for borderCode in borders{
            endpoint += borderCode
            if let last = borders.last, last != borderCode{
                endpoint += ";"
            }
        }
     
        guard let encoded = endpoint.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        
        Alamofire.request(encoded).responseJSON { response in
            switch response.result {
            case .success:
                    self.countries.removeAll()
                    
                    if((response.result.value) != nil) {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if let countriesJsonArray = swiftyJsonVar.array{

                            for i in 0 ..< countriesJsonArray.count{
                                
                                let newCountry = CountryOBJ()
                                newCountry.flagUrl = countriesJsonArray[i]["flag"].stringValue
                                newCountry.name = countriesJsonArray[i]["name"].stringValue
                                newCountry.capital = countriesJsonArray[i]["capital"].stringValue
                                self.countries.append(newCountry)
                            }
                        }
                    }
                    completionHandler(self.countries,nil)
                
            case .failure(let error):
                print(error)
                completionHandler([],error)
            }
        }
    }
    
}
