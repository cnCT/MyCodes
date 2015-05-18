
local EventProtocol = require("EventProtocol")
local ModelBase = Class("ModelBase",EventProtocol)
ModelBase.idkey = "id"
ModelBase.schema = {
    id = {"string"}
}
ModelBase.fields = {"id"}

function ModelBase:ctor(properties)
    -- CCLOG("I'm ModelBase")
    ModelBase.super.ctor(self)
    -- CCLOG(self.super == self.class.super)
    -- self:dispatchEvent({name = "start",  from = "none",    to = "idle" })
    -- self:fk()
end

function ModelBase:fk(properties)
    -- CCLOG("I'm ModelBase fk")
end

return ModelBase