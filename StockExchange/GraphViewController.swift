//
//  GraphViewController.swift
//  StockExchange
//
//  Created by Archita Bansal on 20/04/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController,GraphDataDelegate {
    
    var lineChart = LineChart()
    var graphData = NSArray()
    var timeStampArray = [String]()
    var lastTradedPriceArray = [CGFloat]()
    var bestBuyPriceArray = [CGFloat]()
    var bestBuyQuantityArray = [CGFloat]()
    var bestSellPriceArray = [CGFloat]()
    var bestSellQuantity = [CGFloat]()
    
    let url = "http://0.0.0.0:48129"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = lineChart.charcoalGrey
        self.getGraphData()
        
       // self.drawChart(self.graphData)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NetworkHelper.sharedInstance.delegate = self
        
    }

   
    func drawChart(yValues : [CGFloat],xValues : [String]){
        
        var xLabels = [String]()
        var data = [CGFloat]()
        // simple arrays
        if yValues.count > 0{
            
            data = yValues
            xLabels = xValues
        }else{
        
            data = [5.0,-3.0,8.0,4.3,6.7]//data as! [CGFloat]
            xLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        }
        
        
        
        // simple line with custom x axis labels
        
        
        lineChart = LineChart()
        lineChart.tag = 100
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = false
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.grid.visible = false
        lineChart.y.grid.visible = false
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        
        
        for view in self.view!.subviews{
            
            if view.isKindOfClass(LineChart){
                
                view.removeFromSuperview()
                break
                
            }
            
        }
        
        
        self.view.addSubview(lineChart)
        var views: [String: AnyObject] = [:]
        
        
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-120.0-[chart]-50.0-|", options: [], metrics: nil, views: views))
        

    
        
        
    }
    
    
    func getGraphData(){
        
        NetworkHelper.sharedInstance.sendGetRequest(NSURL(string: self.url)!)
        
        
        
    }
    
    func getStringData(string: NSString) {
        
        
        var dataPerSecond = string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        print(dataPerSecond)
        
        for data in dataPerSecond{
            
            if data != ""{
                
                
                var dataArray = data.componentsSeparatedByString(",")
                
                self.timeStampArray.append(dataArray[0])
              

                
                if let n = NSNumberFormatter().numberFromString(dataArray[1]) {
                    let f = CGFloat(n)
                    self.lastTradedPriceArray.append(f)
                }

                
            }
            
            
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.drawChart(self.lastTradedPriceArray,xValues: self.timeStampArray)
            
            
        })

        

        
        
        
    }
    
    
    

}
