//
//  HunterImageVC.swift
//  Hunter
//
//  Created by Zubin Manak on 23/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Kingfisher
import Toast_Swift

class HunterImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate   {

    @IBOutlet weak var titleLab: UILabel!
    var imgUrl = String()
    @IBOutlet weak var ingV: UIImageView!
    var titleStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLab.text = titleStr
        let url = URL(string: imgUrl)
        self.ingV.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveImg(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(ingV.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    
     
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            self.view.makeToast("Save error")
        } else {
            self.view.makeToast("Your image has been saved to your photos.")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
