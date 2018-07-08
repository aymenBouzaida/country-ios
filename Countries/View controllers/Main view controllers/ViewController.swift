//
//  ViewController.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import UIKit

class ViewController: UIViewController , ReloadTableViewDataProtocol{

    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var countriesSearchBar: UISearchBar!
    
    var countriesTVC : CountriesTableViewController?
    
      // MARK: - vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        countriesTVC = CountriesTableViewController()
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = countriesTVC
        
        countriesSearchBar.delegate = countriesTVC
        
        countriesTVC?.mainViewControllerProtocol = self
        requestDataFromServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBActions
    @IBAction func reloadDataFromServerAction(_ sender: Any) {
        requestDataFromServer()
    }

    func requestDataFromServer(){
        RestCountriesManager.sharedInstance.getCountriesFromServer { (countriesResponse, error) in
            if error == nil{
                
                self.countriesTVC?.allCountries = countriesResponse
                self.countriesTableView.reloadData()
                if self.countriesTableView.isHidden{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.countriesTableView.isHidden = false
                    })
                }
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.countriesTableView.isHidden = true
                })
            }
        }
    }
    
    // Mark: -- protocol func
    func reloadTableData(){
        self.countriesTableView.reloadData()
    }
    
    // Mark: -- prepare for navigation 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            if let destinationViewController = segue.destination as? CountryDetailsViewController , let tableViewControllerDataSource = countriesTVC{
                
                // get the used array of countries ( all or filtered)
                var usedCountriesList = tableViewControllerDataSource.allCountries
                if tableViewControllerDataSource.isSearching{
                    usedCountriesList.removeAll()
                    usedCountriesList.append(contentsOf: tableViewControllerDataSource.filteredCountries)
                }
                
                if let selectedRowIndexPath = countriesTableView.indexPathsForSelectedRows?.first{
                    destinationViewController.passedCountryName = usedCountriesList[selectedRowIndexPath.row].name
                }
                
            }
        }
    }
}

// MARK: - table view delegate

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
}
