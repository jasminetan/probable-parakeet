//
//  EntryViewController.swift
//  CoreDataPhotos
//
//  Created by Jasmine Tan on 4/10/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var entry : Entry?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var photoNameLabel: UITextField!
    
    @IBOutlet weak var journalTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var entryImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if let entry = entry{
            photoNameLabel.text = entry.title
            notesTextField.text = entry.notes ?? ""
            journalTextField.text = entry.journal ?? ""
            entryImageView.image = entry.image ?? nil
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func folderButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alertController = UIAlertController(title: "No Camera", message: "The devide does not have a camera", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        } else {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            entryImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
         if entry == nil{
             let name = photoNameLabel.text ?? "No title"
             let notes = notesTextField.text ?? ""
             let journal = journalTextField.text ?? ""
             let photo = entryImageView.image
            entry = Entry(title: name, journal: journal, notes: notes, image: photo)
         }
         else{
            entry?.update(title: photoNameLabel.text ?? "No title" , journal: journalTextField.text, notes: notesTextField.text, image: entryImageView.image)
        }


            if let entry = entry {
                do {
                    let managedContext = entry.managedObjectContext
                    try managedContext?.save()
                } catch {
                    print("The entry could not be saved.")
                }
                
            } else {
                print("The entry could not be created.")
            }
            
            // Return to list of Notes.
            navigationController?.popViewController(animated: true)
    }
}
