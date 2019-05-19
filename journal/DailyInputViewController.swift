//
//  DailyInputViewController.swift
//  journal
//
//  Created by Killenberg, Eva on 5/17/19.
//  Copyright © 2019 Killenberg, Eva. All rights reserved.
//

import UIKit

class DailyInputViewController: UIViewController {
    
    @IBOutlet weak var happinessSlider: UISlider!
    @IBOutlet weak var productivitySlider: UISlider!
    @IBOutlet weak var selfLoveSlider: UISlider!
    @IBOutlet weak var memoryTextView: UITextView!
    @IBOutlet weak var date: UITextView!
    @IBOutlet weak var timeSleepPicker: UIDatePicker!
    @IBOutlet weak var timeWakePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: today)
        date.insertText(dateString)
    }
    
    @IBAction func submit() {
        dismiss(animated: false) {
            let calendar = Calendar.current
            let c = NSDateComponents()
            c.year = calendar.component(.year, from: Date())
            c.month = calendar.component(.month, from: Date())
            c.day = calendar.component(.day, from: Date())
            let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.date(from: c as DateComponents)
            let timestamp = date!.timeIntervalSince1970
            print(timestamp)
            let data = [
                "date": "\(timestamp)",
                "timeSleep": "\(self.timeSleepPicker.date)",
                "timeWake": "\(self.timeWakePicker.date)",
                "memory": "\(self.memoryTextView.text ?? "")",
                "happiness": "\(self.happinessSlider.value)",
                "productivity": "\(self.productivitySlider.value)",
                "love": "\(self.selfLoveSlider.value)"
            ]
            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
            let session = URLSession.shared
            let url = URL(string: "http://localhost:3000/day/new")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Powered by Swift!", forHTTPHeaderField: "X-Powered-By")
            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                }
            }
            print("COMPLETE")
            task.resume()
        }
    }
}
