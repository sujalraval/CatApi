import UIKit

class UpdateVC: UIViewController {

    @IBOutlet weak var updatelable: UILabel!
    @IBOutlet weak var updateurl: UITextField!
    @IBOutlet weak var updatewidth: UITextField!
    @IBOutlet weak var updateheigth: UITextField!
    @IBOutlet weak var updateid: UITextField!
    
    var catPassed: CatModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    func showData() {
        updateid.text = catPassed.id
        updateurl.text = catPassed.url
        updatewidth.text = String(catPassed.width)
        updateheigth.text = String(catPassed.height)
    }
    
    @IBAction func updatebtn(_ sender: Any) {
        // Safely unwrap the text fields and check for empty values
        guard let updatedID = updateid.text, !updatedID.isEmpty,
              let updatedURL = updateurl.text, !updatedURL.isEmpty,
              let updatedWidthText = updatewidth.text, let updatedWidth = Int(updatedWidthText),
              let updatedHeigthText = updateheigth.text, let updatedHeigth = Int(updatedHeigthText) else {

            return
        }
        
        // Proceed with creating the updated cat model
        let updatedCat = CatModel(id: updatedID, url: updatedURL, width: updatedWidth, height: updatedHeigth)
        
        DispatchQueue.main.async {
            // Call Core Data manager to update the cat
            CDManager().updateInCD(updateCat: updatedCat) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                }
            }
        }
    }
    
}

