import UIKit

class dietViewController: UIViewController {

    @IBOutlet weak var SampleLabel: UILabel!
    @IBOutlet weak var nutriTable: UITableView!
    @IBOutlet weak var dietPrefPopUp: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        self.fetchAgifyData()    
    }

    func setPopupButton() {
        // Create the action closure for the pop-up button menu
        let popUpClosure = {(action: UIAction) in
            print(action.title)
            // Call the Agify API when a diet option is selected
            self.fetchAgifyData()
        }

        // Setup menu for the diet preference button
        dietPrefPopUp.menu = UIMenu(children: [
            UIAction(title: "Vegetarian", handler: popUpClosure),
            UIAction(title: "Non-Vegetarian", handler: popUpClosure),
            UIAction(title: "Vegan", handler: popUpClosure)
        ])

        // Make the button trigger the menu on primary action (tap)
        dietPrefPopUp.showsMenuAsPrimaryAction = true
    }

    // Function to fetch data from Agify API
    func fetchAgifyData() {
        // The Agify API URL for name 'yedhu'
        let apiURL = "https://api.agify.io/?name=yedhu"

        guard let url = URL(string: apiURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Parsing the JSON response from Agify API
                let agifyResponse = try JSONDecoder().decode(AgifyResponse.self, from: data)
                // Process the response and update the UI
                DispatchQueue.main.async {
                    self.updateUI(with: agifyResponse)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }

    // Function to update the UI with the Agify data
    func updateUI(with agify: AgifyResponse) {
        // Create a string to display the name and the predicted age
        let displayText = """
        Name: \(agify.name)
        Predicted Age: \(agify.age)
        Count: \(agify.count)
        """
        print(agify.name)

        // Update the SampleLabel's text with the Agify response
        SampleLabel.text = displayText
    }

    // Define the structure of the Agify API response
    struct AgifyResponse: Codable {
        let name: String
        let age: Int
        let count: Int
    }
}
