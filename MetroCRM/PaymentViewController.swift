//
//  PaymentViewController.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 21/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//  checksm formula : apiKey+TID+orderNo+orderDescription+currency+amount+method+apiOperation+cardType+email
//    orderNo = METRO+user login id+current timestamp

import UIKit
import WebKit

class PaymentViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    var email = String()
    var amount = String()
    var orderNo = String()
    var checksmStr = String()
    var urlStr = String()
    let apiKey : String = "93704aec1d3846b7"
    let TID : String = "METROCRM02"
    let orderDescription : String = "BigRPayment"
    let currency : String = "MYR"
    let operation : String = "SALE"
    let cardType : String = ""
    let method : String = "FT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checksmStr = "\(apiKey)\(TID)\(orderNo)\(orderDescription)\(currency)\(amount)\(method)\(operation)\(cardType)\(email)"
        let checksum = checksmStr.sha1()
        print("orderNo\(orderNo)")
        print("chksmStr\(checksmStr)")
        print("chsm \(checksum)")
        webView.navigationDelegate = self
        urlStr = "https://apps.absecdev.xyz/payment/echeckout?amount=\(amount)&method=\(method)&cardType=\(cardType)&apiOperation=\(operation)&orderDescription=\(orderDescription)&email=\(email)&TID=\(TID)&checksum=\(checksum)&orderNo=\(orderNo)&currency=\(currency)"
        print(urlStr)
        loadWebView()
    
    }
    func loadWebView() {
        
        let url = URL(string: urlStr)
        webView.load(URLRequest(url: url!))
    }
    /*func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }  */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
