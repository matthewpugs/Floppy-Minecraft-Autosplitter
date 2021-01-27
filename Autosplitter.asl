state("not minecraft dont sue me pls")
{
	float height : "UnityPlayer.dll", 0x0131B0F8, 0xC, 0x12C, 0x50, 0x284, 0x8, 0x14, 0x64;
	int diamonds : "mono-2.0-bdwgc.dll", 0x003A0C60, 0xA8, 0xE78, 0x48, 0x1C, 0x18, 0x70, 0x28;
}

startup
{
	settings.Add("diamond%", false, "Check this if doing break diamond%, will stop timer (or split) upon recieving diamond");
}

init
{
	vars.hasBeenDown = false;
	vars.diamondsBeenSplit = false;
}

start
{
	//starts if at the build limit and you haven't been down below the build limit this run, erasing confusion with reaching build limit vs spawning there
	if(current.height == 129 && vars.hasBeenDown == false)
	{
		return true;
	}
	else if(current.height == 0)
	{
	//if you are at 0 then you are at the loading screen, and hasBeenDown needs to be false, or the run is already over so it does nothing
		vars.hasBeenDown = false;

	}
}

split
{
//this is so that it will know to not end the timer when you haven't been below the build limit, thus stopping the issue of the timer stopping right away. The != 0 is so on the main menu so it doesn't register as you having been down
	if(current.height <= 120 && vars.hasBeenDown == false && current.height != 0)
	{
		print("somehow got to height 120, please send this message to the creator in discord " + current.height.ToString());
		vars.hasBeenDown = true;
	}
	//will end timer when getting diamond if diamond% setting is checked, and makes sure to only split for diamonds once per run
	if(settings["diamond%"] && current.diamonds > 0 && vars.diamondsBeenSplit == false)
	{
		vars.diamondsBeenSplit = true;
		return true;
	}
//timer stops when at bedrock
	if(current.height <= 2)
		{
			return true;
		}
//timer stops if at the build limit
	else if(current.height >= 129 && vars.hasBeenDown == true)
		{
			return true;
		}
}

//won't actually reset the run, it's just to know when the timer's been ended so it can reset diamondsBeenSplit
reset
{
	vars.diamondsBeenSplit = false;
}
