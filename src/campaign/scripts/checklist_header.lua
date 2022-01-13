-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bUpdating = false;

function onInit()
	getDatabaseNode().onObserverUpdate = onObserverUpdated;
	onObserverUpdated();
	update();
end

function onObserverUpdated()
	local node = getDatabaseNode();
	
	local sOwner = node.getOwner();
	if sOwner then
		owner.setValue(sOwner);
	else
		owner.setValue("");
	end
	
end



function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	name.setReadOnly(bReadOnly);
end
