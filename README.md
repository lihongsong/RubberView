# RubberView
Erasure your Image if you set.

# How to use it.

Use it on the StoryBoard

  `@IBOutlet weak var rubberView: RubberView!`
  
Or Init it 

  `let rect = CGRect(x: 0, y: 0, width: 100, height: 100)`
  `let rubber = RubberView(frame: rect)`

Set Source Image 
  
  `rubber.sourceImage = UIImage(named: "AAA.jpg")`
  
Set Clear Radius

  `rubber.clearRadius = 10` // default is 5
