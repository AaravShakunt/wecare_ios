//
//  vaccinationViewController.swift
//  wecare
//
//  Created by Harshit Pesala on 15/11/24.
//

import UIKit

class vaccinationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var vaccineTable: UITableView!
    @IBAction func generatePress(_ sender: UIButton) {
        calculateDaysRemaining()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vaccineTable.dataSource = self
        vaccineTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    let vaccineDescriptions = [
            "DTwP /DTaP1, Hib-1, IPV-1, Hep B2, PCV 1, Rota-1",
            "DTwP /DTaP2, Hib-2, IPV-2, Hep B3, PCV 2, Rota-2",
            "DTwP /DTaP3, Hib-3, IPV-3, Hep B4, PCV 3, Rota-3*",
            "Influenza-1", "Influenza-2",
            "Typhoid Conjugate Vaccine",
            "MMR 1 (Mumps, measles, Rubella)",
            "Hepatitis A- 1",
            "PCV Booster", "MMR 2, Varicella",
            "DTwP /DTaP, Hib, IPV", "Hepatitis A- 2**, Varicella 2",
            "DTwP /DTaP, IPV, MMR 3", "HPV (2 doses)", "Tdap/ Td"
        ]
        
        var daysRemaining = [42, 70, 90, 183, 213, 228, 274, 365, 410, 456, 518, 548, 1826, 4382, 4017]
        var calculatedDaysRemaining: [Int] = []
        
        
        
         func calculateDaysRemaining() {
            // Convert dobTextField text to a Date
            guard let dobString = dobTextField.text, !dobString.isEmpty else {
                return // Show error or alert for empty DOB input
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" // Assuming date is entered as dd/MM/yyyy
            guard let dob = dateFormatter.date(from: dobString) else {
                return // Show error or alert for invalid DOB format
            }
            
            // Calculate the number of days between the dob and current date
            let currentDate = Date()
            let calendar = Calendar.current
            
            // Calculate the days remaining for each vaccination
            calculatedDaysRemaining = daysRemaining.map { targetDay in
                let birthDateInDays = calendar.dateComponents([.day], from: dob, to: currentDate).day ?? 0
                return targetDay - birthDateInDays
            }
            
            // Reload the table view to display the updated data
            vaccineTable.reloadData()
        }
        
        // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return vaccineDescriptions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VaccinationTableViewCell", for: indexPath) as! VaccinationTableViewCell
            
            let vaccineDescription = vaccineDescriptions[indexPath.row]
            let daysLeft = calculatedDaysRemaining.count > indexPath.row ? calculatedDaysRemaining[indexPath.row] : 0
            
            // Set labels in the cell
            if daysLeft < 0{
                cell.vaccineLabel.text = "\(vaccineDescription) \n Late by \(daysLeft * -1) days"
            }
            else{
                cell.vaccineLabel.text = "\(vaccineDescription) \n \(daysLeft) days remaining"
            }
            
            return cell
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
