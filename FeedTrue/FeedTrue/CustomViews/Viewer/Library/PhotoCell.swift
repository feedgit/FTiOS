import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    static let Identifier = "PhotoCellIdentifier"

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill

        #if os(iOS)
            view.clipsToBounds = true
        #else
            view.clipsToBounds = false
            view.adjustsImageWhenAncestorFocused = true
        #endif

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .black
        self.addSubview(self.imageView)
        self.addSubview(self.videoIndicator)
        self.addSubview(self.moreLabel)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var videoIndicator: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "video-indicator")!
        view.isHidden = true
        view.contentMode = .center

        return view
    }()
    
    lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont(name: "Helvetica", size: 32)
        label.textColor = .white
        label.sizeToFit()
        label.textAlignment = .center
        return label
    } ()

    var photo: Photo? {
        didSet {
            guard let photo = self.photo else {
                self.imageView.image = nil
                return
            }

            self.videoIndicator.isHidden = photo.type == .image

            if let assetID = photo.assetID, let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil).firstObject, let image = Photo.thumbnail(for: asset) {
                self.imageView.image = image
            } else {
                self.imageView.image = photo.placeholder
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.videoIndicator.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.moreLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}
