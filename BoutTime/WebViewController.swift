//
//  WebViewController.swift
//  BoutTime
//
//  Created by howroot on 11/04/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    // Close web view
    @IBAction func dismissWebView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Convert string to url to URLRequest
        let link = URL(string: urlString)
        let request = URLRequest(url: link!)
        
        // Load request
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
