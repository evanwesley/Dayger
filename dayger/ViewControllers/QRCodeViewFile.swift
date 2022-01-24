//
//  QRCodeViewFile.swift
//  dayger
//
//  Created by Evan Wesley on 1/24/21.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeVIew : View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var url : String
    
    var body : some View{
        Image(uiImage: generateQRCodeImage(_url: url))
    }
    //Data will be turned fed into the func to create a QR Code Via "String"
    func generateQRCodeImage(_url :String ) -> UIImage {
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent){
                return UIImage(cgImage: qrCodeCGImage)
            }
            
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}

