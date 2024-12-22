//
//  ViewController.swift
//  CatSegment
//
//  Created by Manthan Mittal on 17/12/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedCat: CatModel!
    var apiArr:[CatModel] = []
    var coreArr:[CatModel] = []

    @IBOutlet weak var apitable: UITableView!
    
    @IBOutlet weak var coretable: UITableView!
    
    @IBOutlet weak var tablesegment: UISegmentedControl!
    
    //View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.coreArr = CDManager().readFromCd()
        
        ApiCall()
        reloadUI()
    }
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        tablesegment.selectedSegmentIndex = 0
        self.coreArr = CDManager().readFromCd()
        setup()
        reloadUI()
    }
    
    // reload func of table1
    func reloadTable1()  {
        
        DispatchQueue.main.async {
            
            self.apitable.reloadData()
        }
    }
    
    // reload func of table2
    func reloadTable2()  {
        
        DispatchQueue.main.async {
            
            self.coretable.reloadData()
        }
    }
    
    // Update Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate" {
            
            if let updateVC = segue.destination as? UpdateVC {
                
                updateVC.catPassed = selectedCat
            }
        }
    }
    
    // API call func
    func ApiCall(){
        ApiManager().fetchCats{ result in
            switch result {
            case.success(let data):
                self.apiArr.append(contentsOf: data)
                print(self.apiArr)
                self.reloadTable1()
                
            case.failure(let error):
                print("err: \(error)")
            }
        }
    }
    
    //Api and Coredata
    func reloadUI() {
            
        if self.tablesegment.selectedSegmentIndex == 0 {
            self.ApiCall()
            self.reloadTable1()
            self.apitable.isHidden = false
            self.coretable.isHidden = true

                
        } else if self.tablesegment.selectedSegmentIndex == 1 {
                
            self.coreArr = CDManager().readFromCd()
            self.reloadTable2()
            self.apitable.isHidden = true
            self.coretable.isHidden = false
                
        }
    }
    
    //delete Func
    func deleteFromArr(position: Int) {
        
        coreArr.remove(at: position)
        
        DispatchQueue.main.async {
            
            self.coretable.reloadData()
        }
    }

    //Segment Action
    @IBAction func changesegment(_ sender: Any) {
        print("current selected segment: \(tablesegment.selectedSegmentIndex)")
        
        reloadUI()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setup() {
        
        apitable.delegate = self
        coretable.delegate = self
        
        apitable.dataSource = self
        coretable.dataSource = self
        
        apitable.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        coretable.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier: "CatCell")
        
        apitable.isHidden = false
        coretable.isHidden = true
        
        reloadUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablesegment.selectedSegmentIndex == 0 ? apiArr.count : coreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as? CatCell else {
            
                        return UITableViewCell()
                }
        
        let currSeg = tablesegment.selectedSegmentIndex
                
        switch currSeg {
            
        case 0:
            guard indexPath.row < apiArr.count else {
                
                print("Index out of bounds for apiArr")
                
                return cell
            }
            
            let cat = apiArr[indexPath.row]
            configureCell(cell, with: cat)
                    
        case 1:
            guard indexPath.row < coreArr.count else {
                
                print("Index out of bounds for coredataArr")
                
                return cell
            }
                    
            let cat = coreArr[indexPath.row]
            configureCell(cell, with: cat)
                    
        default:
            break
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    private func configureCell(_ cell: CatCell, with cat: CatModel) {
        
        cell.lid.text = cat.id
        
        cell.lurl.text = cat.url
        
        cell.lwidth.text = "\(cat.width)"
        
        cell.lheight.text = "\(cat.height)"

        }
    
    //selected joke stor in coredata table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if tableView == apitable {
                
            let catSelected = apiArr[indexPath.row]
            CDManager().AddToCd(catToAdd: catSelected)
            apitable.deselectRow(at: indexPath, animated: true)
            print(catSelected)
        } else if tableView == coretable {
            coretable.deselectRow(at: indexPath, animated: true)

            }
        }
    
    //swipe Update Func
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == coretable {
                
                let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler) in
                
                    self.selectedCat = self.coreArr[indexPath.row]
                    self.performSegue(withIdentifier: "GoToUpdate", sender: self)
                    
                    completionHandler(true)
                }
                updateAction.backgroundColor = .systemOrange
                updateAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
                let updateConfig = UISwipeActionsConfiguration(actions: [updateAction])
                
                return updateConfig
            
        } else {
            let updateConfig = UISwipeActionsConfiguration(actions: [])
            return updateConfig
        }
    }

    
    //swipe Delete func
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == coretable {
            
                let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [self] action, source, completion in
                        //  CoreData's Delete function called
                    
                let catToDelete = coreArr[indexPath.row]
                    
                    CDManager().deleteFromCD(cats: catToDelete)
                    
                    coreArr.remove(at: indexPath.row)
                    
                    reloadTable2()
                    
                };
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "minus.circle.fill")
            
            let deleteConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            
            deleteConfig.performsFirstActionWithFullSwipe=false
            
                return deleteConfig
            } else {
                let deleteConfig = UISwipeActionsConfiguration(actions: [])
                
                deleteConfig.performsFirstActionWithFullSwipe = false
                
                return deleteConfig
            }
        
    }
    
    
}

