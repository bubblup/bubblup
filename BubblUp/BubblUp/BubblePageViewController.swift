//
//  BubblePageViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/19/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse


class BubblePageViewController: UIPageViewController {
    
    weak var controller:BubbleCollectionViewController?
   // var idea: PFObject!
    var ideas: [PFObject]!
    
    var index: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        let firstViewController = getViewControllerAtIndex(index)
        
        setupPageControl()

        setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        
    }
    private func setupPageControl() {
        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
        
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        pageControl.pageIndicatorTintColor = UIColor.greenColor()
        pageControl.backgroundColor = UIColor.orangeColor()
    }
    
    
  }

extension BubblePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func getViewControllerAtIndex(index: Int) -> OneBubbleViewController {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("BubbleController") as! OneBubbleViewController
       
        controller.idea = ideas[index]
        controller.controller = self.controller
        return controller
        
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            let previousIndex = index - 1
            if(previousIndex < 0){
                return nil
            }
            index = previousIndex
            return getViewControllerAtIndex(previousIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            let nextIndex = index + 1
            if(nextIndex >= ideas.count){
                return nil
            }
            index = nextIndex
            return getViewControllerAtIndex(nextIndex)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        print("count\(ideas.count)")
        return ideas.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return index
    }

}

