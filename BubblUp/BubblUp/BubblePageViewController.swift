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
    
   // var idea: PFObject!
    var ideas: [PFObject]!
    
    var index: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        let firstViewController = getViewControllerAtIndex(index)
        
        
        setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        
    }
    
  }

extension BubblePageViewController: UIPageViewControllerDataSource {
    
    func getViewControllerAtIndex(index: Int) -> OneBubbleViewController {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("BubbleController") as! OneBubbleViewController
        
        controller.idea = ideas[index]
        
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
    
}

