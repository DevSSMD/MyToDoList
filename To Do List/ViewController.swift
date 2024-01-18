//
//  ViewController.swift
//  To Do List
//
//  Created by Sana Siddiqui on 1/12/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasksArray = [Task]()
    var selectedTaskIndex: Int?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButtonTapped: UIButton!
    @IBOutlet var editButtonTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        
        tableView.backgroundColor = UIColor(red: 1, green: 0.75, blue: 0.8, alpha: 0.5)
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasksArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskItem", for: indexPath)
        let task = tasksArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isComplete ? .checkmark : .none
        cell.backgroundColor = UIColor(red: 1, green: 0.75, blue: 0.8, alpha: 0.5)
        if isEditing {
            // some code
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if isEditing {
                    selectedTaskIndex = indexPath.row
                    let selectedTask = tasksArray[indexPath.row]
        
                    let ac = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
                    ac.addTextField { textField in
                        textField.placeholder = "Enter Task Name"
                        textField.text = selectedTask.title
                    }
        
                    let saveAction = UIAlertAction(title: "Save", style: .default) {[weak self, weak ac] _ in
                    guard let _ = ac?.textFields?.first, let newName = ac?.textFields?.first?.text, !newName.isEmpty else {return}
                        if let selectedIndexPath = self?.selectedTaskIndex {
                            self?.tasksArray[selectedIndexPath].title = newName
                            self?.tableView.reloadRows(at: [IndexPath(row: selectedIndexPath, section: 0)], with: .none)
                            self?.selectedTaskIndex = nil
                        }
                    }
        
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
                    ac.addAction(saveAction)
                    ac.addAction(cancelAction)
                    present(ac, animated: true)
                    isEditing = false
                } else {
        tasksArray[indexPath.row].isComplete.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
        print("Complete!")
                }
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addToListAction = UIAlertAction(title: "Add Item", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else {return}
            self?.submit(item)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(addToListAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ item: String) {
        let newTask = Task(title: item, isComplete: false)
        tasksArray.append(newTask)
        tableView.reloadData()
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        setEditing(!isEditing, animated: true)
    }
}
