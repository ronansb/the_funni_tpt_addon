local MGMT = elem.allocate("RO01", "MGMT")
elem.property(MGMT, "Hardness", 0)
elem.property(MGMT, "Collision", 0)
elem.property(MGMT, "Name", "MGMT")
elem.property(MGMT, "Color", 0xFFFFFF)
elem.property(MGMT, "Weight", 100)
elem.property(MGMT, "Description", "Magnetic Monopole Matter")


local function MGMT_update(i,x,y)
    sim.gravMap(x/4, y/4, math.random(-10,-1))
end


local function MGMT_graphics()
    mainr = math.random(0,255)
    maing = mainr
    mainb = mainr

    return 0,ren.PMODE_FLARE + ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
end

elem.property(MGMT, "Update", MGMT_update)
elem.property(MGMT, "Graphics", MGMT_graphics)


local NYDM = elem.allocate("RO01", "NYDM")
elem.property(NYDM, "Collision", 0)
elem.property(NYDM, "Name", "NYDM")
elem.property(NYDM, "Color", 0xC0C0C0)
elem.property(NYDM, "Weight", 100)
elem.property(NYDM, "Description", "Neodymium, Rusts on contact with Oxygen. Used with SPRK and IRON as a magnet.")

local function NYDM_update(i,x,y)
    life = sim.partProperty(i,"life")
    for j, nx, ny in sim.neighbours(x, y, 1, 1, elem.DEFAULT_PT_OXYG) do
        sim.partProperty(i,"life",life+2)
        sim.partKill(j)
    end
    for j, nx, ny in sim.neighbours(x, y, 1, 1, elem.DEFAULT_PT_IRON) do
        if life > 64 then
            sim.gravMap(nx/4, ny/4, -2)
        end
        if life < 64 then
            sim.gravMap(nx/4, ny/4, 2)
        end
    end
    if life > 128 then
       sim.partProperty(i,"life",128) 
    end
end

local function NYDM_graphics(i,mainr, maing, mainb)
    local life = sim.partProperty(i, "life")
    mainr = mainr+life
    mainb = mainr+life
    return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
end
elem.property(NYDM, "Update", NYDM_update)
elem.property(NYDM, "Graphics", NYDM_graphics)
