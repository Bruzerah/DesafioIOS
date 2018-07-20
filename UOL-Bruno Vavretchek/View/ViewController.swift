//
//  ViewController.swift
//  HakerRank - Bruno Vavretchek
//
//  Created by Bruno Lourenço on 16/07/2018.
//  Copyright © 2018 BrunoVavretchek. All rights reserved.
//

import UIKit
import Kingfisher

var arrCerveja = [Cerveja]()


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    //TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrCerveja.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! TableViewCell
        
        let model = arrCerveja[indexPath.row]
        
        cell.labelName.text = model.name
        cell.labelDetail.text = "Teor alcoólico: \(model.abv)"
        let resource = ImageResource(downloadURL: URL(string: "\(model.image_url)")!, cacheKey: model.image_url)
        
//        cell.imageViewCell.kf.setImage(with: resource)
        cell.imageViewCell.kf.setImage(with: resource, placeholder: UIImage(named: "icons8-hourglass-48"), options: nil, progressBlock: nil, completionHandler: nil)
    
        
        

        
        return cell
    }
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueId", sender:arrCerveja[indexPath.row])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueId" {
            
            let des = segue.destination as? TableViewDetalhes
            
            //.item possui uma propriedade instanciada na TelaDetalheProdutos
            des?.item = (sender as? Cerveja)
            //Segue para CollectionView Categorias
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //SetupNavBarCustom
        navigationController?.navigationBar.setupNavigationBar()
        
        getApiData { (cerveja) in
           arrCerveja = cerveja
           self.tableView.reloadData()
        }
    }
    //Hide StatusBar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
extension UINavigationBar {
    func setupNavigationBar() {
        let titleImageWidth = frame.size.width * 0.32
        let titleImageHeight = frame.size.height * 0.92
        var navigationBarIconimageView = UIImageView()
        if #available(iOS 11.0, *) {
            navigationBarIconimageView.widthAnchor.constraint(equalToConstant: titleImageWidth).isActive = true
            navigationBarIconimageView.heightAnchor.constraint(equalToConstant: titleImageHeight).isActive = true
        } else {
            navigationBarIconimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: titleImageWidth, height: titleImageHeight))
        }
        navigationBarIconimageView.contentMode = .scaleAspectFit
        navigationBarIconimageView.image = UIImage(named: "icons8-cerveja-48")
        topItem?.titleView = navigationBarIconimageView
    }
}
