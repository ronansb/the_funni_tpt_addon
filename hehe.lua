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
elem.property(NYDM, "Description", "Neodymium, Rusts on contact with Oxygen. Used with IRON as a magnet. (Oxidized is negative-magnet)")

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

    for j, nx, ny in sim.neighbours(x, y, 1, 1, elem.DEFAULT_PT_TTAN) do
        if life > 64 then
            sim.gravMap(nx/4, ny/4, -6)
        end
        if life < 64 then
            sim.gravMap(nx/4, ny/4, 6)
        end
    end
    if life > 128 then
       sim.partProperty(i,"life",128) 
    end
end

local function NYDM_graphics(i,mainr, maing, mainb)
    local life = sim.partProperty(i, "life")
    local temp = sim.partProperty(i, "temp")
    mainr = mainr+life
    mainb = mainr+life
    if temp > 120+273.15 and temp < 350+273.15 and temp < 1200+273.15 then
        if math.random(0,((350+273.15)-temp)/2) == 1 then
            mainr = mainr + (350+273.15)-(900+273.15)/2
            maing = maing + (350+273.15)-(900+273.15)/8
            mainb = mainb + ((350+273.15)-(900+273.15))/10
            return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
        else
            return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
        end
    elseif temp > 350+273.15 and temp < 1200+273.15 then
        mainr = mainr + temp-(900+273.15)/2
        maing = maing + temp-(900+273.15)/8
        mainb = mainb + (temp-(900+273.15))/10
        return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
    elseif temp > 1200+273.15 then
        mainr = mainr + temp-(900+273.15)/5
        maing = maing + temp-(900+273.15)/5
        mainb = mainb + (temp-(900+273.15))/10
        return 0,ren.PMODE_FLAT+ren.PMODE_GLOW,255,mainr,maing,mainb,0,0,0,0
    else
        return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
    end
end
elem.property(NYDM, "Update", NYDM_update)
elem.property(NYDM, "Graphics", NYDM_graphics)
elem.property(NYDM, "HighTemperature", 2900+273.15)
elem.property(NYDM, "HighTemperatureTransition", elem.DEFAULT_PT_LAVA)
elem.property(NYDM, "Properties", elem.TYPE_SOLID)


local YES = elem.allocate("RO01", "YES")
elem.property(YES, "Collision", 0)
elem.property(YES, "Name", "YES")
elem.property(YES, "Color", 0xFFFFFF)
elem.property(YES, "Weight", 100)
elem.property(YES, "Description", "Y E S (turns into whatever it touches)")

local function YES_update(i,x,y)
    life = sim.partProperty(i,"life")
    for j, nx, ny in sim.neighbours(x, y, 1, 1) do
        if sim.partProperty(j,"type") ~= YES then
            sim.partProperty(i,"type",sim.partProperty(j,"type"))
            sim.partProperty(i,"ctype",sim.partProperty(j,"ctype"))
            sim.partProperty(i,"tmp",sim.partProperty(j,"tmp"))
            sim.partProperty(i,"tmp2",sim.partProperty(j,"tmp2"))
            sim.partProperty(i,"tmp3",sim.partProperty(j,"tmp3"))
            sim.partProperty(i,"tmp4",sim.partProperty(j,"tmp4"))
            sim.partProperty(i,"temp",sim.partProperty(j,"temp"))
            sim.partProperty(i,"life",sim.partProperty(j,"life"))
        end
    end
end

elem.property(YES, "Update", YES_update)

local PLST = elem.allocate("RO01", "PLST")
elem.property(PLST, "Collision", 0)
elem.property(PLST, "Name", "PLST")
elem.property(PLST, "Hardness", 0)
elem.property(PLST, "Color", 0xFFFFFF)
elem.property(PLST, "Weight", 100)
elem.property(PLST, "Description", "Plastic, Set Color with tmp, tmp2, and tmp3 for R,G,B")
elem.property(PLST,"HighTemperature",199+273.15)

local function PLST_update(i,x,y)
    if sim.partProperty(i,"life") == 0 then
        sim.partProperty(i,"life",math.random(1,25))
    end
end

local function PLST_graphics(i)
    life = sim.partProperty(i,"life")
    mainr = sim.partProperty(i,"tmp")-(life/3)
    maing = sim.partProperty(i,"tmp2")-(life/3)
    mainb = sim.partProperty(i,"tmp3")-(life/3)
    if mainr < 0 then
        mainr = 0
    end
    if maing < 0 then
        maing = 0
    end
    if mainb < 0 then
        mainb = 0
    end
    return 0,ren.PMODE_FLAT,255,mainr,maing,mainb,0,0,0,0
end

elem.property(PLST, "Update", PLST_update)
elem.property(PLST, "Graphics", PLST_graphics)
elem.property(PLST, "Properties", elem.TYPE_SOLID)

local MPLS = elem.allocate("RO01","MPLS")
elem.property(MPLS,"Name","MPLS")
elem.property(MPLS,"Description","Melted Plastic")
elem.property(MPLS,"Properties",elem.TYPE_LIQUID)
elem.property(MPLS,"Flammable",1)
elem.property(MPLS,"Falldown",2)
elem.property(MPLS,"Graphics",PLST_graphics)
elem.property(MPLS,"Advection",1)
elem.property(MPLS,"Gravity",0.04)
elem.property(MPLS,"Update", PLST_update)
elem.property(MPLS,"Temperature",250+273.15)
elem.property(MPLS,"LowTemperature",200+273.15)
elem.property(MPLS,"LowTemperatureTransition",PLST)
elem.property(PLST,"HighTemperatureTransition",MPLS)
