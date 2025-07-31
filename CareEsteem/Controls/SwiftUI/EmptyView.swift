//
//  EmptyView.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 20/06/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "animation_fadeSmooth", withExtension: "gif")!)//44 Notes
            Image("noData")
//            imageView.image = UIImage.sd_image(withGIFData: imageData)
            Text("There is no infomation recored in the visit note").background(Color.yellow)
        }
    }
}

#Preview {
    EmptyView()
}
