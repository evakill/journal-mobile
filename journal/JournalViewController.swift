//
//  JournalViewController.swift
//  journal
//
//  Created by Killenberg, Eva on 5/17/19.
//  Copyright © 2019 Killenberg, Eva. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    @IBOutlet weak var date, happiness, productivity, love, timeSleep, timeWake, memory: UITextView!
    
    var timestamp: Double = 0.0
    
    var day: Day?
    
    struct Day: Codable {
        var date: Double
        var timeSleep: String
        var timeWake: String
        var happiness: Float
        var productivity: Float
        var love: Float
        var memory: String
        var timeSubmit: String
    }
    
    func setData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateObj = Date(timeIntervalSince1970: day!.date)
        let dateString = dateFormatter.string(from: dateObj)
        date.insertText(dateString)
        return
    }
    
    let getDataCompletionHandler: (Bool) -> Void) = {
        success in
        self.setData()
    }
    
    func reload() {
        getData(completionHandler: getDataCompletionHandler)
    }
    
    func getData(completionHandler: @escaping (Bool) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "http://localhost:3000/day/\(self.timestamp)")!
        let task = session.dataTask(with: url) { data, response, error in
            let success = (error == nil)
            completionHandler(success)
            
            do {
                let decoder = JSONDecoder()
                self.day = try decoder.decode(Day.self, from: data!)
                print("5")
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current
        let c = NSDateComponents()
        c.year = calendar.component(.year, from: Date())
        c.month = calendar.component(.month, from: Date())
        c.day = calendar.component(.day, from: Date())
        let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.date(from: c as DateComponents)
        timestamp = date!.timeIntervalSince1970
        
    }

}
