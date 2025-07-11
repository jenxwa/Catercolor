//
//  PDFExporter.swift
//  Catercolor
//
//  Created by Jennifer Warbeck on 11.07.25.
//

import SwiftUI

extension View {
    func exportAsPDF(to url: URL) {
        #if os(iOS)
        exportAsPDF_iOS(to: url)
        #elseif os(macOS)
        exportAsPDF_macOS(to: url)
        #endif
    }

    // iOS implementation
    private func exportAsPDF_iOS(to url: URL) {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        // Add to a window to make sure layout is resolved
        let window = UIWindow(frame: CGRect(origin: .zero, size: targetSize))
        window.rootViewController = controller
        window.makeKeyAndVisible()
        window.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let image = renderer.image { ctx in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))

        do {
            try pdfRenderer.writePDF(to: url, withActions: { context in
                context.beginPage()
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            })
            print("✅ PDF successfully written at \(url)")
        } catch {
            print("❌ Could not create PDF file: \(error)")
        }
    }

}
