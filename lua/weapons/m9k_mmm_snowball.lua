if not MMM_M9k_IsBaseInstalled then return end -- Make sure the base is installed!
if game.SinglePlayer() and not IsMounted("csgo") then return end -- In singleplayer we do not even want this to be loaded in the first place!
if SERVER and not IsMounted("csgo") then
	SWEP.Base = "meteors_notmounted_base"

	return
end -- Make sure CS:GO is mounted!

SWEP.Base = "meteors_grenade_base_model_instant"
SWEP.Category = "M9K Throwables"
SWEP.PrintName = "Snowball"

SWEP.Spawnable = true
SWEP.Slot = 4
SWEP.UseHands = true

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_snowball_dropped.mdl"

SWEP.Primary.Ammo = "m9k_mmm_snowball"

SWEP.WorldModelScale = Vector(0.5,0.5,0.5)
SWEP.ModelWorldForwardMult = 2.6
SWEP.ModelWorldRightMult = 2.3
SWEP.ModelWorldUpMult = -0.5
SWEP.ModelWorldAngForward = -90
SWEP.ModelWorldAngRight = -40
SWEP.ModelWorldAngUp = 110

SWEP.ViewModelScale = Vector(0.5,0.5,0.5)
SWEP.ModelViewForwardMult = 4
SWEP.ModelViewRightMult = 2.1
SWEP.ModelViewUpMult = -0.3
SWEP.ModelViewAngForward = -90
SWEP.ModelViewAngRight = 180
SWEP.ModelViewAngUp = 110
SWEP.ModelViewBlacklistedBones = {
	["v_weapon.Flashbang_Parent"] = true,
	["v_weapon.strike_lever"] = true,
	["v_weapon.safety_pin"] = true,
	["v_weapon.pull_ring"] = true
}

SWEP.AttacksoundPrimary = "player/winter/snowball_throw_03.wav"

if CLIENT then
	local drawSimpleText = draw.SimpleText -- We cache this stuff to prevent overrides
	local CachedColor1 = Color(255,235,0)
	local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

	function SWEP:DrawWeaponSelection(x,y,wide,tall)
		drawSimpleText("E","WeaponIcons_m9k_css",x + wide / 2 * 1.2,y + tall * 0.25,CachedColor1,TEXT_ALIGN_CENTER)
	end

	function SWEP:Initialize() -- We define this here so it does not try to load the VGUI selection material
		self:SetHoldType(self.HoldType)
		self.OurIndex = self:EntIndex()

		self.LastViewEntity = NULL

		self:CreateWorldModel()

		if self.Owner == LocalPlayer() then
			self:SendWeaponAnim(ACT_VM_IDLE)

			self:CreateViewModel()

			if self.Owner:GetActiveWeapon() == self then -- Compat/Bugfix
				self:Equip()
				self:Deploy()
			end
		end
	end
end

if SERVER then
	local MetaE = FindMetaTable("Entity")
	local CPPIExists = MetaE.CPPISetOwner and true or false
	local CachedAngles1 = Angle(0,0,-45)

	function SWEP:CreateGrenadeProjectile(Pos)
		local Projectile = ents.Create("m9k_mmm_thrownsnowball")
			SafeRemoveEntityDelayed(Projectile,30)

		Projectile:SetModel("models/weapons/w_eq_snowball_dropped.mdl")
		Projectile:SetPos(Pos)
		Projectile:SetAngles(self.Owner:EyeAngles() + CachedAngles1)
		Projectile:SetGravity(0.4)
		Projectile:SetFriction(0.2)
		Projectile:SetElasticity(0.45)
		Projectile:Spawn()
		Projectile:PhysWake()

		Projectile.WasDropped = true -- MMM Compatibility

		Projectile:SetOwner(self.Owner)

		if CPPIExists then
			Projectile:CPPISetOwner(self.Owner)
		end

		return Projectile
	end
end