local tools = {}

function tools.reAddItemToPlayer(playerStack, itemName)
	if not playerStack.valid_for_read then
		playerStack.set_stack{name=itemName, count=1}
	elseif playerStack.name == itemName then
		playerStack.count = playerStack.count + 1
	end
end

return tools