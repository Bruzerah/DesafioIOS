//
//  TableViewDetalhes.swift
//  HakerRank - Bruno Vavretchek
//
//  Created by Bruno Lourenço on 18/07/2018.
//  Copyright © 2018 BrunoVavretchek. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class TableViewDetalhes: UIViewController {

    var item:Cerveja?
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTeorAlc: UILabel!
    @IBOutlet weak var labelTagLine: UILabel!
    @IBOutlet weak var labelAmargor: UILabel!
    @IBOutlet weak var textViewDetalhes: UITextView!
    @IBOutlet weak var imageDetail: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = item?.name
        textViewDetalhes.text = item?.description
        if let ibu = item!.ibu {
        labelAmargor.text = "\(ibu)"
        }
        labelTeorAlc.text = "\(item!.abv)"
        labelTagLine.text = item?.tagline
        
        let resource = ImageResource(downloadURL: URL(string: "\(item?.image_url ?? "")")!, cacheKey: item?.image_url)
        imageDetail.kf.setImage(with: resource, placeholder: UIImage(named: "icons8-hourglass-48"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    


}
