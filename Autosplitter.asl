state("not minecraft dont sue me pls")
{
	float height : "UnityPlayer.dll", 0x0131B0F8, 0xC, 0x12C, 0x50, 0x284, 0x8, 0x14, 0x64;
}

init
{
	vars.hasBeenDown = false;
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
	if(current.height <= 128 && vars.hasBeenDown == false && current.height != 0)
	{
		vars.hasBeenDown = true;
	}
//timer stops when at bedrock
	if(current.height <= 2)
		{
			vars.hasBeenDown = false;
			return true;
		}
//timer stops if at the build limit
	else if(current.height >= 129 && vars.hasBeenDown == true)
		{
			vars.hasBeenDown = false;
			return true;
		}
}