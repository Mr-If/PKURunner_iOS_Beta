//
//  ViewController.swift
//  DistanceChart
//
//  Created by CMouse on 16/9/5.
//  Copyright © 2016年. All rights reserved.
//

import UIKit
import Alamofire
import SwiftChart
import Charts

class ChartViewController: BaseViewController {
    

    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet weak var distanceview: BarChartView!
    
    let serverURL = "http://162.105.205.61:10201/"
    let id = "1500000000"
    let token = "233333"
    
    let week = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let month = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    let year = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    let daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var weekData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var monthData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var yearData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    var currentYear = 2016
    var currentMonth = 1
    var currentDay = 1
    // 1 is Sunday, 2 is Monday ...
    var currentWeekday = 1
    var currentWeekOfYear = 1
    
    var upperBound = 20160101
    var lowerBound = 20160101
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="跑步统计";
        getCurrentDate()
        initChart()
        
        /* 上传跑步记录，仅测试用
        
        let calenderForUpload = NSCalendar.currentCalendar()
        
        let nsdateComponentsForUpload = NSDateComponents()
        nsdateComponentsForUpload.year = 2016
        nsdateComponentsForUpload.month = 7
        nsdateComponentsForUpload.day = 30
        let nsdateForUpload = calenderForUpload.dateFromComponents(nsdateComponentsForUpload)
        print(nsdateForUpload)
        
        Alamofire.request(.POST, serverURL + "/record/" + id, headers: ["Authorization":token], parameters: ["distance":1350, "duration":430, "date":nsdateForUpload!]) .responseJSON { response in
            // print(response.request)
            // print(response.response)
            // print(response.data)
            print(response.result)
        }
        */

        
        // 获取所有的跑步记录
        Alamofire.request(.GET, serverURL + "/record/" + id, headers: ["Authorization":token]) .responseJSON { response in
            // print(response.request)
            // print(response.response)
            // print(response.data)
            // print(response.result)
            if let json = response.result.value {
                let records = json["records"] as! NSArray
                // print(records.count)
                if (records.count != 0) {
                    for i in 0...(records.count - 1) {
                        let record = records[i]
                        let timestamp = record["date"] as! String
                        let distance = record["distance"] as! Double
                        let date = timestamp.substringToIndex(timestamp.startIndex.advancedBy(10))
                        
                        let year = Int(date.componentsSeparatedByString("-")[0])!
                        let month = Int(date.componentsSeparatedByString("-")[1])!
                        let day = Int(date.componentsSeparatedByString("-")[2])!
                        
                        let calender = NSCalendar.currentCalendar()
                        
                        let nsdateComponents = NSDateComponents()
                        nsdateComponents.year = year
                        nsdateComponents.month = month
                        nsdateComponents.day = day
                        let nsdate = calender.dateFromComponents(nsdateComponents)
                        
                        let c = calender.components([.Weekday, .WeekOfYear], fromDate: nsdate!)
                        
                        if (year == self.currentYear) {
                            self.yearData[month - 1] += distance
                        }
                        if (year == self.currentYear && month == self.currentMonth) {
                            self.monthData[day - 1] += distance
                        }
                        if (year == self.currentYear && c.weekOfYear == self.currentWeekOfYear) {
                            self.weekData[c.weekday - 1] += distance
                        }
                    }
                    
                    for i in 0...(self.yearData.count - 1) {
                        self.yearData[i] /= Double(self.daysInMonth[i])
                    }
                }
                self.updateDistanceChart(self.segmentCtrl)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCurrentDate() {
        let currentDate = Date()
        let calender = Calendar.current
        let components = (calender as NSCalendar).components([.day, .month, .year, .weekday, .weekOfYear], from: currentDate)
        
        currentYear = components.year!
        currentMonth = components.month!
        currentDay = components.day!
        currentWeekday = components.weekday!
        currentWeekOfYear = components.weekOfYear!
    }

    @IBAction func updateDistanceChart(_ sender: UISegmentedControl) {
        let sel = sender.selectedSegmentIndex
        switch(sel) {
        case 0:
            setChart(week, values: weekData, type: 0)
            break;
        case 1:
            setChart(month, values: monthData, type: 1)
            break;
        case 2:
            setChart(year, values: yearData, type: 2)
            break;
        default:
            break;
        }
    }
    
    
    
    func initChart() {
        distanceview.noDataText = "暂无数据。"
        distanceview.descriptionText = ""
        distanceview.xAxis.labelPosition = .Bottom
    }
    
    func setChart(_ dataPoints: [String], values: [Double], type: Int) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            if (i >= values.count) {
                break
            }
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet: BarChartDataSet
        if (type != 2) {
            chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Daily Average /m")
        }
        else {
            chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Monthly Average /m")
        }
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        distanceview.animate(yAxisDuration: 1.0)
        distanceview.data = chartData
    }

}
