state("not minecraft dont sue me pls")
{
	float height : "UnityPlayer.dll", 0x0131B0F8, 0x284, 0x8, 0x14, 0x64;
	int health : "mono-2.0-bdwgc.dll", 0x003A9FBC, 0x4A8, 0xF6C;
	int zombiesKilled : "UnityPlayer.dll", 0x012B40B8, 0x128, 0x1C, 0x140;
	int itemEntitiesOnGround : "UnityPlayer.dll", 0x0125AA40, 0x14, 0x38, 0x4E0;
	int diamondEntitiesOnGround : "UnityPlayer.dll", 0x0131B0F8, 0xC, 0x150, 0x50, 0x34, 0x0, 0xC;
	int dirt : "UnityPlayer.dll", 0x012934A0, 0x38C, 0x1C, 0x1C, 0x18, 0x70, 0x18;
}

startup
{
	settings.Add("Reach Bedrock", false, "Reach Bedrock%, stop timer at bedrock level");
	settings.Add("Kill Zombie", false, "Kill Zombie%");
		settings.Add("Kill 1 Zombie", false, "Kill 1 Zombie%, will split after killing 1 zombie", "Kill Zombie");
		settings.Add("Kill 10 Zombies", false, "Kill 10 Zombies%, will split after killing 10 zombies", "Kill Zombie");
	settings.Add("Break Diamond", false, "Break Diamond%, will stop timer upon breaking diamond");
	settings.Add("Cut Tree", false, "Cut Tree%, will split after a wood block/any other block is mined (that drops an item)");
	settings.Add("Build Limit", false, "Build Limit%, splits after reaching build limit");
		settings.Add("57 Dirt", false, "splits after getting 57 dirt", "Build Limit");
	settings.Add("Die", false, "Die%, splits after you die");

}

init
{
	vars.hasBeenDown = false;
	vars.diamondsBeenSplit = false;
	vars.zombiesBeenKilled = false;
	vars.treesBeenCut = false;
}

start
{
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
	if(settings["Build Limit"])
	{
		//this is so that it will know to not end the timer when you haven't been below the build limit, thus stopping the issue of the timer stopping right away. The != 0 and !=1 is so on the main menu so it doesn't register as you having been down
		if(current.height <= 128 && vars.hasBeenDown == false && current.height != 0 && current.height != 1)
		{
			print("hasBeenDown changed height = " + current.height.ToString());
			vars.hasBeenDown = true;
		}
		//timer stops if at the build limit
		else if(current.height >= 129 && vars.hasBeenDown == true)
		{
			return true;
		}
		else if(settings["57 Dirt"] && current.dirt == 57)
		{
			return true;
		}
	}

	else if(settings["Break Diamond"])
	{
		//will end timer when breaking diamond if break diamond setting is checked, and makes sure to only split for diamonds once per run
		//diamondEntitiesOnGround starts at 1 for some reason
		if(current.diamondEntitiesOnGround == 2 && vars.diamondsBeenSplit == false)
		{
			vars.diamondsBeenSplit = true;
			return true;
		}
	}

	else if(settings["Reach Bedrock"])
	{
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
	}

	else if(settings["Die"])
	{
		//timer stops if dead
		if(current.health == 0)
		{
			return true;
		}
	}

	else if(settings["Kill Zombie"])
	{
		//vars.zombiesBeenKilled is needed because if it wasn't there it would split for all the splits as soon as you kill a zombie. it resets when the timer is reset
		if(current.zombiesKilled == 1 && vars.zombiesBeenKilled == false && settings["Kill 1 Zombie"])
		{
			vars.zombiesBeenKilled = true;
			return true;
		}
		else if(current.zombiesKilled == 10 && settings["Kill 10 Zombies"])
		{
			return true;
		}
	}

	else if(settings["Cut Tree"])
	{
		//the item entities counter starts at 6 for some reason, 7 will be after cutting one wood
		if(current.itemEntitiesOnGround == 7 && vars.treesBeenCut == false)
		{
			vars.treesBeenCut = true;
			return true;
		}
	}
}

//won't actually reset the run, it's just to know when the timer's been ended so it can reset some variables
reset
{
	vars.diamondsBeenSplit = false;
	vars.zombiesBeenKilled = false;
	vars.treesBeenCut = false;
}

