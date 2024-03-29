//
//  ShopppingListTableViewController.swift
//  Shopper
//
//  Created by Mbadu, Edmond Ngoma on 11/12/19.
//  Copyright © 2019 Mbadu, Edmond Ngoma. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ShopppingListTableViewController: UITableViewController {
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // create a variable that will contain the row of the selected Shopping List
    var selectedShoppingList: ShoppingList?
    
    // create an array to store Shopping List Items
    var shoppinListItems = [ShoppingListItem] ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call load Shopping list items method
        loadShoppingListItems()
      
        
        // make row height larger
        self.tableView.rowHeight = 84.0
        setTitle()
    }
    
    func setTitle (){
        // declare local variable to store total cost of shopping and initialize it to zero
        var totalCost = 0.0
        
        // loop through shopping list items and compute total cost
        for list in shoppinListItems {
            totalCost += Double (list.price) * Double( list.quantity)
        }
        
        
        if let selectedShoppinglist = selectedShoppingList {
            // get the shopping list name and set the title
            title = selectedShoppinglist.name! + String (format: "$%.2f", totalCost)
            
        } else {
            // set the title of Shopping List Items
            title = "Shopping List Items"
        }
        
        
    }
    
    // save shopping list into core Data
       func saveShoppingListItems(){
           do {
               // use context to save ShoppingLists into Core Data
               try context.save()
           }catch {
               print("Error saving ShoppingListItems to Core Data!")
           }
           // reload the data in the Table View Controller
           tableView.reloadData()
       }
    
    // fetch ShoppingListItems from CoreData
    func loadShoppingListItems(){
        // check if Shopper Table View Controller has passed a valid Shopping list
        if let list = selectedShoppingList {
            // if the Shopping List has items cast them to an array of ShoppingListItems
            if let listItems = list.items?.allObjects as? [ShoppingListItem] {
                // store constant in Shopping List Items array
                shoppinListItems = listItems
            }
            
        }
        // reload fetched data in Table View Controller
        tableView.reloadData()
    }
    
    // delete shhoppinglistItem entities from Core Data
    func deleteShoppingListItem(item: ShoppingListItem){
        context.delete(item)
        do {
            // use context to delete ShoppingLists into Core Data
            try context.save()
            }catch {
            print("Error deleting ShoppingListItems from Core Data!")
            }
        loadShoppingListItems()
        
    }

    
    func shoppingListDOneNotification (){
        
        var done = true
        
        //loop through shooping list items
        for item in shoppinListItems {
            // check if any of the purchased attributes are false
            
            if item.purchased == false {
                // set done to false
                done = false
            }
        }
        
        // check if done is true
        if (done==true){
            
            // create the content object that controls the content and sound of the notification
            let content = UNMutableNotificationContent()
            content.title = "Shopper"
            content.body = "Shopping List Complete"
            content.sound = UNNotificationSound.default
            
            //create request object that defines when the notifications will be sent and if it should
            // be sent repeatidly
            
            let trigger = UNTimeIntervalNotificationTrigger (timeInterval: 1, repeats: false)
            
            // create request object that is responsible for creating the notification
            let request = UNNotificationRequest (identifier: "shopperIdentifier", content: content, trigger: trigger)
            
            // post the notification
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
    // declare Text Fields variables for the input of the name, store, and data
               
               var nameTextField = UITextField()
               var priceTextField = UITextField()
               var quantityTextField = UITextField()
               
               // create an Alert Controller
               
               let alert = UIAlertController(title: "Add Shopping List Item", message: "", preferredStyle: .alert)
           
           //define an action that will occur when the Add List button
               // is pushed
               let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
                   
                   // create an instance of a ShoppingList entity
                   let newShoppingListItem = ShoppingListItem (context: self.context)
                   
                   // get name, store, and date input by user and store them in ShoppingList entity
                   
                   newShoppingListItem.name = nameTextField.text!
                   newShoppingListItem.price = Double (priceTextField.text!)!
                   newShoppingListItem.quantity = Int64 (quantityTextField.text!)!
                newShoppingListItem.purchased = false
                newShoppingListItem.shoppingList = self.selectedShoppingList
                   
                   // add ShoppingListItem entity into array
                   self.shoppinListItems.append(newShoppingListItem)
                   
                   // save ShoppingListItems into Core Data
                   self.saveShoppingListItems()
                   // update the title to incorporate the cost of the added shopping list item
                self.setTitle()
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
                         priceTextField = field
                         priceTextField.placeholder = "Enter Price"
                    priceTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                         
                     })
               alert.addTextField(configurationHandler: { (field) in
                         quantityTextField = field
                         quantityTextField.placeholder = "Enter Quantity"
                    quantityTextField.addTarget(self, action: #selector(self.alertTextFieldDidChange), for: .editingChanged)
                         
                     })
               
               //display the alert controller
               present(alert, animated: true, completion: nil)
           
           }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       //return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        // we will have as many rows as there are shopping list items
        return shoppinListItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemCell", for: indexPath)

        // Configure the cell...
        
        
        let shoppingListItem = shoppinListItems[indexPath.row]
        
        // set the cell title equal to the shpping lsit item name
        cell.textLabel?.text = shoppingListItem.name!
        
        // set detailTextLabel numberOfLines property to zero 
        cell.detailTextLabel!.numberOfLines = 0
        
        // set the cell subtitle equal to the shopping list item quantity and price
        cell.detailTextLabel?.text = String (shoppingListItem.quantity) + " \n" + String(shoppingListItem.price)
        
        // set the cell accessory type to checkmark if purchased is equal to true,
        // else set it to none 
        if (shoppingListItem.purchased == false ){
            cell.accessoryType = .none
        }else{
            cell.accessoryType = .checkmark
        }
        return cell
    }
     
        @objc func alertTextFieldDidChange (){
            // get a reference of the Alert Controller
            let alertController = self.presentedViewController as!
            UIAlertController
            
            // get a reference to the Action that allows the user to add a ShoppingList
            let action = alertController.actions[0]
            // get references to the  text in Text Fields
            if let name = alertController.textFields! [0].text,
                let price = alertController.textFields![1].text,
                let quantity = alertController.textFields![2].text {
                
                // trim whitespace from the text
                let trimmedName = name.trimmingCharacters(in: .whitespaces)
                let trimmedPrice = price.trimmingCharacters(in: .whitespaces)
                let trimmedQuantity = quantity.trimmingCharacters(in: .whitespaces)
                
                // check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add a ShoppingList
                
                if(!trimmedName.isEmpty && !trimmedPrice.isEmpty && !trimmedQuantity.isEmpty){
                action.isEnabled = true
                }
            }
    }
    
    

   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemCell", for: indexPath)
              // getting the selected shopping list item
              let shoppingListItem = shoppinListItems[indexPath.row]
              
        
        // get quanity, price and purchased indicator for selected shopping list item
        let sQuantity = String (shoppingListItem.quantity)
        let sPrice = String (shoppingListItem.price)
        let purchased = shoppingListItem.purchased
   
        if (purchased == true){
            // if purchased indicator is true, set it to false, and remove chekmark
            cell.accessoryType = .none
            shoppingListItem.purchased = false
        }
        else {
            // if purhcased indicator is false, set it to true and add checkmark
            cell.accessoryType = .checkmark
            shoppingListItem.purchased = true
        }
        // configure the table view cell
        cell.textLabel?.text = shoppingListItem.name
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = sQuantity + "\n" + sPrice
        
        // save update to purchased indicator
        self.saveShoppingListItems()
        
        // call deselect method to all update to be visible in table view controller
        tableView.deselectRow(at: indexPath, animated: true)
        
        shoppingListDOneNotification() 
    }

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = shoppinListItems[indexPath.row]
            deleteShoppingListItem(item: item)
            setTitle()
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
       
    }
   
}
