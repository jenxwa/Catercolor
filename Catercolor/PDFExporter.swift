//
//  PDFExporter.swift
//  Catercolor
//
//  Created by Jennifer Warbeck on 11.07.25.
//

import SwiftUI
/*
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

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))

        do {
            try pdfRenderer.writePDF(to: url, withActions: { context in
                context.beginPage()
                view?.layer.render(in: context.cgContext)
            })
            print("PDF successfully written on iOS at \(url)")
        } catch {
            print("Could not create PDF file on iOS: \(error)")
        }
    }
}
 */
