function class(def, statics, base,bIsAttribute)
    -- Error if def argument missing or is not a table
    if not def or type(def) ~= 'table' then error("class definition missing or not a table") end
    if bIsAttribute then 
        table.merge(def,modifier_attribute_all_base)
    end
    -- Error if statics argument is not nil and not a table
    if statics and type(statics) ~= 'table' then error("statics parameter specified but not a table") end

    -- Error if base argument not nil and not a table created by this function.
    if base and (type(base) ~= 'table' or not isclass(base)) then error("base parameter specified but not a table created by class function") end

    -- Start with a table for this class.  This will be the metatable for
    -- all instances of this class and where all class methods and static properties
    -- will be kept.  Initially it has two slots, __class__ == true to indicate this
    -- table represents a class created by this function and __base__, which if not
    -- nil is a reference to a base class created by this function
    --
    local c = {__base__ = base}
    c.__class__ = c

    -- Local function that will be used to create an instance of the class
    -- when the class is called
    --
    local function create(class_tbl, ...)
        -- Create an instance initialized with per instance properties
        --
        local instanceObj = {}

        -- Shallow copy of any class instance property initializers into our copy
        --
        for i,v in pairs(c.__initprops__) do
            instanceObj[i] = v
        end

        -- __index for each instance is the class object
        --
        setmetatable(instanceObj, { __index = c })

        -- If constructor key is not nil then it is this class's constructor
        -- so call it with our arguments
        --
        if instanceObj.constructor then
            instanceObj:constructor(...)
        end

        -- Return new instance of the class
        --
        return instanceObj
    end


    -- Create a metatable for the class whose __index field is just the class
    -- This will be the metatable for each new instance of this class created.
    --
    local c_mt = { __call = create}
    if base then
        -- Redirect class metatable __index slot to base class if specified
        --
        c_mt.__index = base
    end

    -- If statics is specified, shallow copy of non-function slots to our class
    --
    if statics then
        for i,v in pairs(statics) do
            if type(v) ~= 'function' then
                -- Ignore functions in statics table as we only support
                -- static properties.
                --
                c[i] = v
            else
                -- Error if this happens?
                error("function definitions not supported in statics table")
            end
        end
    end

    -- Table for instance property initial values
    --
    c.__initprops__ = {}

    -- Copy base class slots first if any so they will get overlayed
    -- by class slots of the same key
    --
    if base then
        -- Copy instance property initializers from base class
        --
        for i,v in pairs(base.__initprops__) do
            c.__initprops__[i] = v
        end
    end

    -- Now copy slots from the definition passed in.  For functions,
    -- store shallow copy to our class table.  For anything not a
    -- function slot, shallow copy to c.__initprops__ table for use
    -- when a new object of this class is instantiated.
    --
    for i,v in pairs(def) do
        if type(v) ~= 'function' then
            c.__initprops__[i] = v
        else
            c[i] = v
        end
    end

    -- Define an__instanceof__ method to determine if an instance.
    -- was derived from the passed class.  Used to emulate Squirrel
    -- instanceof binary operator
    --
    c.__instanceof__ =  function(instanceObj, classObj)
                            local c = getclass(instanceObj)
                            while c do
                                if c == classObj then return true end
                                c = c.__base__
                            end
                            return false
                        end

    -- Define an __getclass__ method to emulate Squirrel 3 object.getclass()
    --
    c.__getclass__ =function(instanceObj)
                        -- class object is __class__ slot of instance object's metatable
                        --
                        local classObj = getmetatable(instanceObj).__index

                        -- Sanity check the metatable is really a class object
                        -- we created.  If so return it otherwise nil
                        --
                        if isclass(classObj) then
                            return classObj
                        else
                            return nil
                        end
                    end

    -- Define a __getbase__ method to emulate Squirrel 3 object.getbase()
    -- method.
    --
    c.__getbase__ = function(classObj)
                        -- Sanity check the metatable is really a class object
                        -- we created.  If so return it's __base__ property
                        -- otherwise nil
                        --
                        if isclass(classObj) then
                            -- base class, if any,  is stored in class __base__ slot
                            --
                            return classObj.__base__
                        else
                            return nil
                        end
                    end

    setmetatable(c, c_mt)
    return c
end