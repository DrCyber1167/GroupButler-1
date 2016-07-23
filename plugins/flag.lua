local function get_mods_id(chat_id)
    local res = api.getChatAdministrators(chat_id)
    if not res then return false end
    local ids = {}
    for i,admin in pairs(res.result) do
        table.insert(ids, admin.user.id)
    end
    return ids
end

local function is_report_blocked(msg)
	print('0')
    local hash = 'chat:'..msg.chat.id..':reportblocked'
	print("01111")
    return db:sismember(hash, msg.from.id)
end

local function send_to_admin(mods, chat, msg_id, reporter, is_by_reply, chat_title, msg)
    for i=1,#mods do
		print('1001'..i)
        api.forwardMessage(mods[i], chat, msg_id)
		print('101'..i)
        if is_by_reply then 
			res, code = api.sendMessage(mods[i], reporter..'\n\n'..chat_title)
			print('102'..i)
		else
			res, code = api.sendMessage(mods[i], reporter..'\n\n'..chat_title)
			print('103'..i)
		end
		print('1002'..i)
    end
	local hash = 'flagged:'..msg.chat.id..':'..msg_id
	local timer = os.date('%d %B %Y At %X')
	local sentMsgID = res
	local test = code
	print('1')
	--db:hset(hash, 'MessageID', sentMsgID)
	print(test)
	print(sentMsgID)
	print('2')
	db:hset(hash, 'Solved', 0)
	print('3')
	db:hset(hash, 'Created', timer)
end

local action = function(msg, blocks, ln)
    
    if msg.chat.type == 'private' then return end
    
    local hash = 'chat:'..msg.chat.id..':reportblocked'
    if blocks[1] == 'admin' then
        --return nil if 'report' is locked, if is a mod or if the user is blocked from using @admin
        if is_locked(msg, 'Report') or is_mod(msg) or is_report_blocked(msg) then
            return 
        end
        if not blocks[2] and not msg.reply then
            api.sendReply(msg, lang[ln].flag.no_input)
        else
            if is_report_blocked(msg) then
                return
            end
            if msg.reply and ((tonumber(msg.reply.from.id) == tonumber(bot.id)) --[[or is_mod(msg.reply)]]) then
                return
            end
            local mods = get_mods_id(msg.chat.id)
            if not mods then
                api.sendReply(msg, lang[ln].bonus.adminlist_admin_required, true)
            end
            local msg_id = msg.message_id
            local is_by_reply = false
            if msg.reply then
                is_by_reply = true
                msg_id = msg.reply.message_id
            end
            local reporter = msg.from.first_name
            if msg.from.username then reporter = reporter..' (@'..msg.from.username..')' end
            send_to_admin(mods, msg.chat.id, msg_id, reporter, is_by_reply, msg.chat.title, msg)
            api.sendReply(msg, lang[ln].flag.reported)
        end
    end
    if blocks[1] == 'report' then
        if is_mod(msg) then
            if not msg.reply then
                api.sendReply(msg, lang[ln].flag.no_reply)
            else
                if blocks[2] == 'off' then
                    local result = db:sadd(hash, msg.reply.from.id)
                    if result == 1 then
                        api.sendReply(msg, lang[ln].flag.blocked)
                    elseif result == 0 then
                        api.sendReply(msg, lang[ln].flag.already_blocked)
                    end
                elseif blocks[2] == 'on' then
                    local result = db:srem(hash, msg.reply.from.id)
                    if result == 1 then
                        api.sendReply(msg, lang[ln].flag.unblocked)
                    elseif result == 0 then
                        api.sendReply(msg, lang[ln].flag.already_unblocked)
                    end
                end
            end
        end
	end
		
	if blocks[1] == 'solved' then 
		if is_mod(msg) or config.admin.superAdmins[msg.from.id] then
			hash12 = 'flagged:'..msg.chat.id..':'..msg_id
			isSolved = db:hget(hash12, 'Solved')
			if isSolved == '0' then
				local solvedBy = msg.from.first_name
				if msg.from.username then solvedBy = solvedBy..' (@'..msg.from.username..')' end
				local solvedAt = os.date('%d %B %Y At %X')
				messageID = db:hget(hash12, 'MessageID')
				
				db:hset(hash12, 'SolvedAt', solvedAt)
				db:hset(hash12, 'solvedBy', solvedBy)
				db:hset(hash12, 'Solved', 1)
				
				local mods = get_mods_id(msg.chat.id)
				
				local text = 'This has been solved by: '..solvedBy..'\n'..solvedAt..'\n('..msg.chat.title..')'
				for i=1,#mods do
					api.editMessageText(mods[i], messageID, text, false, false)
				end 
			else
				local solvedTime = db:hget(hash12, 'SolvedAt')
				local solvedBy = db:hget(hash12, 'solvedBy')
				api.sendReply(msg, 'This message was solved at '..solvedTime..' by '..solvedBy)
			end
		else
			api.sendReply(msg, lang[ln].not_mod)
		end
	end	
end

return {
	action = action,
	triggers = {
	    '^@(admin)$',
	    '^@(admin) (.*)$',
	    '^/(report) (on)$',
	    '^/(report) (off)$',
		'^/(resolved)',
    }
}