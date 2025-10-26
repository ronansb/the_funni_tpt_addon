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
    for j, nx, ny in sim.neighbours(x, y, 1, 1) do
        neighType = sim.partProperty(j, "type")
        if neighType == elem.DEFAULT_PT_OXYG then
            sim.partProperty(i,"life",life+1)
            sim.partKill(j)
        end
    end

end
elem.property(NYDM, "Update", NDYM_update)
