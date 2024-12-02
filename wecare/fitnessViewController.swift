//
//  fitnessViewController.swift
//  wecare
//
//  Created by Harshit Pesala on 15/11/24.
//

import UIKit

class fitnessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ExercisePopUp: UIButton!
    @IBOutlet weak var MusclePopUp: UIButton!
    @IBOutlet weak var FitTable : UITableView!
    
    // Array to store the fetched exercises
    var exercises: [Exercise] = []
    var selectedType : String = ""
    var selectedMuscle : String = ""
    @IBAction func generatePress(_ sender: UIButton) {
        fetchExerciseData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FitTable.delegate = self
        FitTable.dataSource = self
        setExercisePopupButton()
        setMusclePopupButton()
        // Do any additional setup after loading the view.
    }
    
    func setExercisePopupButton() {
        // Create the action closure for the pop-up button menu
        let popUpClosure = {(action: UIAction) in
            print(action.title)
            self.selectedType = action.title.lowercased()
        }
        
        // Setup menu for the diet preference button
        ExercisePopUp.menu = UIMenu(children: [
            UIAction(title: "Cardio", handler: popUpClosure),
            UIAction(title: "Stretching", handler: popUpClosure),
            UIAction(title: "Strength", handler: popUpClosure)
        ])
        
        // Make the button trigger the menu on primary action (tap)
        ExercisePopUp.showsMenuAsPrimaryAction = true
    }
    func setMusclePopupButton() {
        // Create the action closure for the pop-up button menu
        let popUpClosure = {(action: UIAction) in
            print(action.title)
            self.selectedMuscle = action.title.lowercased()
        }
        
        // Setup menu for the diet preference button
        
        MusclePopUp.menu = UIMenu(children: [
            UIAction(title: "Abdominals", handler: popUpClosure),
            UIAction(title: "Neck", handler: popUpClosure),
            UIAction(title: "Glutes", handler: popUpClosure)
        ])
        
        // Make the button trigger the menu on primary action (tap)
        MusclePopUp.showsMenuAsPrimaryAction = true
    }
        
        
        
        func fetchExerciseData() {
            // API URL to fetch exercise data
            let apiURL = "https://api.api-ninjas.com/v1/exercises?muscle=\(selectedMuscle)&type=\(selectedType)"
            
            guard let url = URL(string: apiURL) else { return }
            
            var request = URLRequest(url: url)
            request.setValue("2yTsg9JeiNH5FmMZa8ftiDFTTG9nia0z9pon3jZC", forHTTPHeaderField:"X-Api-Key")  // Replace with your actual API key
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    // Parse the JSON response from the API
                    let exercisesResponse = try JSONDecoder().decode([Exercise].self, from: data)
                    DispatchQueue.main.async {
                        // Update the UI on the main thread
                        self.exercises = exercisesResponse
                        self.FitTable.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
            task.resume()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return exercises.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessTableViewCell", for: indexPath) as! FitnessTableViewCell
            
            // Get the exercise for the current row
            let exercise = exercises[indexPath.row]
            
            // Set the name of the exercise in the cell
            cell.fitLabel.text = exercise.name
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedExercise = exercises[indexPath.row]
            showExerciseDetails(exercise: selectedExercise)
        }
        
        func showExerciseDetails(exercise: Exercise) {
            let alert = UIAlertController(title: exercise.name, message: nil, preferredStyle: .alert)
            
            let message = """
            Type: \(exercise.type)
            Muscle: \(exercise.muscle)
            Equipment: \(exercise.equipment)
            Difficulty: \(exercise.difficulty)
            Instructions: \(exercise.instructions.isEmpty ? "Not available" : exercise.instructions)
            """
            
            alert.message = message
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        // Define the structure of the Exercise API response
        struct Exercise: Codable {
            let name: String
            let type: String
            let muscle: String
            let equipment: String
            let difficulty: String
            let instructions: String
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


