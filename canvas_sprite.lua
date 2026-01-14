-- CanvasSprite: a Sprite that draws from a Love2D canvas
CanvasSprite = Sprite:extend()

-- init: create a canvas for the sprite
function CanvasSprite:init(X, Y, W, H, canvasW, canvasH, canvasScale)
  self.canvasW = canvasW or 71
  self.canvasH = canvasH or 95
  self.canvasScale = canvasScale or 1
  self.canvas = love.graphics.newCanvas(self.canvasW * self.canvasScale, self.canvasH * self.canvasScale)
  Sprite.init(self, X, Y, W, H, { name = "dummy", px = self.canvasW * self.canvasScale, py = self.canvasH * self.canvasScale, image = self.canvas }, { x = 0, y = 0 })
  self.canvas:renderTo(love.graphics.clear, 0, 0, 0, 0)
end