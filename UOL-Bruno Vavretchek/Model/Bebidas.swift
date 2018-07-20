//
//  Bebidas.swift
//  HakerRank - Bruno Vavretchek
//
//  Created by Bruno Lourenço on 16/07/2018.
//  Copyright © 2018 BrunoVavretchek. All rights reserved.
//

import Foundation


struct Cerveja:Decodable{
    let name:String
    let image_url:String
    let description:String
    let tagline:String
    let abv:Double
    let ibu:Double?
}
