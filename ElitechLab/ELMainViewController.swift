//
//  ELMainViewController.swift
//  ElitechLab
//
//  Created by Óscar Rodríguez Garrucho on 11/7/17.
//  Copyright © 2017 Óscar Rodríguez Garrucho. All rights reserved.
//

import UIKit
import SVProgressHUD

class ELMainViewController: UITableViewController {
    
    let apiService = TechcrunchService()
    var arrayItems = [TechcrunchItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // configuramos la tableView y la altura dinámica de sus celdas
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        getData()
    }
    
    @IBAction func refreshDataFromServer(_ sender: Any) {
        getData()
    }
    
    
    // cargamos la misma view con diferentes mensajes de error según parámetros en caso de algún error en la petición.
    func loadErrorViewController(_ message: String) {
        
        let errorMessageController = self.storyboard?.instantiateViewController(withIdentifier: "ELErrorMessageViewController") as! ELErrorMessageViewController
        errorMessageController.modalPresentationStyle = .overCurrentContext
        errorMessageController.modalTransitionStyle = .crossDissolve
        errorMessageController.initializeWithMessage(message)
        self.present(errorMessageController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reutilizamos celdas
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = arrayItems[indexPath.row].title!
        
        return cell
    }
    
    
    // MARK: - API Services
    
    func getData() {
        
        arrayItems = [TechcrunchItem]()
        self.showHUDWithStatus()
        
        DispatchQueue.global().async {

            self.apiService.callAPI() { items in
                
                if let items = items {
                    
                    for item in items {
                        
                        let modelTechcrunchItem = TechcrunchItem(title: item["title"], date: item["date"])
                        self.arrayItems.append(modelTechcrunchItem)
                    }
                    print("Send Numero de items leídos \(self.arrayItems.count) de la API")
                    
                    if (self.arrayItems.count == 0){
                        self.loadErrorViewController("El servidor no ha devuelvo ningún elemento.")
                        print("Zero elements in response!")
                    }
                    else {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"

                        // ordenamos por fecha, de más actual a más antigua.
                        let ready = self.arrayItems.sorted(by: { (dateFormatter.date(from: $0.date!)! as Date).compare((dateFormatter.date(from: $1.date!)! as Date)) == .orderedDescending })
                        for valor in ready {
                            print(valor.date ?? String.self) // mirar consola
                        }
                        self.arrayItems = ready
                        self.tableView.reloadData()
                    }
                    
                } else {
                    self.loadErrorViewController("La conexión al servidor ha fallado. Inténtelo más tarde.")
                    print("Send Error while calling REST services")
                    
                }
                
                self.hideHUD()
            }
        }
        
    }
    
    
    // MARK: - SVProgressHUD activity indicator con mensaje
    
    func showHUDWithStatus(){
        
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.show(withStatus: "Loading data...")
        }
        
    }
    
    func hideHUD(){
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    
    
}
