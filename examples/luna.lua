-- Luna Adapted: a little warmth on a quiet page.
local Moon = {}
Moon.__index = Moon

function Moon.new(name, phase)
  return setmetatable({
    name = name or "Luna",
    phase = phase or 0.75,
    visible = true,
  }, Moon)
end

function Moon:greet()
  if self.visible then
    return string.format("Hello, %s", self.name)
  end
  return "See you at moonrise"
end

local luna = Moon.new("Crescent", 0.25)
print(luna:greet())
