//
//  JournalViewController.swift
//  journal
//
//  Created by Killenberg, Eva on 5/17/19.
//  Copyright © 2019 Killenberg, Eva. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    @IBOutlet weak var date: UITextView!
    @IBOutlet weak var happiness: UITextView!
    @IBOutlet weak var productivity: UITextView!
    @IBOutlet weak var love: UITextView!
    @IBOutlet weak var sleep: UITextView!
    @IBOutlet weak var memory: UITextView!
    
    var day: Day!
    
    struct Day: Codable {
        var date: Double
        var timeSleep: Double
        var timeWake: Double
        var happiness: Float
        var productivity: Float
        var love: Float
        var memory: String
        var timeSubmit: Double
    }
    
    func setData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateObj = Date(timeIntervalSince1970: day.date)
        let dateString = dateFormatter.string(from: dateObj)
        date.text = dateString
        
        memory.text = day.memory
        
        let calendar = Calendar.current
        let userCalendar = NSCalendar.current
        let hourMinuteComponents: Set<Calendar.Component> = [.hour, .minute]
        let timeSleepDate = Date(timeIntervalSince1970: day.timeSleep)
        let timeWakeDate = Date(timeIntervalSince1970: day.timeWake)
        let timeAsleep = userCalendar.dateComponents(
            hourMinuteComponents,
            from: timeSleepDate,
            to: timeWakeDate
        )
        var hourSleep = calendar.component(.hour, from: timeSleepDate)
        let minuteSleep = calendar.component(.minute, from: timeSleepDate)
        var hourWake = calendar.component(.hour, from: timeWakeDate)
        let minuteWake = calendar.component(.minute, from: timeWakeDate)
        let minuteSleepStr = (minuteSleep < 10) ? "0\(minuteSleep)" : "\(minuteSleep)"
        let minuteWakeStr = (minuteWake < 10) ? "0\(minuteWake)" : "\(minuteWake)"
        if (hourSleep > 12) {
            hourSleep -= 12
        }
        if (hourWake > 12) {
            hourWake -= 12
        }
        sleep.text = "You got \(timeAsleep.hour!) hours and \(timeAsleep.minute!) minutes of sleep, from \(hourSleep):\(minuteSleepStr) to \(hourWake):\(minuteWakeStr)"
        
        happiness.text = "Happiness: \(day.happiness)"
        productivity.text = "Productivity: \(day.productivity)"
        love.text = "Self-Love: \(day.love)"
    }
    
    func getData(timestamp: Double) {
        let session = URLSession.shared
        let url = URL(string: "http://localhost:3000/day/\(timestamp)")!
        let task = session.dataTask(with: url) { data, response, error in
            if (error == nil) {
                do {
                    let decoder = JSONDecoder()
                    self.day = try decoder.decode(Day.self, from: data!)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func loadData(timestamp: Double) {
        getData(timestamp: timestamp)
            while (self.day == nil || self.day.date != timestamp) {
                //wait
            }
        setData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current
        let c = NSDateComponents()
        c.year = calendar.component(.year, from: Date())
        c.month = calendar.component(.month, from: Date())
        c.day = calendar.component(.day, from: Date())
        let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.date(from: c as DateComponents)
        let timestamp = date!.timeIntervalSince1970
        loadData(timestamp: timestamp)
    }
    
    @IBAction func goHome() {
        self.dismiss(animated: true)
    }
    
    @IBAction func prevDay() {
        loadData(timestamp: self.day.date - 86400)
    }
    
    

}
