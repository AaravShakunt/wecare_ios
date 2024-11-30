import UIKit

class dietViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var SampleLabel: UILabel!
    @IBOutlet weak var nutriTable: UITableView!
    @IBOutlet weak var dietPrefPopUp: UIButton!
    
    @IBAction func generatePress(_ sender: UIButton) {
        fetchRecipeData()
    }
    var recipes: [RecipeResponse.Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        nutriTable.delegate = self
        nutriTable.dataSource = self
    }
    
    func setPopupButton() {
        // Create the action closure for the pop-up button menu
        let popUpClosure = {(action: UIAction) in
            print(action.title)
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
    
    // Function to fetch data from EDMAM API
    func fetchRecipeData() {
        // The Recipe API URL
        let apiURL = "https://api.edamam.com/api/recipes/v2?app_key=f4650c46295b99bcffadb531774729ab&field=uri&field=label&field=image&field=source&field=dietLabels&field=healthLabels&field=cautions&field=ingredientLines&field=calories&health=alcohol-free&health=vegetarian&diet=high-fiber&cuisineType=Indian&imageSize=THUMBNAIL&type=public&app_id=c0de6b55"
        
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
                // Parsing the JSON response from the Recipe API
                let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                // Process the response and update the UI
                DispatchQueue.main.async {
                    self.recipes = recipeResponse.hits.map { $0.recipe }
                    self.nutriTable.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(recipes.count)")
            return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietTableViewCell", for: indexPath) as! DietTableViewCell
        let recipe = recipes[indexPath.row]
        print("Recipe label: \(recipe.label)")
        
        // Configure the cell
        cell.nutriLabel.text = recipe.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.row]
        showRecipeDetails(recipe: selectedRecipe)
    }
    func showRecipeDetails(recipe: RecipeResponse.Recipe) {
        let alert = UIAlertController(title: recipe.label, message: nil, preferredStyle: .alert)
        
        let ingredients = recipe.ingredientLines.joined(separator: "\n")
        let dietLabels = recipe.dietLabels.joined(separator: ", ")
        let cautions = recipe.cautions.joined(separator: ", ")
        let message = """
        Ingredients:
        \(ingredients)
        Diet Labels: 
        \(dietLabels)
        Cautions: \(cautions)
        Calories: \(recipe.calories)
        
        """
        
        alert.message = message
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Define the structure of the Recipe API response
    struct RecipeResponse: Codable {
        let hits: [Hit]
        
        struct Hit: Codable {
            let recipe: Recipe
        }
        
        struct Recipe: Codable {
            let label: String
            //let image: String
            //let source: String
            let dietLabels: [String]
            //let healthLabels: [String]
            let cautions: [String]
            let ingredientLines: [String]
            let calories: Double
        }
    }
}
