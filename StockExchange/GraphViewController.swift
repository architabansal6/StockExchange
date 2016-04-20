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
    var timeStampArray = [String]()
    var lastTradedPriceArray = [CGFloat]()
    var bestBuyPriceArray = [CGFloat]()
    var bestBuyQuantityArray = [CGFloat]()
    var bestSellPriceArray = [CGFloat]()
    var bestSellQuantity = [CGFloat]()
    var buyButton = UIButton()
    var sellButton = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    
    let url = "http://0.0.0.0:48129"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addActivityIndicator()
        self.addButtons()
        self.view.backgroundColor = lineChart.charcoalGrey
        self.getGraphData()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NetworkHelper.sharedInstance.delegate = self
        
    }
    
   // MARK:- UI SETUP
    
    func addActivityIndicator(){
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(view.bounds.width/2 - 20, view.bounds.height/2 - 20, 40, 40))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
    }
    
    
    func addButtons(){
        
        //Buy Button
        self.buyButton.setTitle("BUY", forState: UIControlState.Normal)
        self.buyButton.translatesAutoresizingMaskIntoConstraints = false
        self.buyButton.alignmentRectInsets()
        self.buyButton.tag = 101
        self.buyButton.hidden = true
        self.buyButton.backgroundColor = UIColor(red: 0, green: 113/255, blue: 161/255, alpha: 0.7)
        self.buyButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(self.buyButton)
        
        
        //Sell Button
        self.sellButton.setTitle("SELL", forState: UIControlState.Normal)
        self.sellButton.tag = 102
        self.sellButton.hidden = true
        self.sellButton.backgroundColor = UIColor(red: 0, green: 113/255, blue: 161/255, alpha: 0.7)
        self.sellButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchDown)
        self.sellButton.translatesAutoresizingMaskIntoConstraints = false
        self.sellButton.alignmentRectInsets()
        self.view.addSubview(self.sellButton)
        
        
        
        
        
    }

    func buttonTapped(sender:UIButton){
        
        if sender.tag == 101{
            //buy
            var buyAlert = UIAlertController(title: "Wait", message: "You can buy soon", preferredStyle: UIAlertControllerStyle.Alert)
            buyAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(buyAlert, animated: true, completion: nil)
        }else{
            //sell
            var sellAlert = UIAlertController(title: "Wait", message: "You will sell soon", preferredStyle: UIAlertControllerStyle.Alert)
            sellAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(sellAlert, animated: true, completion: nil)

            
        }
        
    }
    
    func lightenUIColor(color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 1, alpha: a * 0.5)
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
            xLabels = ["5", "10", "15", "20", "25", "30"]
        }
        
        
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
        self.buyButton.hidden = false
        self.sellButton.hidden = false
        
        self.addConstraints()
        
        
        
    }
    
    func addConstraints(){
        
        
        var views: [String: AnyObject] = [:]
        
        
        views["buyButton"] = self.buyButton
        views["sellButton"] = self.sellButton
        views["chart"] = self.lineChart
        
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        
//        let centerConstraintX = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
//        let centerConstraintY = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
//
//        view.addConstraint(centerConstraintX)
//        view.addConstraint(centerConstraintY)
//        
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[buyButton]-20-[sellButton(==buyButton)]-16-|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[chart]-16-[sellButton(44)]", options: [], metrics: nil, views: views))
        
        
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[chart]-16-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[chart]-16-[buyButton(44)]-16-|", options: [], metrics: nil, views: views))
        
        

        
    }
    
    //MARK: - DATA FUNCTIONS
    
    
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
            self.activityIndicator.stopAnimating()
            
            
        })

        

        
        
        
    }
    
    
    

}
