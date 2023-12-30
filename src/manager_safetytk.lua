local unAck = {
    x = {},
    n = {},
    o = {},
}

local OOB_MSGTYPE_SUBMITCARD = "submitcard";

function onTabletopInit()
    local tButton =
    {
        sIcon = "safety_toolkit",
        tooltipres = "safetyToolkit_tooltip",
        class = "SafetyToolkitWindow",
    };

    DesktopManager.registerSidebarToolButton(tButton, false);

    OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_SUBMITCARD, handleSubmitCard);
end

function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function cardSubmit(sCard)
    if not sCard then
        return;
    end
    local msgOOB = {};
    msgOOB.type = OOB_MSGTYPE_SUBMITCARD;
    msgOOB.sCard = sCard:sub(-1);
    msgOOB.sUser = User.getUsername();
    Comm.deliverOOBMessage(msgOOB, "");
end

function cardAck(sCard)
    unAck[sCard:sub(-1)] = {};
    local messagedata = {};
    messagedata.text = "Safety Toolkit: " .. string.upper(sCard:sub(-1)) .. " card acknowledged by the GM";
    messagedata.font = "systemfont";
    Comm.deliverChatMessage(messagedata);
    local wWindow = Interface.openWindow("SafetyToolkitWindow", "");
    wWindow.close();
    Interface.openWindow("SafetyToolkitWindow", "");
end

function checkUnack(sName)
    local c = sName:sub(-1);
    return tablelength(unAck[c]);
end

function handleSubmitCard(msgOOB)
    local sCard = msgOOB.sCard;
    local sUser = msgOOB.sUser;
    addToSet(unAck[sCard], sUser);
    local wWindow = Interface.openWindow("SafetyToolkitWindow", "");
    wWindow.close();
    Interface.openWindow("SafetyToolkitWindow", "");
    local userList = User.getActiveUsers();
    local numUsers = #userList;
    local messagedata = {};
    messagedata.font = "systemfont";
    if (sCard == 'o') then
        messagedata.text = "Safety Toolkit: " ..
            string.upper(sCard) .. " card submitted by " ..
            tablelength(unAck[sCard]) .. " of " .. numUsers .. " players connected.";
    else
        messagedata.text = "Safety Toolkit: " .. string.upper(sCard) .. " card submitted.";
    end
    Comm.deliverChatMessage(messagedata, sUser);
end
