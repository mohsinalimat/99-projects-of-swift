import UIKit

class DrawingBoard: UIView {
    
    var lineWidth: CGFloat = 2
    var pathColor: UIColor = .black
    
    //MARK: 保存线条
    var lines = [Line]()
    var beganPoint: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            beganPoint = touch.location(in: self)
        }
        
        super.touchesBegan(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let movedPoint = touch.location(in: self)
            
            // 创建直线
            lines.append(Line(start: beganPoint, end: movedPoint, color: pathColor))
            // 移动后的点 = 下一次移动开始点
            beganPoint = movedPoint
        }
        
        super.touchesBegan(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let endPoint = touch.location(in: self)
            if endPoint == beganPoint {
                // 创建直线
                let tmp = CGPoint(x: beganPoint.x, y: beganPoint.y + lineWidth)
                lines.append(Line(start: beganPoint, end: tmp, color: pathColor))
            }
        }
        
        super.touchesEnded(touches, with: event)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        // 设置中心十字 - 好像有的蠢
        let bounds = self.bounds
        context?.beginPath()
        context?.move(to: CGPoint(x: bounds.maxX/2, y: 0))
        context?.addLine(to: CGPoint(x: bounds.maxX/2, y: bounds.maxY))
        
        context?.move(to: CGPoint(x: 0, y: bounds.maxY/2))
        context?.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY/2))
        
        context?.setStrokeColor(UIColor.gray.cgColor)
        context?.setLineWidth(0.2)
        context?.strokePath()

        // 重新内容
        for line in lines {
            context?.beginPath()
            context?.move(to: line.startPoint)
            context?.addLine(to: line.endPoint)
            context?.setStrokeColor(line.color.cgColor)
            context?.setLineWidth(lineWidth)
            context?.strokePath()
        }
    }
    
    // MARK: 清空画板
    func clearBoard() {
        self.lines = []
        self.setNeedsDisplay()
    }
    
    // MARK: 保存图片
    func getImage() -> UIImage {
        let size = self.bounds.size
        
        UIGraphicsBeginImageContext(size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
