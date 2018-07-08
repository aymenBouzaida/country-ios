//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import UIKit

class CountryDetailsViewController: UIViewController   {

    @IBOutlet weak var requestForDataFailedLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var imageWebView: UIWebView!
    @IBOutlet weak var capitalLBL: UILabel!
    @IBOutlet weak var populationLBL: UILabel!
    @IBOutlet weak var currencyCodeSymbolLBL: UILabel!
    @IBOutlet weak var cureencyNameLBL: UILabel!
    @IBOutlet weak var bordersTableView: UITableView!
    
    var passedCountryName : String?
    var passedCountry : CountryOBJ?
    
    var countriesTVC : CountriesTableViewController?

    // Mark: -- vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesTVC = CountriesTableViewController()
        
        bordersTableView.delegate = self
        bordersTableView.dataSource = countriesTVC
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let passedCountry = passedCountry{
            print("halo")
            bindViewWithData(country: passedCountry)
        }else{
            getCountryDataFromServer()
        }
    }
    
    
    func getCountryDataFromServer(){
        
        if let currentCountry = passedCountryName{
            RestCountriesManager.sharedInstance.getSingleCountryDetails(name: currentCountry) { (country, error) in
                if let country = country , error == nil {
                    print("hi")
                    self.bindViewWithData(country: country)
                }else{
                    UIView.animate(withDuration: 0.4, animations: {
                        self.requestForDataFailedLBL.isHidden = false
                    })
                }
            }
        }
    }
    
    
    func bindViewWithData(country : CountryOBJ){
        
        self.titleLBL.text = country.name
        self.capitalLBL.text = country.capital ??  "----"
        self.populationLBL.text = (country.population?.description) ?? "----"
        if let imageUrlString = country.flagUrl{
            let html = "<img src='\(imageUrlString)' width='100%' height = '80%' >"
            self.imageWebView.loadHTMLString(html, baseURL: nil)
        }
        self.cureencyNameLBL.text = (country.currency?.name) ?? "----"
        self.currencyCodeSymbolLBL.text = ((country.currency?.code) ?? "") + " (\( (country.currency?.symbol) ?? ""))"
        
        RestCountriesManager.sharedInstance.getBorders(borders: country.borders, completionHandler: { (countries, error) in
            if error == nil{
                self.countriesTVC?.allCountries = countries
                self.bordersTableView.reloadData()
            }
            if countries.isEmpty{
                self.bordersTableView.isHidden = true
            }
        })
    }
    
    // Mark: -- IBAction

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

// Mark: -- table view delegate
extension CountryDetailsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedCountry = countriesTVC?.allCountries[indexPath.row]
        
        if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailsVCSBID") as? CountryDetailsViewController{

            detailsViewController.passedCountry = selectedCountry
            self.navigationController?.show(detailsViewController, sender: true)
        }
        
    }
}
