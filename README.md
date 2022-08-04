# Steam OS Setup

When I pre ordered the steam deck I thought it would be a fun toy for playing a
few platformer games. The reality is, I've canceled my planned laptop upgrade,
because the hardware is as fast as my current i7 8550U laptop at 1/2 the power,
not even talking about the GPU, which is mighty impressive. The screen is just
fine for me, and it docks just great with an existing usbc dock I had laying
around. With a kickstand case, and a bluetooth keyboard and mouse, it's
replaced my development laptop (for getting work done), and my phone (for
consuming content and wasting time), and my gaming PC (for every game except
DCS).

So what remains is to make some kind of peace with SteamOS, or install
something else. This, again, is something I thought would be basically
impossible, it's a game console I thought, they are going to make it really
difficult to get anything done on it. Well, the reality is, Steam OS is quite
close to a bog standard arch install. It's true, it updates as some kind of
"image", I'm not actually sure how that works, except that they've said it
isn't ostree. In any case, it's really just a quick shell script, and then it's
back to being arch. Arch, being arch, it's a little strange to begin with
coming from debian, but I've made peace with that.

So after far too many words, this is the script that I run after each Steam OS
update to fix it up so I can build stuff on it. Refinements, comments, and
rants are welcome.

