//
//  ContentView.swift
//  TOCropSwiftUI
//
//  Created by Abdulloh Bahromjonov on 30/04/24.
//

import SwiftUI
import UIKit
import CropViewController

struct ContentView: View {
    @State private var showImageCropper = false
    @State private var uiImage: UIImage? = UIImage(named: "image")
    
    var body: some View {
        if showImageCropper {
            ImageCropper(image: self.$uiImage, visible: self.$showImageCropper)
                .ignoresSafeArea()
        } else {
            Image(uiImage: uiImage!)
                .resizable()
                .overlay {
                    ZStack {
                        Color.black.opacity(0.5)
                        
                        Image(uiImage: uiImage!)
                            .resizable()
                            .clipShape(Circle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    withAnimation {
                        showImageCropper = true
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var visible: Bool
    
    class Coordinator: NSObject, CropViewControllerDelegate{
        let parent: ImageCropper
        
        init(_ parent: ImageCropper){
            self.parent = parent
        }

        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            withAnimation{
                parent.visible = false
            }
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            withAnimation {
                parent.visible = false
            }
            parent.image = image
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let img = self.image ?? UIImage()
        let vc = CropViewController(croppingStyle: .circular, image: img)
        vc.aspectRatioLockEnabled = true
        vc.rotateButtonsHidden = true
        vc.aspectRatioPickerButtonHidden = true
        vc.resetButtonHidden = true
        vc.doneButtonColor = .systemBlue
        vc.cancelButtonColor = .systemRed
        vc.delegate = context.coordinator
        return vc
    }
}
