//
//  ViewController.swift
//  ConcurrencyProject
//
//  Created by İlker Kaya on 27.01.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let array: [CFTimeInterval] = [
        1,
        3,
        5,
        7,
        2,
        7
    ]
    
    @IBOutlet weak var currentValue: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pickerView1: UIPickerView!
    
    @IBOutlet weak var pickerView2: UIPickerView!
    
    let source = ["userInteractive","userInitiaded","default","utility","background","unspecified"]
    let source2 = ["Seri_Kuyruk","Global","Eşzamanlı_kuyruk"]
    
    var result: String = "userInteractive"
    var result2: String = "Seri_Kuyruk"
    
    var post: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        getXIB()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        post = []
        self.tableView.reloadData()
        if result == "userInteractive" {
            whichType(qos: .userInteractive)
            self.tableView.reloadData()
        }else if result == "userInitiaded" {

            whichType(qos: .userInitiated)
            self.tableView.reloadData()
        }else if result == "default" {

            whichType(qos: .default)
            self.tableView.reloadData()
        }else if result == "utility" {

            whichType(qos: .utility)
            self.tableView.reloadData()
        }else if result == "background" {

            whichType(qos: .background)
            self.tableView.reloadData()
        }else if result == "unspecified" {

            whichType(qos: .unspecified)
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath) as! TableViewCell
        let data = post[indexPath.row]
        if result == "userInteractive" {
            fetchPhotoControl(qos: .userInteractive, cell: cell, data: data)
        }else if result == "userInitiaded" {
            fetchPhotoControl(qos: .userInitiated, cell: cell, data: data)
        }else if result == "default" {
            fetchPhotoControl(qos: .default, cell: cell, data: data)
        }else if result == "utility" {
            fetchPhotoControl(qos: .utility, cell: cell, data: data)
        }else if result == "background" {
            fetchPhotoControl(qos: .background, cell: cell, data: data)
        }else if result == "unspecified" {
            fetchPhotoControl(qos: .unspecified, cell: cell, data: data)
        }
        return cell
    }
    
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return source.count
        } else if pickerView == pickerView2 {
            return source2.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1  {
            return source[row]
        } else if pickerView == pickerView2{
            return source2[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            result = source[row]
            currentValue.title = result
        } else if pickerView == pickerView2{
            result2 = source2[row]
        }
    }
}

extension ViewController {
    
    func whichType(qos: DispatchQoS){
        if result2 == "Seri_Kuyruk" {
            let privateSerialQueue = DispatchQueue(label: "concurrency.privateSerialQueueUtility", qos: qos)
            interQoS(type: privateSerialQueue,qos: qos)
        } else if result2 == "Global" {
            let globalQueue = DispatchQueue.global(qos: qos.qosClass)
            interQoS(type: globalQueue,qos: qos)
        } else if result2 == "Eşzamanlı_kuyruk" {
            let privateConcurrentQueue = DispatchQueue(label: "concurrency.privateConcurrencyQueueUtility",qos: qos, attributes: .concurrent)
            interQoS(type: privateConcurrentQueue,qos: qos)
        }
    }
    
    func interQoS(type: DispatchQueue, qos: DispatchQoS){
        type.async(qos: qos) {
            let url = "https://jsonplaceholder.typicode.com/photos"
            AF.request(url).responseDecodable(of: [Photo].self) { response in
                guard let posts = response.value else { return }
                self.post = posts
                self.tableView.reloadData()
                
            }
        }
    }
    
    func fetchPhotoControl(qos: DispatchQoS, cell: TableViewCell, data: Photo){
        if result2 == "Seri_Kuyruk" {
            let privateSerialQueue = DispatchQueue(label: "concurrency.privateSerialQueueUtility", qos: qos)
            privateSerialQueue.async {
                let images = try? Data(contentsOf: URL(string:data.url)!)
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: images!)
                    cell.title.text = data.title
                }
            }
        } else if result2 == "Global" {
            let globalQueue = DispatchQueue.global(qos: qos.qosClass)
            globalQueue.async {
                let images = try? Data(contentsOf: URL(string:data.url)!)
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: images!)
                    cell.title.text = data.title
                }
            }
        } else if result2 == "Eşzamanlı_kuyruk" {
            let privateConcurrentQueue = DispatchQueue(label: "concurrency.privateConcurrencyQueueUtility",qos: qos, attributes: .concurrent)
            privateConcurrentQueue.async {
                let images = try? Data(contentsOf: URL(string:data.url)!)
                
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: images!)
                    cell.title.text = data.title
                }
            }
        }
    }
    
    func getXIB(){
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "table")
    }
    
    func getData(){
        let group = DispatchGroup()
        
        for number in array {
            group.enter()
            print("Entering group with number: \(number)")
            DispatchQueue.global().asyncAfter(deadline: .now() + number, execute:  {
                group.leave()
                print("leaving group for \(number)")
            })
        }
        
        group.notify(queue: .main) {
            print("Done with all operations")
        }
    }
}
