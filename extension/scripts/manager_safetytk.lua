local unAck = {
	x=0,
	n=0,
	o=0
}

local topicList = {
	"Child abuse",
	"Clowns",
	"Drugs",
	"High elevations (flight, high-rises, etc)",
	"Sexual abuse",
	"Slime and pus",
	"Spiders",
	"Suicide",
	"Torture",
	"Violence against animals",
	"Violence against children"
}
local aCoreDesktopStack = {
	["safetyToolkit"] = 
	{
		{
			icon="safety_toolkit",
			icon_down="safety_toolkit_down",
			tooltipres="safetyToolkit_tooltip",
			class="SafetyToolkitWindow",
		}
	}
};

OOB_MSGTYPE_SUBMITCARD = "submitcard";

function onInit()
	if MenuManager then
		MenuManager.addMenuItem("SafetyToolkitWindow", "", "safetyToolkit_tooltip", "Safety TK");
	else
		DesktopManager.registerStackShortcuts(aCoreDesktopStack["safetyToolkit"]);
	end

	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_SUBMITCARD, handleSubmitCard);
	
		
end

function getTopics()
	local nNode = DB.findNode("safetyTopics");
	local sTopicList = "";
	local tNode = "";
	if nNode ~= nil then
		nodeTable = nNode.getChildren();
		for i,v in pairs(nodeTable) do
			tNode = v.getChild("name");
			sTopicList = sTopicList .. tNode.getValue() .. string.char(10);
		end
	end 
	return StringManager.trim(sTopicList);
end

function setTopics(sTopics)
	local nNode = DB.findNode("safetyTopics");
	local mNode = "";
	local lNode = "";
	local nTable = nNode.getChildren()
	for i,v in pairs(nTable) do
		DB.deleteNode(v);
	end
	
	for sTopic in string.gmatch(sTopics, '([^\n]+)') do
		sTopic = StringManager.trim(sTopic);
		local mNode = nNode.createChild()
		local lNode = mNode.createChild("name", "string");
		lNode.setValue(sTopic);
		lNode = mNode.createChild("responseNum", "number");
		lNode.setValue(0);
		
	end

end

function cardButtonPressed(sButton)
	local c = sButton:sub(-1);
	Debug.chat("Button: "..c);
end

function cardSubmit(sCard)
	if not sCard then
		return;
	end
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_SUBMITCARD;
	msgOOB.sCard = sCard;
	Comm.deliverOOBMessage(msgOOB, "");
end

function cardAck(sCard)
	local c = sCard:sub(-1);
	unAck[c] = 0;
	local messagedata = {};
	messagedata.text = "Safety Toolkit: "..string.upper(c).." card acknowledged by the GM";
	messagedata.font = "safetytoolkitfont";
	Comm.deliverChatMessage(messagedata);
	local wWindow = Interface.openWindow("SafetyToolkitWindow", "");
	wWindow.close();
	Interface.openWindow("SafetyToolkitWindow", "");
end

function checkUnack(sName)
	local c = sName:sub(-1);
	return unAck[c];
end

function handleSubmitCard(msgOOB)
	local sCard = msgOOB.sCard;
	local c = sCard:sub(-1);
	unAck[c] = unAck[c]+1;
	local wWindow = Interface.openWindow("SafetyToolkitWindow", "");
	wWindow.close();
	Interface.openWindow("SafetyToolkitWindow", "");
	if(c == 'o') then
		local userList = User.getActiveUsers();
		local numUsers = table.getn(userList);
		
		local messagedata = {};
		messagedata.text  = "Safety Toolkit: "..string.upper(c).." card submitted by "..unAck[c].." of "..numUsers.." players connected.";
		messagedata.font = "safetytoolkitfont";
		Comm.deliverChatMessage(messagedata);
	end
end