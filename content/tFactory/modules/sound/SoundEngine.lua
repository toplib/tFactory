local SoundEngine = {
	ticksFromLastAmbient = 0,
	period = 20 * 60 * 5, -- 5 minutes
}

local Debug = require("Debug")

SoundEngine.ambients = {
	{
		id = "guitar",
		path = "music/guitar",
	},
	{
		id = "regular",
		path = "music/regular",
	},
}
SoundEngine.music_speaker = nil

function SoundEngine.playSound()
	if vc ~= nil and vc.is_client() then
		local ambient = SoundEngine.ambients[random.random(1, #SoundEngine.ambients)]
		Debug.log("INFO", "SoundEngine", "Playing ambient: " .. ambient.path .. ", id: " .. ambient.id)
		SoundEngine.music_speaker = audio.play_sound_2d(ambient.path, 0.5, 1, "music", false)
	end
end

function SoundEngine.tick()
	SoundEngine.ticksFromLastAmbient = SoundEngine.ticksFromLastAmbient + 1
	if SoundEngine.ticksFromLastAmbient > SoundEngine.period then
		SoundEngine.playSound()
		SoundEngine.ticksFromLastAmbient = 0
	end
end

function SoundEngine.onShutdown()
	audio.stop(SoundEngine.music_speaker)
end

return SoundEngine
