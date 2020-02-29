local unAck = {
	x=0,
	n=0,
	o=0
}

OOB_MSGTYPE_SUBMITCARD = "submitcard";

function onInit()
		Interface.onDesktopInit = onDesktopInit;
		OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_SUBMITCARD, handleSubmitCard);
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