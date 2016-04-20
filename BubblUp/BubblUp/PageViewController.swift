//
//  PageViewController.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/20/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    var pageViewController : UIPageViewController?
    var index:Int!
    var ideas: [PFObject]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = self
        
        let firstViewController = getViewControllerAtIndex(index)
        
        
        self.pageViewController!.setViewControllers([firstViewController],
            direction: .Forward,
            animated: true,
            completion: nil)
        
      //  let startingViewController: PageContentViewController = self.viewControllerAtIndex(0)!
      //  let viewControllers: NSArray = [startingViewController]
      //  self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    func getViewControllerAtIndex(index: Int) -> OneBubbleViewController {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("BubbleController") as! OneBubbleViewController
        print("index\(index)")
        controller.idea = ideas[index]
        
        return controller
        
    }
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            let previousIndex = index - 1
            if(previousIndex < 0){
                index = ideas.count - 1
                return nil
            }
            index = previousIndex
            return getViewControllerAtIndex(previousIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            let nextIndex = index + 1
            if(nextIndex >= ideas.count){
                index = 0
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
