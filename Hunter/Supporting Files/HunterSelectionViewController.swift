//
//  HunterSelectionViewController.swift
//  Hunter
//
//  Created by Zubin Manak on 31/07/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterSelectionViewController: UIViewController, UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false

    @IBOutlet weak var lblSelectedCount: UILabel!
    
    @IBOutlet weak var lblHeader: UILabel!
    var delegate: hunterDelegate!
    @IBOutlet weak var tbl_view: UITableView!
    var passedDict = NSDictionary()
    var selectedIDArray = [String]()
     var imgName = String()
    var imgNameUnselect = String()

    struct Section {
        let letter : String
        let names : [String]
    }
    var selectedData = [NSDictionary]()

      var sections = [Section]()
      var isMultiSelect = Bool()
      var isFrom = String()
    
    
    var headerText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.backgroundColor = UIColor.clear
        textField?.textColor = UIColor.white
        textField?.font = UIFont(name:"GillSans-Italic", size:18)
        
        
        
        searchBar.setImage(UIImage(), for: .search, state: .normal)

        setHeadertTitle()

        let username : [String] = passedDict.map { ($0.value as? String ?? "Null") }
        
        let groupedDictionary = Dictionary(grouping:username , by: {String($0.prefix(1))})
        // get the keys and sort them
        let keys = groupedDictionary.keys.sorted()
        // map the sorted keys to a struct
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        
        print(sections)
        
        self.lblHeader.text = headerText
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tbl_view.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        self.tbl_view.reloadData()
    }

    func setHeadertTitle(){
        self.lblHeader.text = headerText

        
        
        if isFrom == "JobFunction" || isFrom ==  "Headquaters" || isFrom ==  "Industry" {
            self.imgNameUnselect = "headquaters_unselect.png"
            self.imgName = "headquaters.png"

        }
        else if isFrom == "Skills" {
            self.imgNameUnselect = "education_unselect.png"
            self.imgName = "education.png"

        }
        else if isFrom == "FieldOfEdu" {
            self.imgNameUnselect = "education_unselect.png"
            self.imgName = "education.png"

        }
        else if isFrom == "Founded" {
            self.imgNameUnselect = "founded_unselect.png"
            self.imgName = "founded.png"
        }
        else {
            self.imgNameUnselect = "headquaters_unselect.png"
            self.imgName = "headquaters.png"

        }
        
//        switch  isFrom{
//        case "JobFunction":
//            self.lblHeader.text = "Select your job function"
//
//        case "Skills":
//            self.lblHeader.text = "Select your Skill Sets"
////            self.lblSelectedCount.text = "\(selectedIDArray.count)/5"
//        case "FieldOfEdu":
//            self.lblHeader.text = "Search Level of Study"
////            self.lblSelectedCount.text = "\(selectedIDArray.count)/5"
//        default:
//            self.lblHeader.text = "Select your industry"
////            self.lblSelectedCount.text = "\(selectedIDArray.count)/1"
//        }
    }
    @IBAction func dismissAction(_ sender: Any) {
        
        if self.selectedData.count != 0 {
            let myDict:NSDictionary =
            ["selectedData": selectedData]
            dismiss(animated: true) {
                self.delegate?.selectedData(selectedDict: myDict, isFrom: self.isFrom)
            }
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          searchActive = true;
        if searchBar.text?.count == 0 {
        self.lblHeader.isHidden = false
        }
        else {
            self.lblHeader.isHidden = true

        }
      }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
          searchActive = false;
        if searchBar.text?.count == 0 {
        self.lblHeader.isHidden = false
        }
        else {
            self.lblHeader.isHidden = true

        }
      }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchActive = false;
        if searchBar.text?.count == 0 {
        self.lblHeader.isHidden = false
        }
        else {
            self.lblHeader.isHidden = true

        }
      }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchActive = false;
        if searchBar.text?.count == 0 {
        self.lblHeader.isHidden = false
        }
        else {
            self.lblHeader.isHidden = true

        }
      }
    var filtered:[String] = []
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let username : [String] = passedDict.map { ($0.value as? String ?? "Null") }

        filtered = username.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0 && searchBar.text!.count == 0){
            searchActive = false;
            let username : [String] = passedDict.map { ($0.value as? String ?? "Null") }
            
            let groupedDictionary = Dictionary(grouping:username , by: {String($0.prefix(1))})
            // get the keys and sort them
            let keys = groupedDictionary.keys.sorted()
            // map the sorted keys to a struct
            sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
            
            print(sections)
            if searchBar.text?.count == 0 {
            self.lblHeader.isHidden = false
            }
            else {
                self.lblHeader.isHidden = true

            }
            self.tbl_view.reloadData()
        } else {
            searchActive = true;
            let groupedDictionary = Dictionary(grouping:filtered , by: {String($0.prefix(1))})
                   // get the keys and sort them
                   let keys = groupedDictionary.keys.sorted()
                   // map the sorted keys to a struct
                   sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
                   
                   print(sections)
                   
                   if searchBar.text?.count == 0 {
                   self.lblHeader.isHidden = false
                   }
                   else {
                       self.lblHeader.isHidden = true

                   }
                   self.tbl_view.reloadData()
        }
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sections[section].names.count
     }

     func numberOfSections(in tableView: UITableView) -> Int {
         return sections.count
     }

     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
         return sections.map{$0.letter}
     }

     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return sections[section].letter
     }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Here, we use NSFetchedResultsController
        // And we simply use the section name as title
         

        // Dequeue with the reuse identifier
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as? TableSectionHeader
        header?.backgroundColor = UIColor.white
         return header
    }
       
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        view.backgroundColor = UIColor.white
        view.tintColor = .white
           
        
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.init(red: 93.0/255.0, green: 26.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    // MARK: - Table view data source
    
     

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterSelectionTableCell", for: indexPath) as! HunterSelectionTableCell
        cell.selectionStyle = .none
        let section = sections[indexPath.section]
        let username = section.names[indexPath.row]
        cell.titleLabel?.text = username
        
        cell.imgSelection?.image = UIImage.init(named: self.imgNameUnselect)

        if(isMultiSelect){
            
            let usernames : [String] = passedDict.map { ($0.value as? String ?? "Null") }
            
            let indexOfA = usernames.firstIndex(of: username) // 0
            let dict = NSMutableDictionary()
            dict["name"] = username
            dict["id"] = passedDict.allKeys[indexOfA!] as! String
            
            let myDict:NSDictionary =
                ["name": username, "id": passedDict.allKeys[indexOfA!] as! String]
            
            if selectedIDArray.contains(myDict["id"] as! String){
                cell.imgSelection?.image = UIImage.init(named: self.imgName)
            }else{
                cell.imgSelection?.image = UIImage.init(named: self.imgNameUnselect)
            }
            
            
        }
        
        return cell
        
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultiSelect == false {
            let section = sections[indexPath.section]
            let username = section.names[indexPath.row]
            let usernames : [String] = passedDict.map { ($0.value as? String ?? "Null") }
            
            let indexOfA = usernames.firstIndex(of: username) // 0
            
            
            let dict = NSMutableDictionary()
            dict["name"] = username
            dict["id"] = passedDict.allKeys[indexOfA!] as! String
            
            let myDict:NSDictionary =
                ["name": username, "id": passedDict.allKeys[indexOfA!] as! String]
            
            print(myDict)
            
            self.dismiss(animated: true) {
                
                self.delegate?.selectedData(selectedDict: myDict, isFrom: self.isFrom)
            }
        }else{
            let section = sections[indexPath.section]
            let username = section.names[indexPath.row]
            let usernames : [String] = passedDict.map { ($0.value as? String ?? "Null") }
            let indexOfA = usernames.firstIndex(of: username) // 0
            
            let myDict:NSDictionary =
            ["name": username, "id": passedDict.allKeys[indexOfA!] as! String]
            
            if selectedData.contains(myDict){
                let index = selectedData.firstIndex(of: myDict)!
                selectedData.remove(at: index)
                selectedIDArray.remove(at: index)
            }else{
                if selectedIDArray.count < 5{
                    selectedIDArray.append(myDict["id"] as! String)
                    selectedData.append(myDict)
                }
            }
            
            if isMultiSelect == true {
                self.lblSelectedCount.text = "\(selectedIDArray.count)/5"
            }
            else {
                self.lblSelectedCount.text = "\(selectedIDArray.count)/1"
            }
            
            print(selectedData)
            setHeadertTitle()
            tbl_view.reloadData()
     
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class HunterSelectionTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    



}
