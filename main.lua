
-- =========================================
-- PELICAN TOOL 0.3.1
-- Tactical Blue | Android / LÖVE
-- Responsive Interface
-- =========================================

local W, H = 1280, 800
local screenW, screenH = 1280, 800
local scaleFactor = 1
local offsetX, offsetY = 0, 0

local page = "HOME"
local fpsMonitor = true
local animations = true

local colors = {
    bg = {0.025, 0.045, 0.085},
    panel = {0.045, 0.075, 0.13},
    card = {0.065, 0.105, 0.18},
    blue = {0.05, 0.48, 1.0},
    cyan = {0.0, 0.8, 1.0},
    white = {0.92, 0.96, 1.0},
    muted = {0.48, 0.59, 0.72},
    green = {0.1, 0.85, 0.55}
}

local font, smallFont, titleFont
local buttons = {}

-- =========================================
-- INITIALIZATION
-- =========================================

function love.load()
    love.window.setTitle("PELICAN TOOL")
    love.graphics.setBackgroundColor(colors.bg)

    font = love.graphics.newFont(19)
    smallFont = love.graphics.newFont(14)
    titleFont = love.graphics.newFont(30)

    love.graphics.setFont(font)
end

-- =========================================
-- DRAW HELPERS
-- =========================================

local function setColor(color)
    love.graphics.setColor(color)
end

local function rectangle(x, y, w, h, color, radius)
    setColor(color)
    love.graphics.rectangle(
        "fill", x, y, w, h, radius or 12
    )
end

local function text(value, x, y, size, color)
    if size == "small" then
        love.graphics.setFont(smallFont)
    elseif size == "title" then
        love.graphics.setFont(titleFont)
    else
        love.graphics.setFont(font)
    end

    setColor(color or colors.white)
    love.graphics.print(tostring(value), x, y)
end

local function button(id, label, x, y, w, h, active)
    rectangle(
        x, y, w, h,
        active and colors.blue or colors.card,
        10
    )

    text(label, x + 17, y + 13, "normal", colors.white)

    buttons[#buttons + 1] = {
        id = id,
        x = x,
        y = y,
        w = w,
        h = h
    }
end

local function card(title, value, description, x, y, w)
    rectangle(x, y, w, 145, colors.card, 14)

    text(title, x + 20, y + 18, "small", colors.muted)
    text(value, x + 20, y + 48, "title", colors.white)
    text(description, x + 20, y + 105, "small", colors.muted)
end

-- =========================================
-- SIDEBAR
-- =========================================

local function drawSidebar()
    rectangle(0, 0, 245, H, colors.panel, 0)

    text("PELICAN", 30, 32, "normal", colors.cyan)
    text("TACTICAL BLUE", 30, 68, "small", colors.muted)

    rectangle(25, 110, 195, 2, colors.blue, 1)

    button("HOME", "⌂   HOME",
        22, 145, 200, 52, page == "HOME")

    button("MONITOR", "◉   MONITOR",
        22, 207, 200, 52, page == "MONITOR")

    button("SETTINGS", "⚙   SETTINGS",
        22, 269, 200, 52, page == "SETTINGS")

    button("ABOUT", "ⓘ   ABOUT",
        22, 331, 200, 52, page == "ABOUT")

    text("PELICAN TOOL v0.3.1",
        25, H - 60, "small", colors.muted)

    text("ANDROID COMPANION",
        25, H - 35, "small", colors.muted)
end

-- =========================================
-- HEADER
-- =========================================

local function drawHeader()
    text("CONTROL CENTER", 285, 38)
    text("Independent companion dashboard",
        285, 70, "small", colors.muted)

    rectangle(1040, 38, 190, 42, colors.card, 20)

    setColor(colors.green)
    love.graphics.circle("fill", 1062, 59, 6)

    text("SYSTEM ONLINE",
        1078, 48, "small", colors.green)
end

-- =========================================
-- HOME
-- =========================================

local function drawHome()
    text("Welcome back, Operator.", 285, 145)
    text("Your control panel is ready.",
        285, 178, "small", colors.muted)

    local fps = love.timer.getFPS()

    card("APPLICATION STATUS", "ACTIVE",
        "PELICAN TOOL running", 285, 235, 280)

    card("APPLICATION FPS", tostring(fps),
        "FPS of this dashboard", 585, 235, 280)

    card("DISPLAY RESOLUTION",
        screenW .. " x " .. screenH,
        "Current screen dimensions", 885, 235, 345)

    rectangle(285, 420, 945, 205, colors.panel, 14)

    text("QUICK INFORMATION",
        310, 445, "normal", colors.cyan)

    text("• Independent Android companion interface",
        310, 495, "small")

    text("• No modification of Free Fire or other games",
        310, 535, "small")

    text("• Performance readings refer to this application",
        310, 575, "small")
end

-- =========================================
-- MONITOR
-- =========================================

local function drawMonitor()
    text("SYSTEM MONITOR", 285, 145)
    text("Live readings from PELICAN TOOL.",
        285, 180, "small", colors.muted)

    local fps = love.timer.getFPS()

    card("APPLICATION FPS", tostring(fps),
        "Dashboard rendering rate", 285, 240, 280)

    card("SCREEN WIDTH", tostring(screenW),
        "Pixels", 585, 240, 280)

    card("SCREEN HEIGHT", tostring(screenH),
        "Pixels", 885, 240, 345)

    rectangle(285, 430, 945, 135, colors.panel, 14)

    text("MONITORING INFORMATION",
        310, 455, "normal", colors.cyan)

    text(
        fpsMonitor and "FPS monitoring: ENABLED"
        or "FPS monitoring: DISABLED",
        310, 505, "small", colors.white
    )
end

-- =========================================
-- SETTINGS
-- =========================================

local function drawSettings()
    text("SETTINGS", 285, 145)
    text("Customize the dashboard.",
        285, 180, "small", colors.muted)

    rectangle(285, 240, 945, 100, colors.card, 14)

    text("FPS MONITOR", 310, 260)
    text("Display application FPS readings",
        310, 294, "small", colors.muted)

    button("FPS", fpsMonitor and "ON" or "OFF",
        1080, 263, 120, 48, fpsMonitor)

    rectangle(285, 365, 945, 100, colors.card, 14)

    text("ANIMATIONS", 310, 385)
    text("Enable dashboard animations",
        310, 419, "small", colors.muted)

    button("ANIM", animations and "ON" or "OFF",
        1080, 388, 120, 48, animations)
end

-- =========================================
-- ABOUT
-- =========================================

local function drawAbout()
    text("ABOUT PELICAN TOOL", 285, 145)

    rectangle(285, 220, 945, 350, colors.panel, 14)

    text("PELICAN TOOL", 320, 255,
        "normal", colors.cyan)

    text("Version 0.3.1", 320, 305)

    text("Tactical Blue Interface",
        320, 345, "small", colors.muted)

    text("An independent companion application for Android.",
        320, 410, "small")

    text("Designed for system information and dashboard controls.",
        320, 450, "small")

    text("Developed with LÖVE and Lua.",
        320, 490, "small")
end

-- =========================================
-- RESPONSIVE SCREEN
-- =========================================

function love.draw()
    buttons = {}

    screenW = love.graphics.getWidth()
    screenH = love.graphics.getHeight()

    scaleFactor = math.min(
        screenW / W,
        screenH / H
    )

    offsetX = (screenW - W * scaleFactor) / 2
    offsetY = (screenH - H * scaleFactor) / 2

    love.graphics.push()

    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scaleFactor, scaleFactor)

    rectangle(0, 0, W, H, colors.bg, 0)

    drawSidebar()
    drawHeader()

    if page == "HOME" then
        drawHome()
    elseif page == "MONITOR" then
        drawMonitor()
    elseif page == "SETTINGS" then
        drawSettings()
    elseif page == "ABOUT" then
        drawAbout()
    end

    love.graphics.pop()
end

-- =========================================
-- INPUT HANDLING
-- =========================================

local function handleClick(x, y)
    for _, b in ipairs(buttons) do
        if x >= b.x and x <= b.x + b.w
        and y >= b.y and y <= b.y + b.h then

            if b.id == "HOME"
            or b.id == "MONITOR"
            or b.id == "SETTINGS"
            or b.id == "ABOUT" then

                page = b.id

            elseif b.id == "FPS" then
                fpsMonitor = not fpsMonitor

            elseif b.id == "ANIM" then
                animations = not animations
            end

            return
        end
    end
end

local function convertCoordinates(x, y)
    return
        (x - offsetX) / scaleFactor,
        (y - offsetY) / scaleFactor
end

function love.mousepressed(x, y, buttonType)
    if buttonType == 1 then
        local px, py = convertCoordinates(x, y)
        handleClick(px, py)
    end
end

function love.touchpressed(id, x, y)
    local px = x * screenW
    local py = y * screenH

    px, py = convertCoordinates(px, py)

    handleClick(px, py)
end

-- =========================================
-- KEYBOARD
-- =========================================

function love.keypressed(key)
    if key == "escape" then
        if page ~= "HOME" then
            page = "HOME"
        else
            love.event.quit()
        end
    end
end
