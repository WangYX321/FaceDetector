//
//  ViewController.swift
//  FaceDetector
//
//  Created by wyx on 2018/7/15.
//  Copyright © 2018年 com.biggerlab. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    lazy var imagePicker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: 图片选择器
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        self.imageView.image  = image
        self.detectFace(originImage: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil   )
//       self.detectFace(originImage: self.imageView.image!)
    }
    
    func detectFace(originImage:UIImage) {
        let image = CIImage(cgImage: originImage.cgImage!)
        
        //MARK: 设置识别的参数，识别质量
        let param = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        //MARK: 创建人脸识别器
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: param)
        //MARK: 获取识别结果
        let detectResult = faceDetector?.features(in: image)
        
        //MARK: 获取原图尺寸
        let size = image.extent.size
        //MARK: 计算imageView与原图的尺寸比例
        let xValue = self.imageView.bounds.size.width / size.width
        let yValue = self.imageView.bounds.size.height / size.height
        
        let resultView = UIView(frame: self.imageView.bounds)
        self.imageView.addSubview(resultView)
        
        for item in detectResult! {
            let faceFeature = item as! CIFaceFeature
            let faceView = UIView(frame: CGRect(x: faceFeature.bounds.origin.x * xValue, y: faceFeature.bounds.origin.y * yValue, width: faceFeature.bounds.size.width * xValue, height: faceFeature.bounds.size.height * yValue))
            faceView.layer.borderColor = UIColor.blue.cgColor
            faceView.layer.borderWidth = 2
            resultView.addSubview(faceView)
        }
        
        resultView.transform = CGAffineTransform(scaleX: 1, y: -1)
        resultLabel.text = String(format: "识别人脸数：%i", (detectResult?.count)!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

