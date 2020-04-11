//
//  CoreDataClass.swift
//  CoreDataPhotos
//
//  Created by Jasmine Tan on 4/10/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
public class Entry: NSManagedObject {
    var image: UIImage? {
        get {
            if let imageData = photo as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                photo = convertImage(image: image)
            }
        }
    }
    
    func convertImage(image: UIImage) -> NSData? {
        if (image.imageOrientation == .up) {
            return image.pngData() as NSData?
        }
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image.pngData() as NSData?
        }
        return unwrappedCopy.pngData() as NSData?
    }
    
    convenience init?(title:String, journal:String?, notes:String?, image: UIImage?) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext, !title.isEmpty else {
            return nil
        }
        
        self.init(entity: Entry.entity(), insertInto: managedContext)
        self.title = title
        self.journal = journal
        self.notes = notes
        
        if let image = image {
            self.photo = convertImage(image: image)
        }
    }
    
    func update(title:String, journal:String?, notes:String?, image : UIImage?) {
        self.title = title
        self.journal = journal
        self.notes = notes
        
        if let image = image {
            self.photo = convertImage(image: image)
        }
        
    }
}

