//
//  MainBSTableViewController.swift
//  Barbershops Moscow
//
//  Created by Alan on 18/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit
import CoreData

class MainBSTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Barber>!
    var searchController: UISearchController!
    var filteredResultArray: [Barber] = []
    var barberShops:[Barber] = []
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = barberShops.filter { (barberShop) -> Bool in
            return (barberShop.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // create fetch request with descriptor
        let fetchRequest: NSFetchRequest<Barber> = Barber.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // getting context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            // creating fetch result controller
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            // trying to retrieve data
            do {
                try fetchResultsController.performFetch()
                // save retrieved data 
                barberShops = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        barberShops = controller.fetchedObjects as! [Barber]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return barberShops.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func barbershopToDisplayAt(indexPath: IndexPath) -> Barber {
        let barbershop: Barber
        if searchController.isActive && searchController.searchBar.text != "" {
            barbershop = filteredResultArray[indexPath.row]
        } else {
            barbershop = barberShops[indexPath.row]
        }
        return barbershop
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainBSTableViewCell
        
        let barberShops = barbershopToDisplayAt(indexPath: indexPath)
        
        cell.backgroundImage?.image = UIImage(data: barberShops.image! as Data)
        cell.nameLabel.text = barberShops.name
        cell.infoLabel.text = barberShops.location
        cell.review.text = barberShops.review
        
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let share =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            let defaultText = "Я сейчас в " + self.barberShops[indexPath.row].name!
                        if let image = UIImage(data: self.barberShops[indexPath.row].image! as Data) {
                            let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                            self.present(activityController, animated: true, completion: nil)
                        }
                    })
        
        let delete =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            //do stuff
            completionHandler(true)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        delete.image = #imageLiteral(resourceName: "delete")
        delete.backgroundColor = #colorLiteral(red: 0.3729464412, green: 0.07460708171, blue: 0.09038016945, alpha: 1)
        share.image = #imageLiteral(resourceName: "share")
        share.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        let confrigation = UISwipeActionsConfiguration(actions: [delete, share])
        
        return confrigation
    }
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
//            let defaultText = "Я сейчас в " + self.barberShops[indexPath.row].name!
//            if let image = UIImage(data: self.barberShops[indexPath.row].image! as Data) {
//                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
//                self.present(activityController, animated: true, completion: nil)
//            }
//        }
//        
//        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
////            self.barberShops.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
//            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
//                let objectToDelete = self.fetchResultsController.object(at: indexPath)
//                context.delete(objectToDelete)
//                
//                do {
//                    try context.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        
//        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        return [delete, share]
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! DetailBSViewController
                dvc.barber = barbershopToDisplayAt(indexPath: indexPath)
            }
        }
            }


    
    @IBAction func close(segue: UIStoryboard) {
    }
}

extension MainBSTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension MainBSTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}




