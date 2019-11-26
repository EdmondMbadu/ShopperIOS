//
//  ShopperTableViewController.swift
//  Shopper
//
//  Created by Mbadu, Edmond Ngoma on 11/5/19.
//  Copyright © 2019 Mbadu, Edmond Ngoma. All rights reserved.
//

import UIKit

import CoreData

class ShopperTableViewController: UITableViewController {

    // create a reference to a context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // create an array of ShoppingLIst entities
    // This is insane. it stopped for no reason. THE FIX WAS TO OPEN XCODE
    // AND CLOSE IT
    var shoppingLists = [ShoppingList] ()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // call the load shopping list method
        loadShoppingLists()
    }
    
    // fetch ShoppingLists from Core Data
    func loadShoppingLists(){
        // Create an instance of a FetchRequest so that
        // ShoppingList can be fetched from Core Data
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
    
        do{
            // use context to execute a fetch request
            // to fetch ShoppingLists from Core Data
            // store the fetched ShoppingLists in our array
            shoppingLists = try context.fetch(request)
        }catch {
            print("Error fetching ShoppingLists from Core Data!")
        }
        
        // reload the fetched data in the Table View Controller
        tableView.reloadData()
    }
    
    // save shopping list into core Data
    func saveShoppingLists(){
        do {
            // use context to save ShoppingLists into Core Data
            try context.save()
        }catch {
            print("Error saving ShoppingLists to Core Data!")
        }
        // reload the data in the Table View Controller
        tableView.reloadData()
    }
    // delete shhoppinglistItem entities from Core Data
       func deleteShoppingLists(item: ShoppingList){
           context.delete(item)
           do {
               // use context to delete ShoppingLists into Core Data
               try context.save()
               }catch {
               print("Error deleting ShoppingList from Core Data!")
               }
           loadShoppingLists()
           
       }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // declare Text Fields variables for the input of the name, store, and data
        
        var nameTextField = UITextField()
        var storeTextField = UITextField()
        var dateTextField = UITextField()
        
        // create an Alert Controller
        
        let alert = UIAlertController(title: "Add Shopping List", message: "", preferredStyle: .alert)
    
    //define an action that will occur when the Add List button
        // is pushed
        let action = UIAlertAction(title: "Add List", style: .default, handler: { (action) in
            
            // create an instance of a ShoppingList entity
            let newShoppingList = ShoppingList (context: self.context)
            
            // get name, store, and date input by user and store them in ShoppingList entity
            
            newShoppingList.name = nameTextField.text!
            newShoppingList.store = storeTextField.text!
            newShoppingList.date = dateTextField.text!
            
            // add ShoppingList entity into array
            self.shoppingLists.append(newShoppingList)
            
            // save ShoppingLists into Core Data
            self.saveShoppingLists()
            
            
        })
        
        // disable an action that will occure when the Cancel is pushed
        action.isEnabled = false
        // define an action that will occure when the Cancel is pushed
        let cancelAction = UIAlertAction (title: "Cancel", style: .default, handler: {(cancelAction) in
            
        })
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add the Text Field into Alert Controller
        
        alert.addTextField(configurationHandler: { (field) in
            nameTextField = field
            nameTextField.placeholder = "Enter Name"
            nameTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
            
        })
        
        alert.addTextField(configurationHandler: { (field) in
                  storeTextField = field
                  storeTextField.placeholder = "Enter Store"
             storeTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                  
              })
        alert.addTextField(configurationHandler: { (field) in
                  dateTextField = field
                  dateTextField.placeholder = "Enter Date"
             dateTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                  
              })
        
        //display the alert controller
        present(alert, animated: true, completion: nil)
    
    }
    
    @objc func alertTextFieldDidChange (){
        // get a reference of the Alert Controller
        let alertController = self.presentedViewController as!
        UIAlertController
        
        // get a reference to the Action that allows the user to add a ShoppingList
        let action = alertController.actions[0]
        // get references to the  text in Text Fields
        if let name = alertController.textFields! [0].text,
            let store = alertController.textFields![1].text,
            let date = alertController.textFields![2].text {
            
            // trim whitespace from the text
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            let trimmedStore = store.trimmingCharacters(in: .whitespaces)
            let trimmedDate = date.trimmingCharacters(in: .whitespaces)
            
            // check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add a ShoppingList
            
            if(!trimmedName.isEmpty && !trimmedStore.isEmpty && !trimmedDate.isEmpty){
            action.isEnabled = true
            }
        }
}
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//         number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return the number of rows
        // we will have as many rows as there are shopping lists
        // in the ShoppingList entitu in Core Data
        return shoppingLists.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)

//         Configure the cell...

        let shoppingList = shoppingLists[indexPath.row]
        cell.textLabel?.text = shoppingList.name!
        cell.detailTextLabel?.text = shoppingList.store! + " " + shoppingList.date!
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
              // Delete the row from the data source
                      let item = shoppingLists[indexPath.row]
                      deleteShoppingLists(item: item)
                     
        } 
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShoppingListItems"){
            // get the index path for the row that was selected
//            (0,0) (0,1), (0,2), ...
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            // create an instance of the Shopping List Table View Controller
            let shoppingListItem = segue.destination as! ShopppingListTableViewController
            
            // set the selected shopping list property of the Shopping List Table View Controller
            // equal to the row of the index path 
            shoppingListItem.selectedShoppingList = shoppingLists [selectedRowIndex!.row]
            
    
            
        }
    }
   

}
