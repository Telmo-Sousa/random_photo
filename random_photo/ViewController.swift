import UIKit
import Photos

class ViewController: UIViewController {

    let clickMeLabel = UILabel()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        clickMeLabel.text = "Click me"
        clickMeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        clickMeLabel.textColor = .white
        clickMeLabel.textAlignment = .center

        clickMeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickMeLabel)
        NSLayoutConstraint.activate([
            clickMeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clickMeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap() {
        clickMeLabel.isHidden = true

        imageView.image = nil

        let randomColor = UIColor(
            red: CGFloat(arc4random_uniform(256)) / 255.0,
            green: CGFloat(arc4random_uniform(256)) / 255.0,
            blue: CGFloat(arc4random_uniform(256)) / 255.0,
            alpha: 1.0
        )
        view.backgroundColor = randomColor

        fetchPhotos()
    }

    func fetchPhotos() {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(with: options)

        guard fetchResult.count > 0 else {
            print("No favorite photos found.")
            return
        }

        let randomIndex = Int(arc4random_uniform(UInt32(fetchResult.count)))
        let randomPhotoAsset = fetchResult.object(at: randomIndex)
        
        PHImageManager.default().requestImage(for: randomPhotoAsset,
                                              targetSize: CGSize(width: 300, height: 300),
                                              contentMode: .aspectFill,
                                              options: nil) { [weak self] (image, _) in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
