local function action(msg, blocks, ln)
    
    local questions = {
        "Where can I find the code of @werewolfbot?",
        "Where can I find the code of @werewolfbutler?",
        "Can I contribute to the bots?",
        "Where can I report bugs / suggest improvements / ask questions?",
    }
    
    local answer = {
        "You can find it on [GitHub](http://www.github.com/parabola949/Werewolf). Feel free to post issues for bugs / improvements, and to merge a pull request.",
        "You can find it on [GitHub](http://www.github.com/BladeZero/GroupButler). Feel free to post issues for bugs / improvements, and to merge a pull request.",
        "Yes! If you are a programmer, you can send a pull request on GitHub for [Werewolf Moderator](http://www.github.com/parabola949/Werewolf) or [Werewolf Enforcer](http://www.github.com/BladeZero/GroupButler).\nIf you are a translator, and you want to improve a language, or make a new one, ask in the [support group](http://telegram.me/werewolfsupport): we need language files to be uploaded on Telegram.",
        "You can freely go to the [support group](http://telegram.me/werewolfsupport) and ask everything you want. If you have a GitHub account, you can also post an issue for [Werewolf Moderator](http://www.github.com/parabola949/Werewolf) or [Werewolf Enforcer](http://www.github.com/BladeZero/GroupButler)."
    }
    
    local text
    
    if not blocks[2] then
        local i = 1
        text = '*All the available questions*. Type `/faq [question number]`  to get the anwer\n\n'
        for k,v in pairs(questions) do
            text = text..'*'..i..'* - `'..v..'`\n'
            i = i + 1
        end
        api.sendMessage(msg.from.id, text, true)
    end
    if blocks[2] then
        local n = tonumber(blocks[2])
        if n > #answer or n == 0 then
            api.sendMessage(msg.from.id, '_Number not valid_', true)
        else
            text = '*'..questions[n]..'*\n\n'..answer[n]
            api.sendMessage(msg.from.id, text, true)
        end
    end
end
    
return {
    action = action,
    triggers = {
        '^/(faq)$',
        '^/(faq) (%d%d?)',
    }
}