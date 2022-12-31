#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_score;

init()
{
    if ( isdefined(mapname) && mapname == "zm_prison" )
	{
		if ( GetDvar("customMap") != "showers" && GetDvar("customMap") != "docks" && GetDvar("customMap") != "cellblock" && GetDvar("customMap") != "rooftop" && GetDvar("customMap") != "vanilla" )
		{
			SetDvar( "customMap", "docks" );
		}
		precacheshader("menu_mp_lobby_icon_film");
	    precacheshader( "menu_mp_lobby_icon_customgamemode" );
	    precacheshader( "waypoint_revive" );
	    precacheshader( "killiconheadshot" );
	    precacheshader( "menu_lobby_icon_twitter" );
	    precacheshader( "hud_grenadeicon" ); 
	    precacheshader( "menu_mp_weapons_1911" );
	    precacheshader( "menu_mp_lobby_icon_screenshot" );
	    precacheshader( "damage_feedback" ); 
        precacheshader( "zombies_rank_1" );
	    precacheshader( "zombies_rank_3" );
	    precacheshader( "zombies_rank_2" );
	    precacheshader( "zombies_rank_4" );
	    precacheshader( "menu_mp_weapons_xm8" );
        precacheshader( "faction_cdc" ); 
	    precacheshader( "menu_mp_weapons_hamr" ); 
	    precacheshader( "zombies_rank_5" );
	    precacheshader( "hud_icon_sticky_grenade" );
        precacheshader( "specialty_instakill_zombies" );
	    precacheshader( "menu_mp_weapons_1911" );
		precacheshader( "hud_icon_colt" );
        precachemodel("p6_zm_buildable_sq_meteor");
	    precachemodel( "collision_player_wall_512x512x10" );
	    precachemodel( "collision_physics_512x512x10" );
	    precachemodel( "t5_foliage_tree_burnt03" );
	    precachemodel( "p_rus_door_roller" );
	    precachemodel( "ch_tombstone1" );
	    precachemodel( "collision_geo_256x256x10_standard" );
	    precachemodel( "zombie_vending_tombstone_on" );
	    precachemodel( "zombie_vending_revive_on" );
	    precachemodel( "zombie_vending_sleight_on" );
	    precachemodel( "zombie_vending_doubletap2_on" );
	    precachemodel( "zombie_pickup_perk_bottle" );
	    precachemodel( "zm_collision_perks1" );
	    precachemodel( "zombie_teddybear" );
	    precachemodel( "p6_zm_screecher_hole" );
	    precachemodel( "p_cub_door01_wood_fullsize" );
	    precachemodel( "veh_t6_civ_microbus_dead" );
	    precachemodel( "p_rus_door_white_window_plain_left" );
		init_custom_map();
		level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
		level.zombie_last_stand = ::LastStand;
		level.custom_vending_precaching = ::default_vending_precaching;
		register_player_damage_callback( ::playerdamagelastcheck );
		level thread onPlayerConnect();
        //level thread night_mode();
	}
	
}



night_mode()
{
	level waittill( "connected", player );
	player setclientdvar( "r_dof_enable", 0 );
	player setclientdvar( "r_lodBiasRigid", -1000 );
	player setclientdvar( "r_lodBiasSkinned", -1000 );
	player setclientdvar( "r_enablePlayerShadow", 1 );
	player setclientdvar( "r_skyTransition", 1 );
	player setclientdvar( "sm_sunquality", 2 );
	player setclientdvar( "vc_fbm", "0 0 0 0" );
	player setclientdvar( "vc_fsm", "1 1 1 1" );
	player setclientdvar( "r_filmUseTweaks", 1 );
	player setclientdvar( "r_bloomTweaks", 1 );
	player setclientdvar( "r_exposureTweak", 1 );
	player setclientdvar( "vc_rgbh", "0.1 0 0.3 0" );
    player setclientdvar( "vc_yl", "0 0 0.25 0" );
	player setclientdvar( "vc_yh", "0.02 0 0.1 0" );
	player setclientdvar( "vc_rgbl", "0.02 0 0.1 0" );
	player setclientdvar( "r_exposureValue", 3.9 );
	player setclientdvar( "r_lightTweakSunLight", 1 );
	player setclientdvar( "r_sky_intensity_factor0", 0 );
    level.default_r_exposureValue = getDvar( "r_exposureValue" );
	level.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	level.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );
}


onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
		//player thread healthCounter();
        //player thread zombieCounter();
    }
}

healthCounter ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
	self.healthText = maps/mp/gametypes_zm/_hud_util::createFontString ("hudsmall", 1.5);
	self.healthText maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "CENTER", 20, 180);
	self.healthText.label = &"Health: ^5";
	while ( 1 )
	{
		self.healthText setValue(self.health);
		wait 0.25;
	}
}

zombieCounter()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", -50, 180 );
    while( 1 )
    {
        self.zombieText setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        if( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
        {
        	self.zombieText.label = &"Zombies: ^8";
        }
        else
        {
        	self.zombieText.label = &"Zombies: ^8";
        }
        wait 0.25;
    }
}


onPlayerSpawned()
{
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self thread removeperkshader();
	self thread damagehitmarker();
	self thread perkboughtcheck();
}


damagehitmarker()
{
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );
}

startwaiting()
{
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}
}

hitmark()
{
	self endon( "killed" );
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
	}
}



init_custom_map()
{
	//perk machine Docks
	perk_system( "script_model", (   -1077, 5610.5, -71.875 ), "p6_zm_al_vending_jugg_on", ( 0, -80, 0 ), "random", "mus_perks_jugganog_sting", "Random Perk", 2500, "" );
    //perk machine Cellblock
	perk_system( "script_model", ( 1837.6, 9040.5, 1336 ), "p6_zm_al_vending_jugg_on", ( 0, 180, 0 ), "random", "mus_perks_jugganog_sting", "Random Perk", 2500, "" );
    //perk machine Rooftop
	perk_system( "script_model", (  2427.45, 10048.4, 1704.13 ), "p6_zm_al_vending_jugg_on", ( 0, 0, 0 ), "random", "mus_perks_jugganog_sting", "Random Perk", 2500, "" );

}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if(type != "revive")
	{
    	col thread buy_system( perk, sound, name, cost, type );
	}
	if(type != "pap" && type != "revive" )
    {
        col thread play_fx( fx );
    }
	if(type == "revive" )
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );
	}
}

buy_system( perk, sound, name, cost, type )
{
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
				    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if( type == "original" && player usebuttonpressed() && !player hasperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
                        player thread DoGivePerk(perk);
						wait 3;
                    	player.machine_is_in_use = 0;
					}
					if( type == "random" && !player.num_perks > 15 && player usebuttonpressed() && ( player.score >= cost ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
					{
						level.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score -= cost;
						player playsound ( "mus_perks_doubletap_sting" ); 
						player drink();
						player thread give_random_perk();
						wait 1;
						player.machine_is_in_use = 0;
					}
					if(type == "random" && player.num_perks > 15 && player usebuttonpressed() && ( player.score >= cost ) )
					{
						player iprintln("you have all perks.");
						wait 3;
					}
					currgun = player getcurrentweapon();
					
                }
            }
        }
        wait 0.1;
    }
}

perksquickr()
{
    level.solo_revives = 0;
    level.max_solo_revives = 3;
	while( 1 )
	{
        players = get_players();
		foreach( player in level.players )
		{
			if(!player.machine_is_in_use)
			{
				if( distance( self.origin, player.origin ) <= 60 ) 
				{
                    if(players.size > 1)
                    {
						player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 1500]" );
                    }
                    else
                    {
					    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 500]" );
                    }
					if((players.size > 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 1500) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives = 0;
						player playsound( "zmb_cha_ching" );
						player.score -= 1500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
					}
                    if(!level.max_revives && (players.size <= 1) && player usebuttonpressed() && !(player hasperk( "specialty_quickrevive" )) && (player.score >= 500) && !(self.lock ) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
						player.machine_is_in_use = 1;
						self.lock = 1;
                        level.solo_revives++;
						player playsound( "zmb_cha_ching" );
						player.score -= 500;
						player playsound ( "mus_perks_revive_sting" );
						player thread DoGivePerk("specialty_quickrevive");
						wait 1;
						weapona = self getcurrentweapon();
						self switchToWeapon(weapona);
						wait 3;
						self.lock = 0;
						player.machine_is_in_use = 0;
					}
                    if(level.max_revives && (players.size <= 1) && player usebuttonpressed() && (player.score >= 500) && !(self.lock) && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand()) 
					{
                        player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "oh_shit" );
                        wait 3;
                    }
                    if(level.solo_revives >= level.max_solo_revives)
                    {
                        level.max_revives = 1;
                    }
					else 
                    {
                        if((players.size == 1) && player usebuttonpressed() && player.score < 500)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                        if((players.size > 1) && player usebuttonpressed() && player.score < 1500)
					    {
						    player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
					    }
                    }
				}

			}
		}
		wait 0.1;
	}

}

play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;
}


default_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" ); 

}

drink()
{
    self allowProne(false);
    self allowSprint(false);
    self disableoffhandweapons();
    self disableweaponcycling();
    weapona = self getcurrentweapon();
    weaponb = "zombie_perk_bottle_jugg";
    self giveweapon( weaponb );
    self switchtoweapon( weaponb );
    self waittill( "weapon_change_complete" );
    self enableoffhandweapons();
    self enableweaponcycling();
    self takeweapon( weaponb );
    self switchtoweapon( weapona );
    self maps/mp/zombies/_zm_audio::playerexert( "burp" );
    self setblur( 4, 0.1 );
    wait 0.1;
    self setblur( 0, 0.1 );
    self allowProne(true);
    self allowSprint(true);
}

SpawnHint( origin, width, height, cursorhint, string )
{
    hint = spawn( "trigger_radius", origin, 1, width, height );
    hint setcursorhint( cursorhint, hint );
    hint sethintstring( string );
    hint setvisibletoall();
    wait 0.2;
    hint delete();
}

spawnsm( origin, model, angles )
{
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;
}


ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(250, (0, 0, 0));
        wait 1;
    }
}

ww_nade_explosion()
{
    wait 2;
	zombies = getAiArray(level.zombie_team);
	foreach(zombie in zombies)
	{
        if( distance( zombie.origin, self.origin ) < 250 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

playerdamagelastcheck( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
    if(self hascustomperk("WIDOWS_WINE"))
	{
          if(isDefined( eAttacker.is_zombie ) && eattacker.is_zombie )
		  {
            grenades = self get_player_lethal_grenade();
            grenade_count = self getweaponammoclip(grenades);
            if(grenade_count > 0)
			{
                self setweaponammoclip(grenades, (grenade_count - 1));
                foreach(zombie in getAiArray(level.zombie_team))
				{
                    if(distance(zombie.origin, self.origin) < 150)
					{
                        zombie thread ww_points( self );
                        self PlaySound("zmb_elec_jib_zombie");
                    }
                }
            }
        }
    }
	if(self hascustomperk("PHD_FLOPPER"))
	{
		if( smeansofdeath == "MOD_FALLING" )
		{
			if(isDefined( self.divetoprone ) && self.divetoprone == 1 )
			{
				radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
				playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
				self playsound( "zmb_phdflop_explo" );
			}
			return 0;
		}
		if( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" && eattacker == self)
		{
			return 0;
		}
	}
	if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish") )
	{
        self notify("dying_wish_charge");
        self thread dying_wish_effect();
        return 0;
	}
	else
	{
		return idamage;
	}
}

doGivePerk(perk)
{
	
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
        self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}

hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

removeperkshader()
{
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
		self.dying_wish_on_cooldown = 0;
		self removeallcustomshader();
		self.perkarray = [];
        self notify( "stopcustomperk" );
        self.bleedout_time = 30;
	    self.ignore_lava_damage = 0;
    }
}

removeallcustomshader()
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
		n = 1;
        if(!(self.num_perks > self.perk_reminder))
        {
			n = (self.num_perks - self.perk_reminder);
            self.num_perks = (self.perk_reminder + n);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count += n;
        self drawshader_and_shadermove("none", 0, 0);
    }
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;
}

drawshader_and_shadermove(perk, custom, print)
{
    if(custom)
	{
        self allowProne(false);
        self allowSprint(false);
        self disableoffhandweapons();
        self disableweaponcycling();
        weapona = self getcurrentweapon();
        weaponb = "zombie_perk_bottle_jugg";
        self giveweapon( weaponb );
        self switchtoweapon( weaponb );
        self waittill( "weapon_change_complete" );
        self enableoffhandweapons();
        self enableweaponcycling();
        self takeweapon( weaponb );
        self switchtoweapon( weapona );
        self maps/mp/zombies/_zm_audio::playerexert( "burp" );
        self setblur( 4, 0.1 );
        wait 0.1;
        self setblur( 0, 0.1 );
        self allowProne(true);
        self allowSprint(true);
    }
    x = -408 + (self.perk_count * 33);
	 for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 33;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, -40, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.perk1back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1back;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^9Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
		}
        if(perk == "MULE")
        {   
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, -40, 22, 22, ( 0, 1, 0 ), 100, 0 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.perk2back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk2back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
		}
        if(perk == "PHD_FLOPPER")
        {    
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_icon_sticky_grenade", x, -40, 23, 23, (1, 0, 1 ), 100, 0 );
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.perk3back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "Victorious_Tortoise")
        {    
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			self.perk4back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk4back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Victorious Tortoise");
				wait 0.2;
				self iprintln("This Perk allows shield block damage from all directions when in use.");
        	}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.perk5back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk5back;
			self.num_perks++;
			self thread start_ec();
			if(print)
			{
				self iprintln("^9Electric Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
        	}
		}	
        if(perk == "WIDOWS_WINE")
        {    
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_3", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			self.perk6back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk6back;
			self.num_perks++;
			self takeweapon( self get_player_lethal_grenade() );
			self set_player_lethal_grenade( "frag_grenade_zm" );
			self giveweapon("frag_grenade_zm");
        	self thread ww_nades();
			if(print)
			{
				self iprintln("^9Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
        	}
		}
        if(perk == "Ethereal_Razor")
        {    
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Ethereal Razor");
				wait 0.2;
				self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
        	}
		}
		if(perk == "Ammo_Regen")
        {
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			self.perk8back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk8back;
			self.num_perks++;
			self thread ammoregen();
            self thread grenadesregen();
			if(print)
			{
				self iprintln("^9Ammo Regen");
				wait 0.2;
				self iprintln("This Perk will slowly regenerades players ammonation and grenades.");			
			}
		}
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, -40, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, -40, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk10front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk10front;
			self.perk10back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk10back;
			self.num_perks++;
            self thread dying_wish_checker();
			if(print)
			{
				self iprintln("^9Dying Wish");
				wait 0.2;
				self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
				wait 0.1;
				self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
			}
	}

}

LastStand() 
{
    if(self hascustomperk("Downers_Delight"))
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
	{
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
    }
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, anglestoforward( ( 0, 45, 55  ) ) );
		RadiusDamage(self.origin, 100, 200, 100, self);
		wait 0.1;
	}
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
    {
		self waittill( "reload_start" );
        playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
        self playsound( "zmb_turbine_explo" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 90, 220, 120, self);
		self DisableInvulnerability();
		wait 1;
    }
}

custom_get_player_weapon_limit( player )
{
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
		weapons = self getWeaponsListPrimaries();
		if(weapons.size > 2)
		{
			self takeWeapon(weapons[2]);
		}
	}
    return weapon_limit;
}

start_er()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
    {
        if (self hascustomperk("Ethereal_Razor") && self ismeleeing())
        {
            foreach(zombie in getAiArray(level.zombie_team))
			{
                if( distance( self.origin, zombie.origin ) <= 100 )
				{
					if(self is_insta_kill_active())
					{
						zombie doDamage(zombie.health + 666, (0, 0, 0));
					}
                    zombie dodamage(500, (0, 0, 0));
                    if(zombie.health <= 0)
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 100 );
						self.kills++;
					} 
					else 
					{
                        self maps/mp/zombies/_zm_score::add_to_player_score( 10 );
                    }
                } 
            }
            self.health += 10;
            if(self.health > self.maxhealth)
			{
                self.health = self.maxhealth;
            }
            while(self ismeleeing())
			{
                wait 0.1;
            }
        }
        wait 0.05;
    }
}

dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
        self.dying_wish_on_cooldown = 1;
        delay = 300 + (self.dying_wish_uses * 30);
        if(delay >= 600)
        delay = 600;
        wait delay;
    }
}

dying_wish_effect()
{
    self enableInvulnerability();
    self.ignoreme = 1;
    self useServerVisionSet(1);
    self setvisionsetforplayer( "zombie_death", 0 );
    self freezeControls(1);
    wait 1;
    self freezeControls(0);
    wait 8;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(0);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
	
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if(!self GetCurrentWeapon() == "claymore_zm" ) 
		{
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
			wait 2;
		}
		wait 0.1;
	}
}

grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
		{
        	self setweaponammoclip(grenades, (grenade_count + 1));
		}
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
		{
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		}
		wait 300;
	}
}

give_random_perk()
{
    perks = array();
	if(!self hascustomperk("Downers_Delight"))
	{
    	perks[perks.size] = "Downers_Delight";
    }
    if(!self hascustomperk("Victorious_Tortoise"))
	{
        perks[perks.size] = "Victorious_Tortoise";
    }
    if(!self hascustomperk("WIDOWS_WINE"))
	{
        perks[perks.size] = "WIDOWS_WINE";
    }
    if(!self hascustomperk("Ethereal_Razor"))
	{
        perks[perks.size] = "Ethereal_Razor";
    }
	if(!self hascustomperk("Ammo_Regen"))
	{
        perks[perks.size] = "Ammo_Regen";
    }
	if(!self hascustomperk("MULE"))
	{
        perks[perks.size] = "MULE";
    }
	//ORIGINAL PERKS
   if(!self hasPerk("specialty_armorvest"))
	{
        perks[perks.size] = "specialty_armorvest";
    }
    if(!self hasPerk("specialty_rof"))
	{
        perks[perks.size] = "specialty_rof";
    }
    if(!self hasPerk("specialty_fastreload"))
	{
        perks[perks.size] = "specialty_fastreload";
    }
    if(!self hasPerk("specialty_longersprint"))
	{
        perks[perks.size] = "specialty_longersprint";
    }
    if(!self hasPerk("specialty_quickrevive"))
	{
        perks[perks.size] = "specialty_quickrevive";
    }
	if(!self hasPerk("specialty_scavenger"))
	{
        perks[perks.size] = "specialty_scavenger";
    }
    if(!self hasPerk("specialty_deadshot"))
	{
        perks[perks.size] = "specialty_deadshot";
    }
    if(!self hasPerk("specialty_grenadepulldeath"))
	{
        perks[perks.size] = "specialty_grenadepulldeath";
    }
    if(!self hasPerk("specialty_additionalprimaryweapon"))
	{
        perks[perks.size] = "specialty_additionalprimaryweapon";
    }
    if(!self hasPerk("specialty_flakjacket"))
	{
        perks[perks.size] = "specialty_flakjacket";
    }
    if(!perks.size > 0)
	{
        self playSoundToPlayer( level.zmb_laugh_alias, self );
        return 0;
    }
    n = array_randomize(perks);
    perk = n[0];
    if(perk == "specialty_armorvest" || perk == "specialty_rof" || perk == "specialty_fastreload" || perk == "specialty_longersprint" || perk == "specialty_quickrevive" || perk == "specialty_scavenger"|| perk == "specialty_deadshot"|| perk == "specialty_grenadepulldeath"|| perk == "specialty_additionalprimaryweapon"|| perk == "specialty_flakjacket")
	{
        self maps/mp/zombies/_zm_perks::give_perk(perk, 0);
    } 
    else 
    {
        self drawshader_and_shadermove(perk, 0, 1);
    }
}
