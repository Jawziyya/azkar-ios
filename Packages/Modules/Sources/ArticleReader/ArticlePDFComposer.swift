import UIKit
import PDFKit
import Entities
import MarkdownKit

/**
 Provides API to create PDF document from Article object. Including image cover, title and other optional data.
 */
public final class ArticlePDFComposer {
    
    public struct Footer {
        let image: UIImage
        let text: String
        let link: URL?
        
        public init(image: UIImage, text: String, link: URL?) {
            self.image = image
            self.text = text
            self.link = link
        }
    }
    
    let article: Article
    let titleFont: UIFont
    let textFont: UIFont
    let pageSize: CGSize
    let pageMargins: UIEdgeInsets
    let footer: Footer?
    
    public init(
        article: Article,
        titleFont: UIFont,
        textFont: UIFont,
        pageSize: CGSize = CGSize(width: 595, height: 842),
        pageMargins: UIEdgeInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60),
        footer: Footer?
    ) {
        self.article = article
        self.titleFont = titleFont
        self.textFont = textFont
        self.pageSize = pageSize
        self.pageMargins = pageMargins
        self.footer = footer
    }
    
    public func renderPDF() throws -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextTitle as String: article.title,
            kCGPDFContextAuthor as String: "Al Jawziyya",
            kCGPDFContextCreator as String: "Azkar App.",
        ]
        
        let markdownParser = MarkdownParser(
            font: textFont,
            color: UIColor.black
        )
        markdownParser.header.font = titleFont
        let attributedString = markdownParser.parse(article.text)
                
        let printFormatter = UISimpleTextPrintFormatter(attributedText: attributedString)
        let printPageRenderer = PrintPageRenderer(
            pageSize: pageSize,
            pageMargins: pageMargins,
            simpleTextPrintFormatter: printFormatter,
            footer: footer
        )
        return try printPageRenderer.renderPDF(format: format)
    }
    
}

private final class PrintPageRenderer: UIPrintPageRenderer {
    
    let pageSize: CGSize
    let pageMargins: UIEdgeInsets
    let simpleTextPrintFormatter: UISimpleTextPrintFormatter
    let footer: ArticlePDFComposer.Footer?
    
    init(
        pageSize: CGSize,
        pageMargins: UIEdgeInsets,
        simpleTextPrintFormatter: UISimpleTextPrintFormatter,
        footer: ArticlePDFComposer.Footer?
    ) {
        self.pageSize = pageSize
        self.pageMargins = pageMargins
        self.simpleTextPrintFormatter = simpleTextPrintFormatter
        self.footer = footer
        super.init()
        if footer != nil {
            footerHeight = 75
        }
        addPrintFormatter(simpleTextPrintFormatter, startingAtPageAt: 0)
    }
    
    public override var paperRect: CGRect {
        return CGRect(origin: .zero, size: pageSize)
    }
    
    public override var printableRect: CGRect {
        return paperRect.inset(by: pageMargins)
    }
    
    func renderPDF(format: UIGraphicsPDFRendererFormat) throws -> Data {
        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
        let graphicsRenderer = UIGraphicsPDFRenderer(bounds: paperRect, format: format)
        return graphicsRenderer.pdfData { context in
            for pageIndex in 0..<numberOfPages {
                let bounds = context.pdfContextBounds
                context.beginPage()
                if let link = footer?.link {
                    context.setURL(link, for: CGRect(x: 0, y: 0, width: bounds.width, height: footerHeight))
                }
                drawPage(at: pageIndex, in: bounds)
            }
        }
    }
    
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        guard let footer else { return }
        let alpha: CGFloat = 0.5
        let imageSide: CGFloat = 30
        let imageRect = CGRect(
            x: footerRect.midX - imageSide/2,
            y: footerRect.minY,
            width: imageSide,
            height: imageSide
        )
        
        let textSize: CGFloat = 12
        let systemFont = UIFont.systemFont(ofSize: textSize, weight: .regular)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: textSize)
        } else {
            font = systemFont
        }
        let text = NSAttributedString(
            string: footer.text,
            attributes: [
                .font: font, 
                .foregroundColor: UIColor.gray.withAlphaComponent(alpha),
            ]
        )
        let textWidth = text.boundingRect(with: footerRect.size, context: nil).width
        text.draw(at: CGPoint(x: footerRect.midX - textWidth/2, y: imageRect.maxY + 5))
        footer.image.draw(
            in: imageRect,
            blendMode: .clear,
            alpha: alpha
        )
    }
    
}
