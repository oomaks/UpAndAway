BEVERAGE.INHERENT_INSULATION = 60
BEVERAGE.SPOILED_PREFAB = "spoiledtea"

--[[
-- The following refers to *brewed* tea.
--]]
BEVERAGE.TEA.HEAT_CAPACITY = 0.15
BEVERAGE.TEA.PERISH_TIME = 1.5*TUNING.TOTAL_DAY_TIME

BREWER.BASE_BREW_TIME = 15

--[[
-- The following refers to tea *leaves*.
--]]
TEA_LEAF.SPOILED_PREFAB = "wetgoop"

--[[
-- The following refers to tea *bushes".
--]]
TEA_BUSH.CYCLES = 4
TEA_BUSH.REGROW_TIME = 3*TUNING.TOTAL_DAY_TIME

--[[
-- Staves.
--]]
STAFF.BLACK.USES = 5
STAFF.WHITE.USES = 3

-- How long the forced static induced by it lasts.
STAFF.BLACK.EFFECT_DURATION = 120

WIND_AXE.WEAPON_USES = 20
WIND_AXE.TOOL_USES = math.floor( 0.8*TUNING.AXE_USES )
WIND_AXE.TARGET_LIGHTNING_CHANCE = 1/4
WIND_AXE.OWNER_LIGHTNING_CHANCE = 1/4
WIND_AXE.WHIRLWIND_CHANCE = 1/30

--[[
-- Golden egg.
--]]
-- How long a golden egg lasts at 30 degrees.
GOLDEN_EGG.BASE_PERISH_TIME = 3*TUNING.TOTAL_DAY_TIME
-- Minimum and maximum temperature.
GOLDEN_EGG.MIN_TEMP = -10
GOLDEN_EGG.MAX_TEMP = 120
-- Initial temperature.
GOLDEN_EGG.INITIAL_TEMP = 0.75*GOLDEN_EGG.MAX_TEMP
-- How long it takes for the egg's temperature to increase 100 degrees
-- during static.
GOLDEN_EGG.BASE_CHARGE_TIME = TUNING.TOTAL_DAY_TIME/4

--[[
-- Mushroom hat.
--]]
MUSHROOM_HAT.DURABILITY = TUNING.PERISH_MED
-- Base value for the persistency in one hat state.
local BASE_MUSHHAT_PERSIST = 12 
-- Rates of the different states, in points of stat per second.
-- A single state may affect more than one stat, and their names are arbitrary.
-- The persistency function defines the average time spent in the state, taking
-- as its argument the current freshness of the hat.
MUSHROOM_HAT.STATES = {
	HEALTH_INCREASE = {
		effects = {
			health = 1
		},
		persistency = function(f)
			return 1 + 0.6*BASE_MUSHHAT_PERSIST*f
		end,
	},
	HEALTH_DECREASE = {
		effects = {
			health = -0.8
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.8*f)
		end,
	},
	HUNGER_INCREASE = {
		effects = {
			hunger = 1
		},
		persistency = function(f)
			return 1 + 0.7*BASE_MUSHHAT_PERSIST*f
		end,
	},
	HUNGER_DECREASE = {
		effects = {
			hunger = -0.8
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.6*f)
		end,
	},
	SANITY_INCREASE = {
		effects = {
			sanity = 0.5
		},
		persistency = function(f)
			return 1 + 0.8*BASE_MUSHHAT_PERSIST*f
		end,
	},
	SANITY_DECREASE = {
		effects = {
			sanity = -1.5
		},
		persistency = function(f)
			return 1 + BASE_MUSHHAT_PERSIST*(1 - 0.4*f)
		end,
	},
}
-- Period between widget announcements of stat change.
MUSHROOM_HAT.NAGGING_PERIOD = 3

-- Max dist for a beefalo to become a follower.
WINNIE_STAFF.MAX_FOLLOWER_DIST = 20
-- Max beefalo followers.
WINNIE_STAFF.MAX_FOLLOWERS = 5

-- Attraction radius for ball_lightning from magnets.
MAGNET.ATTRACTION_RADIUS = 16
