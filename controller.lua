os.loadAPI("disk/remotecc")

local cc = {}
cc.host = "http://ccwebinterface.epizy.com/remote/remotecc.php"
cc.id 	= 1
cc.name = "Main_Base_Controller"

function toboolean(v)
    return (type(v) == "string" and v == "true") or (type(v) == "string" and tonumber(v) and tonumber(v)~=0) or (type(v) == "number" and v ~= 0) or (type(v) == "boolean" and v)
end

os.setComputerLabel(cc.name)
local connection = remotecc.connect(cc.host,cc.id,cc.name)
print("Connecting as "..os.getComputerLabel().." with id "..cc.id)

local categories = {"chat", "refinedstorage", "machines", "energy"}

local chatSubCategories = {"chat_global"}
local RSSubCategories = {"rs_inventory", "rs_autocrafting", "rs_io"}
local machinesSubCategories = {}
local energySubcategories = {"energy_storage", "energy_io"}

local selectedCategory = ""
local selectedSubCategory = ""

--Peripheals
local chatBox = peripheral.find("chatBox")

local sentConnectedMessage = false

while true do
	local data = connection:request() 	--Poll data from the host, 'data' table is the JSON that was on the host, it is converted into lua tables already
											--The JSON would look like this: {"on":1}
	--if toboolean(data.on) then 			--If the on field is set to 1/"true"/"1" then
	--	rs.setOutput("left",true)		--Set left rs to on
	--	
	--	local ret = {}
	--	ret.onOut = tonumber(rs.getOutput("right")) --Poll input
	--	connection:putTable(ret) 		--Send back input
	--	
		--NOTE: Sending any data back is not required
	--	connection:put("{\"also\":\"you can send direct json\"")
	--else --If off
	--	rs.setOutput("left",false)		--Set left rs to off
	--end

    if sentConnectedMessage == false then
        connection:put("{\"connected\": \"true\"")
        sentConnectedMessage = true
    end

    --Category Selection
    if data.category ~= nil then
        if data.category == categories[1] then
            selectedCategory = categories[1]
        elseif data.category == categories[2] then
            selectedCategory = categories[2]
        elseif data.category == categories[3] then
            selectedCategory = categories[3]
        elseif data.category == categories[4] then
            selectedCategory = categories[4]
        end
    end

    --Sub Category Selection
    if data.subCategory ~= nil then
        if selectedCategory == categories[1] then
            if data.subCategory == chatSubCategories[1] then
                selectedSubCategory = chatSubCategories[1]
            end
        elseif selectedCategory == categories[2] then
            if data.subCategory == RSSubCategories[1] then
                selectedSubCategory = RSSubCategories[1]
            elseif data.subCategory == RSSubCategories[2] then
                selectedSubCategory = RSSubCategories[2]
            elseif data.subCategory == RSSubCategories[3] then
                selectedSubCategory = RSSubCategories[3]
            end
        elseif selectedCategory == categories[3] then
            print("No Sub Categories for now")
        elseif selectedCategory == categories[4] then
            if data.subCategory == energySubcategories[1] then
                selectedSubCategory = energySubcategories[1]
            elseif data.subCategory == energySubcategories[2] then
                selectedSubCategory = energySubcategories[2]
            end
        end
    end

    --Chat Section
    if selectedCategory == categories[1] then
        if selectedSubCategory == chatSubCategories[1] then
            while true do
                event, username, message = os.pullEvent("chat")
                local messageRead = "\"".. username.. ": ".. message.. "\""
                connection:put("{\"receivedMessage\":".. messageRead.. "")
            end

            if data.action == "sendMessage" then
                sendGlobalMessage(data.sentMessage, "Diamantino Op")
            end
        end
    end

    --Refined Storage
    if selectedCategory == categories[2] then
        if selectedSubCategory == RSSubCategories[1] then
            
        end
    end

	sleep(1)
end

function sendGlobalMessage(message, sender)
    if chatBox == nil then error("chatBox not found") end

    chatBox.sendMessage(message, sender)
end