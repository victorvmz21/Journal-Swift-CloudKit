//
//  ViewController.swift
//  Journal
//
//  Created by Victor Monteiro on 6/29/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var entryTitleTexField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
   var entry: Entry? {
            didSet {
                loadViewIfNeeded()
                updateViews()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            entryTitleTexField.delegate = self
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
        
        @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
            
            guard let bodyText = entryBodyTextView.text, !bodyText.isEmpty,
                let titleText = entryTitleTexField.text, !titleText.isEmpty else { return }
            
            EntryController.shared.createEntryWith(title: titleText, body: bodyText) { (results) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        func updateViews() {
            if let entry = entry {
                entryTitleTexField.text = entry.title
                entryBodyTextView.text = entry.body
            }
        }
        
        @IBAction func clearButtonTapped(_ sender: UIButton) {
            
            entryTitleTexField.text = ""
            entryBodyTextView.text = ""
        }
    }

    extension EntryDetailViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            entryTitleTexField.resignFirstResponder()
        }
    }
