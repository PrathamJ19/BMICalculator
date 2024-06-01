//
//  ViewController.swift
//  BMICalculator
//
//  Created by Pratham Jadhav on 2024-05-23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayOut: UILabel!
    
    @IBOutlet weak var HeightIn: UITextField!
    
    @IBOutlet weak var inchesIN: UITextField!
    
    @IBOutlet weak var WeightIn: UITextField!
    
    @IBOutlet weak var ResultOut: UITextField!
    
    @IBOutlet weak var ImageOut: UIImageView!
    
    @IBOutlet weak var bmiCalcText: UILabel!
    
    @IBOutlet weak var dietRec: UIButton!
    
    var Switch_On = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageOut.layer.backgroundColor = CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 1)
    }
    
    @IBOutlet weak var OutputCalc: UITextField!
    
    @IBAction func SwitchState(_ sender: UISwitch) {
            Switch_On = sender.isOn
            configureInputFields()
        }
        
    @IBAction func OnCalcClicked(_ sender: UIButton) {
            doMath()
        }
    
    
    @IBAction func onDietRecClicked(_ sender: UIButton) {
        openDietBlog()
    }
    
        func configureInputFields() {
            if Switch_On {
                HeightIn.placeholder = "in cms"
                WeightIn.placeholder = "in kgs"
                ImageOut.image = UIImage(named: "main")
                displayOut.text = ""
                inchesIN.isHidden = true
                OutputCalc.isHidden = true
                bmiCalcText.isHidden = true
                dietRec.isHidden = true
            } else {
                HeightIn.placeholder = "in feets"
                inchesIN.placeholder = "in inches"
                WeightIn.placeholder = "in pounds"
                ImageOut.image = UIImage(named: "main")
                displayOut.text = ""
                inchesIN.isHidden = false
                OutputCalc.isHidden = true
                bmiCalcText.isHidden = true
                dietRec.isHidden = true
            }
        }
        
        func doMath() {
            let heightFeet = validateTextField(textValue: HeightIn.text)
            let heightInches = validateTextFieldinches(textValue: inchesIN.text)
            let weight = validateTextField(textValue: WeightIn.text)
            
            var height: Double = 0
            
            if Switch_On == false {
                height = (heightFeet.1 * 12) + heightInches.1
            } else {
                height = heightFeet.1
            }
            
            if heightFeet.0 && heightInches.0 && weight.0 {
                let heightInMeters = Switch_On ? height / 100 : height * 0.0254
                let weightKg = Switch_On ? weight.1 : weight.1 * 0.453592
                let resultInMetric = weightKg / (heightInMeters * heightInMeters)
                let result = (weight.1 / (height * height)) * 703
                
                var resultOut: Double = result
                resultOut = resultInMetric
                
                OutputCalc.isHidden = false
                bmiCalcText.isHidden = false
                dietRec.isHidden = false
                
                if resultOut < 18.5 {
                    ImageOut.image = UIImage(named: "underweight")
                    displayOut.text = "You are Under Weight!"
                    displayOut.textColor = UIColor.red
                } else if (resultOut >= 18.5 && resultOut <= 24.99) {
                    ImageOut.image = UIImage(named: "normalweight")
                    displayOut.text = "Your weight is normal."
                    displayOut.textColor = UIColor.label
                } else if (resultOut >= 25 && resultOut <= 29.99) {
                    ImageOut.image = UIImage(named: "overweight")
                    displayOut.text = "You are Over Weight!"
                    displayOut.textColor = UIColor.orange
                } else if resultOut >= 30 {
                    ImageOut.image = UIImage(named: "obese")
                    displayOut.text = "You are Obese!"
                    displayOut.textColor = UIColor.red
                }
                
                if Switch_On {
                    ResultOut.text = String(format: "%.2f", resultInMetric)
                } else {
                    ResultOut.text = String(format: "%.2f", result)
                }
                
                self.HeightIn.text = ""
                self.WeightIn.text = ""
                self.inchesIN.text = ""
            } else {
                let alert = UIAlertController(title: "Error", message: "Please provide appropriate values.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self.HeightIn.text = ""
                    self.WeightIn.text = ""
                    self.inchesIN.text = ""
                }
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        }

        func validateTextField(textValue: String?) -> (Bool, Double) {
            if let goodNumber = textValue, 
                !goodNumber.isEmpty,
                let userNumber = Double(goodNumber),
                userNumber >= 0 {
                return (true, userNumber)
            } else {
                return (false, 0)
            }
        }

        func validateTextFieldinches(textValue: String?) -> (Bool, Double) {
            if let goodNumber = textValue,
                !goodNumber.isEmpty,
                let userNumber = Double(goodNumber),
                userNumber >= 0 {
                return (true, userNumber)
            } else {
                return (true, 0)
            }
        }
    
    func openDietBlog() {
        var site: String
        
        if let bmiValue = Double(ResultOut.text ?? "") {
            if bmiValue < 18.5 {
                site = "https://www.dietdesigns.ca/post/underweight-weight-gain-how-nutrition-counselling-can-help"
            } else if bmiValue >= 18.5 && bmiValue <= 24.99 {
                site = "https://www.nhs.uk/live-well/eat-well/how-to-eat-a-balanced-diet/eight-tips-for-healthy-eating/"
            } else if bmiValue >= 25 && bmiValue <= 29.99 {
                site = "https://drmitraray.com/40-at-41-a-guest-blog-about-weight-loss/"
            } else if bmiValue >= 30 {
                site = "https://www.webmd.com/obesity/ss/slideshow-obesity-weight-loss-tips"
            } else {
                site = ""
            }
            
            if let url = URL(string: site) {
                UIApplication.shared.open(url)
            }
        }
    }
}

