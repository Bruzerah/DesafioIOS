//
//  Networking.swift
//  HakerRank - Bruno Vavretchek
//
//  Created by Bruno Lourenço on 16/07/2018.
//  Copyright © 2018 BrunoVavretchek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


func getApiData(completion: @escaping ([Cerveja]) -> ()){
    guard let urlString = URL(string: "https://api.punkapi.com/v2/beers") else {
        print("URL Error")
        return
    }
    Alamofire.request(urlString).responseJSON { response in
        
        if response.data == response.data{
            do{
                let decoder = try JSONDecoder().decode([Cerveja].self, from: response.data!)

                completion(decoder)
            }catch{
        print(error)
            }
        }else{print("API Response is Empty")}
 
        }
}
