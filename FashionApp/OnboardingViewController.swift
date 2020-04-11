//
//  ViewController.swift
//  FashionApp
//
//  Created by Kevin Kho on 10/04/20.
//  Copyright © 2020 Kevin Kho. All rights reserved.
//

import UIKit

struct OnboardingItem {
    let title: String
    let detail: String
    let image: UIImage?
}

class OnboardingViewController: UIViewController {

    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageViews = [UIImageView]()
    
    private let items: [OnboardingItem] = [
        
        .init(title: "Edith Head", detail: "You can have anything you want in life if you dress for it", image: UIImage(named: "men-jacket")),
        .init(title: "Diane von Furstenberg", detail: "Style is something each of us already has, all we need to do is find it.", image: UIImage(named: "women-flower")),
        .init(title: "Alexander Wang", detail: "Anyone can get dressed up and glamorous, but it is how people dress in their days off that are the most intriguing.", image: UIImage(named: "men-white")),
        .init(title: "Vivienne Westwood", detail: "Fashion is very important. It is life-enhancing and, like everything that gives pleasure, it is worth doing well.", image: UIImage(named: "women-white")),
        .init(title: "Giorgio Armani", detail: "Elegance is not standing out, but being remembered", image: UIImage(named: "men-yellow"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        setupImageViews()
        exploreButton.isHidden = true
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = items.count
    }
    
    private func setupImageViews(){
        items.forEach{ item in
            let imageView = UIImageView(image: item.image)
            imageView.contentMode = .scaleAspectFill
            imageView.alpha = 0.0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            containerView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0 ),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
            imageViews.append(imageView)
        }
        imageViews.first?.alpha = 1.0
        containerView.bringSubviewToFront(collectionView)
    }
    
    @IBAction func exploreButtonTapped(_ sender: Any) {
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window{
            window.rootViewController = mainAppViewController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    private func showItem(at index: Int) {
        pageControl.currentPage = index
        if index == items.count - 1 {
            
            exploreButton.isHidden = false
        }
    }
    
    private func getCurrentIndex() -> Int {
        return Int(collectionView.contentOffset.x / collectionView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let x = scrollView.contentOffset.x
        let index = getCurrentIndex()
        let fadeInAlpha = (x - collectionViewWidth * CGFloat(index)) / collectionViewWidth
        let fadeOutAplfha = CGFloat(1 - fadeInAlpha)
        
        let canShow = (index < items.count - 1)
        guard canShow else {
            return
        }
        imageViews[index].alpha = fadeOutAplfha
        imageViews[index + 1].alpha = fadeInAlpha
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = getCurrentIndex()
        showItem(at: index)
    }
    
    var collectionViewWidth: CGFloat {
        return collectionView.frame.size.width
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! QuoteCollectionViewCell
        let item = items [indexPath.item]
        
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size // for full size layout screen
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // remove white space
    }
}

class QuoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(with item: OnboardingItem){
        titleLabel.text = item.title
        detailLabel.text = item.detail
    }
    
}
