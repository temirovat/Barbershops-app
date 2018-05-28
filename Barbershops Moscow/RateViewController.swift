//
//  RateViewController.swift
//  Barbershops Moscow
//
//  Created by Alan on 23/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var ratingSV: UIStackView!
    @IBOutlet weak var badButton1: UIButton!
    @IBOutlet weak var goodButton2: UIButton!
    @IBOutlet weak var brilliantButton3: UIButton!
      var barberRating: String?
    
    @IBAction func rateBarber(sender: UIButton) {
        switch sender.tag {
        case 0: barberRating = "love"
        case 1: barberRating = "good"
        case 2: barberRating = "bad"
        default: break
        }
        performSegue(withIdentifier: "unwindToBSC", sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let buttonArray = [badButton1, goodButton2, brilliantButton3]
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        badButton1.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton2.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton3.transform = CGAffineTransform(scaleX: 0, y: 0)
        
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        self.view.insertSubview(blurEffectView, at: 1)
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
