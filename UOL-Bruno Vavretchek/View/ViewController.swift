import UIKit
import Kingfisher
import Alamofire

var arrCerveja = [Cerveja]()
var arrBackup = [Cerveja]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Connectivity.isConnectedToInternet {
            return arrCerveja.count
        } else {
            return arrBackup.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! TableViewCell
        
        
        if Connectivity.isConnectedToInternet {
            
            let model = arrCerveja[indexPath.row]
            
            cell.labelName.text = model.name
            cell.labelDetail.text = "Teor alcoólico: \(model.abv)"
            let resource = ImageResource(downloadURL: URL(string: "\(model.image_url)")!, cacheKey: model.image_url)
            
            cell.imageViewCell.kf.setImage(with: resource, placeholder: UIImage(named: "icons8-hourglass-48"), options: nil, progressBlock: nil, completionHandler: nil)
        
            return cell
            
        } else {
            do{
            if let savedData = UserDefaults.standard.value(forKey: "backupSaved") as? Data {
                arrBackup = try JSONDecoder().decode([Cerveja].self, from: savedData)

            }
            let model = arrBackup[indexPath.row]
            
            cell.labelName.text = model.name
            cell.labelDetail.text = "Teor alcoólico: \(model.abv)"
            let resource = ImageResource(downloadURL: URL(string: "\(model.image_url)")!, cacheKey: model.image_url)
            
            cell.imageViewCell.kf.setImage(with: resource, placeholder: UIImage(named: "icons8-hourglass-48"), options: nil, progressBlock: nil, completionHandler: nil)
            
            
            }catch{print(error)}
            
        }
        return cell

        
        
    }
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Connectivity.isConnectedToInternet {
            performSegue(withIdentifier: "segueId", sender:arrCerveja[indexPath.row])
        } else {
            performSegue(withIdentifier: "segueId", sender:arrBackup[indexPath.row])
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueId" {
            
            let des = segue.destination as? TableViewDetalhes
            
            //.item possui uma propriedade instanciada na TelaDetalheProdutos
            des?.item = (sender as? Cerveja)
            //Segue para CollectionView Categorias
        }
    }
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        //SetupNavBarCustom
        navigationController?.navigationBar.setupNavigationBar()
        
        if Connectivity.isConnectedToInternet {
            print("Connected")
            getApiData { (cerveja) in
                arrCerveja = cerveja
                //Backup
                do{
                    let data = try JSONEncoder().encode(arrCerveja)
                    
                    UserDefaults.standard.set(data, forKey: "backupSaved")
                    //
                    self.tableView.reloadData()
                }catch{print(error)
                }
            }
        } else {
            print("No Internet")
            do{
                if let savedData = UserDefaults.standard.value(forKey: "backupSaved") as? Data {
                    arrBackup = try JSONDecoder().decode([Cerveja].self, from: savedData)
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        }
    }
    //Hide StatusBar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getApiData { (cerveja) in
            arrCerveja = cerveja}
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
