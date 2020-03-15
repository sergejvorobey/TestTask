//
//  AccountUserViewController.swift
//  TestTask
//
//  Created by Sergey Vorobey on 06/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private let data = DataLoaderPlist().userData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditUserViewController", sender: nil)
    }
    
    @IBAction func viewButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func aboutButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowAbout", sender: nil)
        
    }
    
//    @IBAction func addButton(_ sender: UIBarButtonItem) {
//
//        let alertController = UIAlertController(title: "New Human", message: "Add new human", preferredStyle: .alert)
//        alertController.addTextField()
//
//        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
//
//            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
//
//            // TODO: ....
//
//        }
//
//        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        alertController.addAction(save)
//        alertController.addAction(cancel)
//        present(alertController, animated: true, completion: nil)
//    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let humansCell = tableView.dequeueReusableCell(withIdentifier: "HumansCell", for: indexPath) as! HumansCell
        
        let human = data[indexPath.row]
        
        humansCell.firstName.text = human.firstName
        
        return humansCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUserViewController" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let human = data[indexPath.row]
            let newHumanVC = segue.destination as! EditUserViewController
            newHumanVC.humanCurrent = human
        }
    }
}
