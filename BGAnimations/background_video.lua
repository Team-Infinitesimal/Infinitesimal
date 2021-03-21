return Def.ActorFrame {

	Def.Sprite {
		Texture=THEME:GetPathG("","bg"),
		InitCommand=function(self)
			self:Center()
			:scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
		end
	},

	-- Experimental spinny arrow thing, breaks masks tho
	--[[ Def.Model {
		Meshes=THEME:GetPathG("", "3d/arrow/meshes.txt"),
		Materials=THEME:GetPathG("", "3d/arrow/materials.txt"),
		Bones=THEME:GetPathG("", "3d/arrow/bones.txt"),
		OnCommand=function(self)
			self:Center()
			:zoom(2)
			:diffusealpha(0.5)
			:polygonmode("PolygonMode_Line")
			:queuecommand("Spin")
		end,
		SpinCommand=function(self)
			self:linear(5)
			:rotationx(360)
			:rotationy(360)
			:rotationz(360)
			:linear(0)
			:rotationx(0)
			:rotationy(0)
			:rotationz(0)
			:queuecommand("Spin")
		end
	} --]]

}
