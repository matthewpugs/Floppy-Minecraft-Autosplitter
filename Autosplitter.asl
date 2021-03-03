state("not minecraft dont sue me pls")
{
	float height : "UnityPlayer.dll", 0x0131B0F8, 0x284, 0x8, 0x14, 0x64;
	int diamonds : "mono-2.0-bdwgc.dll", 0x003A0C60, 0xA8, 0xE78, 0x48, 0x1C, 0x18, 0x70, 0x28;
	int health : "mono-2.0-bdwgc.dll", 0x003A9FBC, 0x4A8, 0xF6C;
	int zombiesKilled : "UnityPlayer.dll", 0x012B40B8, 0x128, 0x1C, 0x140;
}

startup
{
	settings.Add("diamond%", false, "will stop timer (or split) upon recieving diamond");
	settings.Add("Kill 1 Zombie", false, "will split after killing 1 zombie");
	settings.Add("Kill 10 Zombies", false, "will split after killing 10 zombies");

}

init
{
	vars.hasBeenDown = false;
	vars.diamondsBeenSplit = false;
	vars.zombiesBeenKilled = false;
}

start
{
//resets the counter for if a zombies been killed
	if(settings["Kill 1 Zombie"] && vars.zombiesBeenKilled == true)
	{
		vars.zombiesBeenKilled = false;
	}
	//starts if at the build limit and you haven't been down below the build limit this run, erasing confusion with reaching build limit vs spawning there
	if(current.height == 129 && vars.hasBeenDown == false)
	{
		return true;
	}
	else if(current.height == 0 ^ current.height == 1)
	{
	//if you are at 0 or 1 then you are at the loading screen, and hasBeenDown needs to be false, or the run is already over so it does nothing
		vars.hasBeenDown = false;

	}
}

split
{
//this is so that it will know to not end the timer when you haven't been below the build limit, thus stopping the issue of the timer stopping right away. The != 0 and !=1 is so on the main menu so it doesn't register as you having been down
	if(current.height <= 128 && vars.hasBeenDown == false && current.height != 0 && current.height != 1)
	{
		print("hasBeenDown changed height = " + current.height.ToString());
		vars.hasBeenDown = true;
	}
	//will end timer when getting diamond if diamond% setting is checked, and makes sure to only split for diamonds once per run
	if(settings["diamond%"] && current.diamonds > 0 && vars.diamondsBeenSplit == false)
	{
		vars.diamondsBeenSplit = true;
		return true;
	}
	//there's a weird glitch where sometimes the height randomly jumps when spawning in, and it was stopping the timer thinking the character reached bedrock
	//so it has to make sure you were a reasonable distance from bedrock before reaching it
	//the old height != current height is because sometimes when it jumps, both old height and current height == 0
//timer stops when at bedrock
	if(current.height <= 2 && old.height - current.height < 4 && old.height != current.height)
		{
			print("current height: " + current.height.ToString());
			print("old height: " + old.height.ToString());
			return true;
		}
//timer stops if at the build limit
	else if(current.height >= 129 && vars.hasBeenDown == true)
		{
			return true;
		}
//timer stops if dead
	else if(current.health == 0)
		{
			return true;
		}
//vars.zombiesBeenKilled is needed because if it wasn't there it would split for all the splits as soon as you kill a zombie. it resets when the timer is reset
	else if(current.zombiesKilled == 1 && vars.zombiesBeenKilled == false && settings["Kill 1 Zombie"])
	{
		vars.zombiesBeenKilled = true;
		return true;
	}
	else if(current.zombiesKilled == 10 && settings["Kill 10 Zombies"])
	{
		return true;
	}
}

//won't actually reset the run, it's just to know when the timer's been ended so it can reset diamondsBeenSplit
reset
{
	vars.diamondsBeenSplit = false;
}
