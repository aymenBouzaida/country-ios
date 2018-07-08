//
//  ReloadTableViewData.swift
//  Countries
//
//  Created by AYMEN on 7/7/18.
//  Copyright © 2018 BOUZAIDA. All rights reserved.
//

import Foundation

// i created this protocol to reload tableViewData cause in tableViewController class self.tablview.reloadData() is not working
protocol ReloadTableViewDataProtocol {
    func reloadTableData()
}
