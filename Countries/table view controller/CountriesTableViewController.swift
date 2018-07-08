//
//  CountriesTableViewController.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import UIKit
import Alamofire

class CountriesTableViewController: NSObject , UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate{

    var allCountries = [CountryOBJ](){
        didSet {
            filteredCountries.removeAll()
            filteredCountries.append(contentsOf: allCountries)
        }
    }
    var filteredCountries = [CountryOBJ]()
    
    var isSearching = false
    var mainViewControllerProtocol : ReloadTableViewDataProtocol?
  
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearching{
            return filteredCountries.count
        }
        return allCountries.count

    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currentCountriesToDisplay =  allCountries
        if isSearching{
            currentCountriesToDisplay.removeAll()
            currentCountriesToDisplay.append(contentsOf: filteredCountries)
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryTableViewCell{
           
                cell.countyLBL.text = currentCountriesToDisplay[indexPath.row].name
                cell.capitalLBL.text = currentCountriesToDisplay[indexPath.row].capital

            if let imageUrlString = currentCountriesToDisplay[indexPath.row].flagUrl{
                let html = "<img src='\(imageUrlString)' width='100' height = '80%' >"
                cell.webImageContainer.loadHTMLString(html, baseURL: nil)
            }

            return cell
        }
        return UITableViewCell()
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("didchange")
        if searchBar.text == nil || searchBar.text == ""{

            searchBar.endEditing(true)
            isSearching = false
            self.mainViewControllerProtocol?.reloadTableData()

        }else{
            print("didchange not nil")
            filteredCountries.removeAll()
           // allCountries.removeAll()
            isSearching = true
   
            filteredCountries = allCountries.filter({ (county) -> Bool in
                
                var textToSearchinto : NSString = ""
                let name = county.name
                let capital = county.capital
                textToSearchinto = (name! + " " + capital!) as NSString
                
                let range = textToSearchinto.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            self.mainViewControllerProtocol?.reloadTableData()
        }
    }
}
