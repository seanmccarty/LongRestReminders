local fSavedRestFunction = null;

function onInit()
	--    Debug.chat(Session.IsHost);
	if Session.IsHost then
		Comm.registerSlashHandler("LRR", processLRR);
		Comm.registerSlashHandler("LRRlongrest", processLRRLongRest);
		Comm.registerSlashHandler("LRRshortrest", processLRRShortRest);
	end

	--Override the original function
	fSavedRestFunction = CombatManager.rest;
	CombatManager.rest = rest;
end

---Sends usage instructions to the Chat
function processLRR()
	ChatManager.SystemMessage(
	"Create a Story entry named LRR. This Story entry will be displayed to the GM when a Long Rest is taken.\rUse /LRRshortrest and /LRRlongrest commands to pin the Rest functions to the hotkey bar. (Type them in chat and then drag it to the hotkey bar.)");
end

---Triggers a long rest using the same sequence as the Combat Manager
function processLRRLongRest()
	-- ChatManager.Message(Interface.getString("ct_message_restlong"), true);
	CombatManager.rest(true);
end

---Triggers a short rest using the same sequence as the Combat Manager
function processLRRShortRest()
	-- ChatManager.Message(Interface.getString("ct_message_rest"), true);
	CombatManager.rest(false);
end

---Calls the original rest function and then runs additional code
---@param bLong boolean true if it is a long rest
function rest(bLong)
	fSavedRestFunction(bLong);

	if bLong and Session.IsHost then
		--Look for and open the node that has a name of LRR
		for _, vNode in pairs(DB.getChildren("reference.refmanualdata")) do
			if DB.getValue(vNode, "name", "") == "LRR" then
				Interface.openWindow("referencemanualpage", vNode);
				return;
			end
		end
		--If this section is reached, it means the story entry was not found
		local msg = { text = "Story entry named LRR not found" };
		Comm.addChatMessage(msg);
	end
end
