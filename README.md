# vrp_fishingjob
Made by Thomas discord@Thomas.#4655

Fishing job that replaces the current fisher job in the vrp framework

Please add the following to your items.lua file or it won't work
   ["high_tier_bait"] = {"Peeler Crab Bait", "Peeler Crab Bait",nil, 1},
   ["mid_tier_bait"] = {"Lugworm Bait", "Lugworm Bait",nil, 1},
   ["low_tier_bait"] = {"Normal Bait", "Normal Bait",nil, 1},
   ["old_boot"] = {"Old Boot", "Old Boot",nil, 1},
   ["bass_fish"] = {"Bass", "Bass fish",nil, 1},
   ["haddock_fish"] = {"Haddock", "Haddock fish",nil, 1},
   ["cod_fish"] = {"Cod", "Cod fish",nil, 1},
   ["carp_fish"] = {"Carp", "Carp fish",nil, 1},
   ["pouting_fish"] = {"Pouting", "Pouting fish",nil, 1},
   ["sole_fish"] = {"Sole", "Sole fish",nil, 1},
   ["black_bream_fish"] = {"Black Bream", "Black Bream fish",nil, 1},
   ["red_mullet_fish"] = {"Red Mullet", "Red Mullet fish",nil, 1},
   ["ling_fish"] = {"Ling", "Ling fish",nil, 1},
   ["catfish_fish"] = {"Catfish", "Catfish",nil, 1},
   ["wreckfish_fish"] = {"Wreckfish", "Wreckfish",nil, 1},
   ["angel_shark_fish"] = {"Angel Shark", "Angel Shark",nil, 1},
   ["red_scorpion_fish"] = {"Red Scorpion Fish", "Red Scorpion Fish",nil, 1}
   
Make sure to configure the prices that each category of fish sells for in the config. If you want to add more locations that you are able to fish at, get the coords and use the format i used in the "Config.Locations" table. As of right now, there is only "legal" fishing and not illegal, i plan to add in illegal when i have an idea on what to do for it.

There is 3 tiers of bait, both mid_tier_bait and high_tier_bait increase the chances of getting the rarest fish, high_tier_bait increasing it the most. There is now shop or way to get the bait in the script so you will have to add those 3 items to a shop.
