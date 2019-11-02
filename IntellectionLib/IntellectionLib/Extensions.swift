//
//  NSObjectExtension.swift
//  IntellectionLib
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit
//Mark: NSObject
public extension NSObject
{
    public func calculateSpeedUsing(bytesSent:Int64, seconds:Double)->Double
    {
        let dataTransferSpeedInBytesPerSecond:Double = Double(bytesSent)/seconds //bytes per second
        let dataTransferSpeedInKiloBytesPerSecond = dataTransferSpeedInBytesPerSecond/1024//KBPS
        let dataTransferSpeedInMegaBytesPerSecond = dataTransferSpeedInKiloBytesPerSecond/1024//MBPS
        let dataTransferSpeedInMegaBitsPerSecond = dataTransferSpeedInMegaBytesPerSecond * 8//MbPS
        return dataTransferSpeedInMegaBitsPerSecond
        
        
    }
    func getMiliSecondsFromMachTime(elapsedTime:UInt64)->Double
    {
        
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let elapsedNano = elapsedTime * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom);
        
        return Double(elapsedNano/1000000)
    }
}

//Mark: UIViewcontroller
public extension UIViewController
{
    func hideNavigationBar(flag:Bool)
    {
        self.navigationController?.setNavigationBarHidden(flag, animated: true)
    }
    func setBackButton(backButtonImage:UIImage)
    {
        self.navigationItem.leftBarButtonItem=getBackButton(backButtonImage:backButtonImage)
    }
    func getBackButton(backButtonImage:UIImage)->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:backButtonImage, style: .plain, target: self, action: #selector(backButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        return button1
    }
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    func isConnectedToInternet(errorMessage:String)->Bool
    {
        let status = Reach().connectionStatus()
        
        switch status
        {
        case .unknown, .offline:
            displayActivityAlert(title: errorMessage)
            return false
        case .online(.wwan):
            return true
        case .online(.wiFi):
            return true
        }
        
    }
    
    func displayActivityAlert(title: String)
    {
        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        present(pending, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
            pending.dismiss(animated: true, completion: nil)
            
        }
        
    }
    func displayActivityAlertWithButtonCaption(title: String, buttonCaption:String)
    {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonCaption, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showHUD(message:String)
    {
        DispatchQueue.main.async {
            ALLoadingView.manager.resetToDefaults()
            ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
            ALLoadingView.manager.messageText = message
        }
        
    }
    func hideHUD()
    {
        DispatchQueue.main.async {
            ALLoadingView.manager.hideLoadingView(withDelay: 0.0)
        }
    }
}
//Mark: String
//String extension for checking empty,nil or  string contains only whitespaces
public extension Optional where Wrapped == String {
    func isEmptyOrWhitespace() -> Bool {
        // Check nil
        guard let this = self else { return true }
        
        // Check empty string
        if this.isEmpty {
            return true
        }
        // Trim and check empty string
        return (this.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self!, options: [], range: NSRange(location: 0, length: self!.count)) != nil
    }
}
