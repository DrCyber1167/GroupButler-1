local function action(msg, blocks, ln)
    
    local questions = {
        'Can you make a command to delete <insert what you would like to delete here>?',
        'Can you add a function to kick/ban who writes a specific word?',
        'How do I promote the bot as a group Admin?',
        'What does the "wrong markdown" message mean?',
        'Why can\'t I global ban users?',
        'Why sometimes commands by username are sooo slow?',
        'How can I clone the bot? I\'m getting <insert error> error, I need help',
        'Why can\'t I contact you in private?',
        'Why am I warned by the bot to reply to someone, even if I\'ve replied to a message?',
        'Can you add <insert the language here> language?',
        'What does this bot store? Why can he access all the messages?',
        'Can you advertise my channel/bot in your channel/bot?',
        'How do I report a bug?',
        'How many groups does the bot administrate?',
        'What can the bot owner do?',
        'Some strings of my language are not updated. What can I do?',
        'Why this faq are not translated in the supported languages?',
        'Why this faq are not sent with an inline keyboard?',
        'Why the bot doesn\'t report something flagged with the @admin command to all the group admins?',
        'A bot is spamming, why the antiflood can\'t kick it?',
        'Would you like to collaborate to a project? Like a groups network?',
        'Where are you from?',
        'Can I move my group info to another group?',
        'Will you ever add other plugins not related to the group administration? Like something to search on google, to get a definition from UD..?',
        'Please add an anti-emoji system',
        'Can you make the "anti media" directly kick/ban instead of warn? Or can you make the number of warns configurable?',
        'Can you make something to block only Telegram links?',
    }
    
    local answer = {
        'The Bot Api doesn\'t offer a method to delete message, but the Bot Support said that this feature will arrive. You can read the conversation [here](https://telegram.me/GroupButler_ch/32)',
        'I\'ve received many requests about this feature, I\'m sorry but I think everyone could avoid the words check just by changing an "_E_ " with a "_3_ ", or in general every character can be replaced with any other character. This function will probably added when bots can delete messages, but is not 100% confirmed',
        'First, make sure your client is updated to the latest version.\n\n*Normal groups*: group info screen, click on "administrators", under the group name. Remove the check from "all the member are admins", and select the bot. Then save.\n\n*Supergroups*: from the group info screen, click on "administrators" (Telegram Desktop: under the group name, Android client: three dots menu in the upper right corner, iOS/Webogram: never tried), than on "new administrator" and search for the bot username, then select it and save.\n\nIf you are trying to promote the bot in a supergroup and you can\'t find the bot username, well, I really don\'t know how to solve this problem :)',
        'It means that the message can\'t be sent back to you, because of a wrong number of \\_ or \\* or other markdown symbols. More info [here](https://telegram.me/GroupButler_ch/46)',
        'Only a selected number of people can global ban users. If you believe that someone has done something worthy of a global ban, please make screenshots, get their user ID, and report in @werewolfsupport.',
        'Commands by username are so slower than commands by reply because a bot can\'t retrieve a user id from a username. I need to store a table of ids and usernames, then I have to search the username and get the related id. Each group has its own table of usernames, but if a username is not found locally, it is searched in the global one. So in this case the research could be a bit slow. Tables are updated on each message.',
        'All the instructions are in the github page [here](https://github.com//RememberTheAir). I won\'t give any kind of support in the installation/configuartion/manteinence of the bot. For four reasons: I\'m a noob, I have few time, the bot is easy to install and Lua is a very friendly language. If you need support, there are tons of bot development groups around Telegram. You can ask there, you could find me, and probably you will find a lot of more competent people than me.',
        'Because I get so many messages and I\'m very busy. You can still ask whatever you want at @werewolfsupport.',
        'This usually happens if you reply to a message of an user that contains the username of another bot. So the message can\'t be seen by Werewolf Enforcer.',
        'I can\'t, I know only my native language (_italian_ ) and my English, as you can see, it\'s not good.\nBut you can :) Translations are open to everyone: if you need the bot to talk in your native language, you are free to translate all (or only partially) the strings of the bot.\n To see how, send /help in the private chat with the bot, tap on "all commands", then on "admin", and then on "languages". There you will find all the instructions.',
        'The bot has the access to all the messages because it needs to see replied messages. Also, when a bot is promoted as admin, it has always access to all the messages, no matter of the settings of BotFather.\nAbout what the bot stores:\n- Description, rules, #extra commands, welcome message if customized\n- It stores the ID associated with its username of every user it find: this is needed for commands by username\n- It stores the number of messages sent by a user in a group and the number of commands used by a user\n\nMedia and messages are not stored by the bot, it\'s something it will never do.',
        '*No*. I don\'t care if you will return the favor or how many subscribers you channel has.\nI\'m saying this because I\'m tired to receive all this kind of requests.',
        'Go to @werewolfsupport.'
		'Maybe around 200.'
		'Well, not much, all the privileged functions are made for debugging purpose.\nThe most rilevant functions I can use: see the bot stats, query the database, broadcast to groups and users (even if I never do it, i find it annoiyng for users), send a message in a group/to an user, post in the selected channel with the bot, make the bot leave a chat, turn on the admin mode (the bot can\'t be added to new groups), migrate the group info to a new group, global ban an user, block an user (will be ignored by the bot). And some other useless things',
        'If you want to translate them, you can run "/strings [your language code]" to get the most updated file with all the translated and untranslated strings. The steps to follow are the same of a normal translation',
        'Because I\'m lazy :P',
        'Will arrive ;)',
        'Probably, they haven\'t started the bot yet. Bots can\'t write to an user if not started first',
        'Bots can\'t see the messages sent by other bots, so it\'s not possible to detect the spam from other bots',
        'No, sorry but I\'m not interested in ths kind of things. I don\'t want to associate the bot with small/big Telegram Networks or with other bots which do the same thing.',
        'I don\'t know :)'
		'Yes, yes you can. But you need to contact me with "!" command, and provide the ids of both the old and the new groups. And you need to be the creator of both the groups, or at leat creator of the old and admin of the new one.',
        'No, I\'m not going to add recreative things. I want to keep the bot focused on what is doing now, and less invasive as possible in the group chat.',
        'I\'m not going to add this dictatorial things. In my opinion, the bot already allows you to block everything could be source of spam or off-topic in a group, and for me it already feels like an Hitlerian weapon for a paranoid admin.',
        'This "media warns" system will change as soon as I have some time to make some tests. For now it will stay as it is. My idea is to allow Admins to choose how many warns are needed to kick someone for posting a forbidden media. I\'ll see',
        'No, the current system uses a nice field in the messages object given by the api that includes all the links in a message, I\'m not going to add other plugins with arranged triggers only for Telegram links. I\'m sorry :(',
        
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