//
//  dietViewController.swift
//  wecare
//
//  Created by Harshit Pesala on 15/11/24.
//

import UIKit

class dietViewController: UIViewController {

    @IBOutlet weak var dietPrefPopUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        // Do any additional setup after loading the view.
    }
    func setPopupButton(){
        let popUpClosure = {(action : UIAction) in print(action.title)}
        dietPrefPopUp.menu = UIMenu(children: [
            UIAction(title: "Vegetarian", handler: popUpClosure),
            UIAction(title: "Non-Vegetarian", handler: popUpClosure),
            UIAction(title: "Vegan", handler: popUpClosure)
        ])
        
        dietPrefPopUp.showsMenuAsPrimaryAction = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
