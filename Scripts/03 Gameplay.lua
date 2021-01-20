-- undo hardcoded pump value in fallback
function HoldTiming()
	return PREFSMAN:GetPreference("TimingWindowSecondsHold")
end
