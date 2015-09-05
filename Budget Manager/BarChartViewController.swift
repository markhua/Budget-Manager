//
//  BarChartViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let monthlyexpense = AccountClient.sharedInstance().monthlyexpense
        setChart(months, values: monthlyexpense, pievalues: AccountClient.sharedInstance().expensebycat)
        
    }
    
    func setChart(dataPoints: [String], values: [Double], pievalues: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Expense")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.descriptionText = ""
        
        var categories = ["Food and Drink", "Shop and Computers", "Transfer", "Others"]
        
        var piedataEntries: [ChartDataEntry] = []
        
        for i in 0..<categories.count {
            let dataEntry = ChartDataEntry(value: pievalues[i], xIndex: i)
            piedataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: piedataEntries, label: "Expense")
        let pieChartData = PieChartData(xVals: categories, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        pieChartView.descriptionText = ""
    }
    
}
