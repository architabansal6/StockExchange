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
    var bestBuyQuantityArray = [String]()
    var bestSellPriceArray = [CGFloat]()
    var bestSellQuantity = [String]()
    var buyButton = UIButton()
    var sellButton = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    var buySellView = UIView()
    var txtQuantity = UITextField()
    var txtPrice = UITextField()
    var option = ""
    var currentTimeInterval : String?
    var currentBestSellPrice : CGFloat?
    var currentBestBuyPrice : CGFloat?
    var quantForBestBuy : Int?
    var quantForBestSell : Int?
    
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
        self.buyButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.AllEvents)
        self.buyButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)!
        self.view.addSubview(self.buyButton)
        
        
        //Sell Button
        self.sellButton.setTitle("SELL", forState: UIControlState.Normal)
        self.sellButton.tag = 102
        self.sellButton.hidden = true
        self.sellButton.backgroundColor = UIColor(red: 0, green: 113/255, blue: 161/255, alpha: 0.7)
        self.sellButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.AllEvents)
        self.sellButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)!
        self.sellButton.translatesAutoresizingMaskIntoConstraints = false
        self.sellButton.alignmentRectInsets()
        self.view.addSubview(self.sellButton)
        
        
        
        
        
    }

    func buttonTapped(sender:UIButton){
        
        if sender.tag == 101{
            //buy
            self.option = "buy"
            self.createBuySellView()

        }else{
            //sell
            self.option = "sell"
            self.createBuySellView()
            

        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.buySellView.endEditing(true)
        
    }
    
    func createBuySellView(){
        
        for view in self.buySellView.subviews{
            view.removeFromSuperview()
        }
        
        
        let height : CGFloat = 188
        self.buySellView.frame = CGRect(x: 16.0, y: ((view.bounds.height/2) - (height/2)), width: view.bounds.width - 32.0, height: height)
        self.buySellView.backgroundColor = UIColor(red: 127/255, green: 209/255, blue: 255/255, alpha: 0.9)
        
        UIApplication.sharedApplication().keyWindow!.addSubview(self.buySellView)
       
        var quantityLabel = UILabel(frame: CGRect(x: 16, y: 16, width: view.bounds.width/2 - 32 - 4, height: 44))
        quantityLabel.text = "Quantity"
        quantityLabel.textColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        quantityLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)!
        self.buySellView.addSubview(quantityLabel)
        
        self.txtQuantity = UITextField(frame: CGRect(x: buySellView.bounds.origin.x + buySellView.bounds.width - 16 - quantityLabel.frame.width , y: 16, width: quantityLabel.frame.width, height: 44))
        
        let borderQ = CALayer()
        let widthQ = CGFloat(1.0)
        borderQ.borderColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1).CGColor
        borderQ.frame = CGRect(x: 0, y: txtQuantity.frame.size.height - widthQ, width:  txtQuantity.frame.size.width, height: txtQuantity.frame.size.height)
        
        borderQ.borderWidth = widthQ
        txtQuantity.layer.addSublayer(borderQ)
        txtQuantity.layer.masksToBounds = true
        txtQuantity.textColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        txtQuantity.becomeFirstResponder()
        self.buySellView.addSubview(txtQuantity)
        
        
        var priceLabel = UILabel(frame: CGRect(x: 16, y: quantityLabel.frame.origin.y + 44 + 16, width: view.bounds.width/2 - 32 - 4, height: 44))
        priceLabel.text = "Price(Optional)"
        priceLabel.textColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        priceLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)!
        self.buySellView.addSubview(priceLabel)
        
        self.txtPrice = UITextField(frame: CGRect(x: buySellView.bounds.origin.x + buySellView.bounds.width - 16 - quantityLabel.frame.width , y: txtQuantity.frame.origin.y + 44 + 16, width: quantityLabel.frame.width, height: 44))
        let borderP = CALayer()
        let widthP = CGFloat(1.0)
        borderP.borderColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1).CGColor
        borderP.frame = CGRect(x: 0, y: txtPrice.frame.size.height - widthP, width:  txtPrice.frame.size.width, height: txtPrice.frame.size.height)
        
        borderP.borderWidth = widthP
        txtPrice.layer.addSublayer(borderP)
        txtPrice.layer.masksToBounds = true
        txtPrice.textColor = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1)
        self.buySellView.addSubview(txtPrice)
        
        var cancelButton = UIButton(frame: CGRect(x: 16, y: txtPrice.frame.origin.y + 44 + 8, width: 100, height: 44))
       // cancelButton.backgroundColor = UIColor(red: 35/255, green: 140/255, blue: 100/255, alpha: 1.0)
        cancelButton.setTitle("CANCEL", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancel", forControlEvents: UIControlEvents.AllEvents)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)!
        self.buySellView.addSubview(cancelButton)
        
        var saveButton = UIButton(frame: CGRect(x: buySellView.bounds.origin.x + buySellView.bounds.width - 100 - 16, y: txtPrice.frame.origin.y + 44 + 8, width: 100, height: 44))
       // saveButton.backgroundColor = UIColor(red: 0, green: 113/255, blue: 161/255, alpha: 0.7)
        saveButton.setTitle("SAVE", forState: UIControlState.Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "onSave", forControlEvents: UIControlEvents.AllEvents)
        saveButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)!
        self.buySellView.addSubview(saveButton)

        
        
        
    }
    
    func onCancel(){
        
        self.buySellView.removeFromSuperview()
        
    }
    
    func onSave(){
        
        
        self.currentTimeInterval = self.timeStampArray.last
        let index = self.timeStampArray.count - 1
        self.currentBestSellPrice = self.bestSellPriceArray[index]
        self.currentBestBuyPrice = self.bestBuyPriceArray[index]
        self.quantForBestSell = NSNumberFormatter().numberFromString(self.bestSellQuantity[index])?.integerValue
        self.quantForBestBuy = NSNumberFormatter().numberFromString(self.bestBuyQuantityArray[index])?.integerValue
        self.buySellStocks()
        
        
        
    }
    
    
    
    func buySellStocks(){
        
        if txtPrice.text == ""{
            //market order
            
            if let quant = NSNumberFormatter().numberFromString(self.txtQuantity.text!)?.integerValue{
                var amount : CGFloat = 0
                var boughtQuantity : Int = 0
                var price : CGFloat = 0
                var titl : String = ""
                var boughtOrSold = ""
                
                if self.option == "buy"{
                    //buy market order
                    price = currentBestBuyPrice!
                    titl = "Order Placed"
                    boughtOrSold = "bought"
                }else{
                    //sell market order
                    price = currentBestSellPrice!
                    titl = "Sold"
                    boughtOrSold = "sold"
                    
                }

                if quant < quantForBestBuy{
                    
                    amount = CGFloat(quant) * currentBestBuyPrice!
                    boughtQuantity = quant
                    
                }else{
                    
                    amount = CGFloat(quantForBestBuy!) * currentBestBuyPrice!
                    boughtQuantity = quantForBestBuy!
                    
                }
                self.buySellView.removeFromSuperview()
                let alert = UIAlertController(title: "\(titl)", message: "You have \(boughtOrSold) \(boughtQuantity) stocks for Rs\(String(format: "%.2f", amount)) at Rs\(String(format: "%.2f", price))", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
            
        }else{
            //limit order
            if self.option == "buy"{
                
                var buyPrice : CGFloat = 0
                if let n = NSNumberFormatter().numberFromString(txtPrice.text!) {
                    let userPrice = CGFloat(n)
                    
                    if currentBestBuyPrice < userPrice{
                        buyPrice = currentBestBuyPrice!
                    }else{
                        buyPrice = userPrice
                    }
                    
                }
                let userQuan = NSNumberFormatter().numberFromString(txtQuantity.text!)?.integerValue
                var buyQuan = 0
                var remainingQuan = 0
                if userQuan <= quantForBestBuy!{
                    buyQuan = userQuan!
                }else{
                    buyQuan = quantForBestBuy!
                    remainingQuan = buyQuan - quantForBestBuy!
                }
                
                let amount = buyPrice * CGFloat(buyQuan)
                self.buySellView.removeFromSuperview()
                let alert = UIAlertController(title: "Order Placed", message: "You have bought \(buyQuan) stocks for Rs\(String(format: "%.2f", amount)) at Rs\(String(format: "%.2f", buyPrice))", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

                
            }else{
                var sellPrice : CGFloat = 0
                if let n = NSNumberFormatter().numberFromString(txtPrice.text!) {
                    let userPrice = CGFloat(n)
                    
                    if currentBestSellPrice > userPrice{
                        sellPrice = currentBestBuyPrice!
                    }else{
                        sellPrice = userPrice
                    }
                    
                }
                let userQuan = NSNumberFormatter().numberFromString(txtQuantity.text!)?.integerValue
                var soldQuan = 0
                var remainingQuan = 0
                if userQuan <= quantForBestBuy!{
                    soldQuan = userQuan!
                }else{
                    soldQuan = quantForBestBuy!
                    remainingQuan = soldQuan - quantForBestBuy!
                }
                
                let amount = sellPrice * CGFloat(soldQuan)
                self.buySellView.removeFromSuperview()
                let alert = UIAlertController(title: "Sold", message: "You have sold \(soldQuan) stocks for Rs\(String(format: "%.2f", amount)) at Rs\(String(format: "%.2f", sellPrice))", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

                
                
                
            }
            
            
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
                if let n = NSNumberFormatter().numberFromString(dataArray[2]) {
                    let f = CGFloat(n)
                    self.bestBuyPriceArray.append(f)
                }
                if let n = NSNumberFormatter().numberFromString(dataArray[4]) {
                    let f = CGFloat(n)
                    self.bestSellPriceArray.append(f)
                }
                
                self.bestBuyQuantityArray.append(dataArray[3])
                self.bestSellQuantity.append(dataArray[5])
                
//                if let i = Int(dataArray[3]) {
//                    self.bestBuyQuantityArray.append(i)
//                }
//                if let i = Int(dataArray[5]) {
//                    self.bestSellQuantity.append(i)
//                }
                
                

                
            }
            
            
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            self.drawChart(self.lastTradedPriceArray,xValues: self.timeStampArray)
            self.activityIndicator.stopAnimating()
            
            
        })

        

        
        
        
    }
    
    
    

}
