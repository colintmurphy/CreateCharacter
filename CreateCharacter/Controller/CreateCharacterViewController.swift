//
//  ViewController.swift
//  CreateCharacter
//
//  Created by Colin Murphy on 9/23/20.
//

import UIKit

class CreateCharacterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dogStepper: UIStepper!
    @IBOutlet weak var dogCountLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    let datePicker = UIDatePicker()
    let heightPicker = UIPickerView()
    let heightArr = [ ["Feet", "3", "4", "5", "6", "7"],
                      ["Inches", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"] ]
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupStepperAndSlider()
        self.setupPickers()
        self.setupTextViews()
        self.setupTextFields()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: - Method Actions
    
    @objc func dateChange() {
        
        let cal = Calendar.current
        let components = cal.dateComponents([.day, .month, .year] , from: self.datePicker.date)
        
        if let month = components.month,
           let day = components.day,
           let year = components.year {
            self.birthdayTextField.text = "\(month)/\(day)/\(year)"
        }
    }
    
    @objc func numberOfDogsChanged() {
        self.dogCountLabel.text = "Count \(Int(self.dogStepper.value))"
    }
    
    @objc func weightChanged() {
        self.weightLabel.text = "\(Int(self.weightSlider.value)) lbs"
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCountries" {
            if let vc = segue.destination as? CountryViewController {
                vc.delegate = self
            }
        }
    }
    
    // MARK: - Setup
    
    func setupStepperAndSlider() {
        
        self.weightSlider.value = 200
        self.weightSlider.addTarget(self, action: #selector(weightChanged), for: .valueChanged)
        self.dogStepper.addTarget(self, action: #selector(numberOfDogsChanged), for: .valueChanged)
    }
    
    func setupPickers() {
        
        self.birthdayTextField.inputView = datePicker
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        self.heightTextField.inputView = heightPicker
        self.heightPicker.dataSource = self
        self.heightPicker.delegate = self
    }
    
    func setupTextViews() {
        
        self.bioTextView.layer.cornerRadius = 10
        self.bioTextView.layer.borderWidth = 1.0
        self.bioTextView.layer.borderColor  = UIColor.systemGray.cgColor
    }
    
    func setupTextFields() {
        
        self.nameTextField.layer.cornerRadius = 10
        self.nameTextField.layer.borderWidth = 1.0
        self.nameTextField.layer.borderColor  = UIColor.systemGray.cgColor
    }
    
    // MARK: - Keyboard
    
    @objc func dismissKeyboard() {
        
        self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: 0, bottom: 0, right: 0)
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.bioTextView.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
                
                // If textView is hidden by keyboard, scroll it so it's visible
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardSize.height
                
                if let textViewRect = self.bioTextView.superview?.superview?.frame {
                    self.scrollView.scrollRectToVisible(textViewRect, animated:true)
                }
            }
        }
    }
}

// MARK: - CountryDelegate

extension CreateCharacterViewController: CountryDelegate {
    
    func returnCountryValue(with country: String) {
        
        self.countryButton.setTitleColor(.label, for: .normal)
        self.countryButton.setTitle(country, for: .normal)
    }
}

// MARK: - UIPickerViewDelegate

extension CreateCharacterViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.heightArr[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let feet = self.heightArr[0][pickerView.selectedRow(inComponent: 0)]
        let inches = self.heightArr[1][pickerView.selectedRow(inComponent: 1)]
        
        if feet == "Feet" || inches == "Inches" {
            self.heightTextField.text = ""
        } else {
            self.heightTextField.text = feet + "ft " + inches + "in"
        }
    }
}

// MARK: - UIPickerViewDataSource

extension CreateCharacterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.heightArr[component].count
    }
}
