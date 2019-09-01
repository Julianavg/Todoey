//
//  ViewController.swift
//  Todoey
//
//  Created by juliana vargas on 8/17/19.
//  Copyright © 2019 Juliana Vargas. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {


    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?  {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
  

        // Do any additional setup after loading the view.
        
    }

    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
    
        } else {
            cell.textLabel?.text = "No Items Added"
        }
      
        return cell
        
    }

    //MARK - TableView Delegate Methods

    override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if let item = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                
            }
        }
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                        print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }

            //What will happen once the user click the Add Item button on our UIAlert
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)

  
    //MARK - Model Manupulation Methods
    
    }
    
    func loadItems() {
            toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

            tableView.reloadData()
    }
    

}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
