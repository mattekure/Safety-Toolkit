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

OOB_MSGTYPE_SUBMITCARD = "submitcard";

function onInit()
	Interface.onDesktopInit = onDesktopInit;
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_SUBMITCARD, handleSubmitCard);
	local nNode = DB.findNode("safetyTopics");
	local mNode = "";
	local lNode = "";
	if nNode == nil then
		nNode = DB.createNode("safetyTopics");
		for _,v in pairs(topicList) do
			local mNode = DB.createChild(nNode)
			local lNode = mNode.createChild("name", "string");
			lNode.setValue(v);
			lNode = mNode.createChild("responseNum", "number");
			lNode.setValue(0);
		end		
	end
		
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
-- ---------------------------------------------------------------
-- OnDesktopInit - Called right after Desktop is fully loaded	--
-- ---------------------------------------------------------------
function onDesktopInit()
	RegisterStackShortcut();
end
-- ---------------------------------------------------------------
-- RegisterStackShortcut - Registers a stack shortcut button	--
-- ---------------------------------------------------------------
function RegisterStackShortcut()
	if DesktopManager ~= nil then
		DesktopManager.registerStackShortcut2("safety_toolkit", "safety_toolkit_down", "safetyToolkit_tooltip", "SafetyToolkitWindow", "", true);
		DesktopManager.registerStackShortcut2("triggers", "triggers_down", "triggersSurvey", "triggersWindow", "", true);

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
	unAck[c] = 1;
	local wWindow = Interface.openWindow("SafetyToolkitWindow", "");
	wWindow.close();
	Interface.openWindow("SafetyToolkitWindow", "");
end