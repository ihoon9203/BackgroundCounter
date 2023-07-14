//
//  ViewController.swift
//  BackgroundCounter
//
//  Created by Jeonghoon Oh on 2023/07/11.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var count: UILabel!
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSentBG), name: NSNotification.Name("one"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFailBG), name: NSNotification.Name("two"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishBG), name: NSNotification.Name("three"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFailSending), name: NSNotification.Name("fail"), object: nil)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setLongBGTask(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.scheduleLongAppRefresh()
    }
    @IBAction func submitBGTask(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.scheduleAppRefresh()
    }
    @IBAction func updateView(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        count.text = String(UserDefaults.standard.integer(forKey: "count"))
        status.text = "updated"
    }
    @objc func didSentBG() {
        status.text = "sent"
    }
    @objc func didFailBG() {
        status.text = "fail"
    }
    @objc func didFinishBG() {
        count.text = String(UserDefaults.standard.integer(forKey: "count"))
        status.text = "finish"
    }
    @objc func didFailSending() {
        count.text = String(UserDefaults.standard.integer(forKey: "count"))
        status.text = "ff"
    }
}
