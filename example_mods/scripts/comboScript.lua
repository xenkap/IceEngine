hasComboBreak = false;
hasSectionHit = false;
function onCreate()
	-- triggered when the lua file is started, some variables weren't created yet
    makeAnimatedLuaSprite('comboVisual', 'NOTECOMBO', 100, 150);
    addAnimationByPrefix('comboVisual', 'combo', 'NoteCombo', 24, false);
    setScrollFactor('comboVisual', 0, 0);
    setObjectOrder('comboVisual', -100)
    setObjectCamera('comboVisual', 'game');
    scaleObject('comboVisual', 1.2, 1.2);
end

lastFocus = 'boyfriend'
function onMoveCamera(focus)
    if focus == 'dad' and lastFocus ~= focus then
        if hasComboBreak == false and hasSectionHit == true then
            setObjectOrder('comboVisual', 100)
            setObjectCamera('comboVisual', 'hud');
            objectPlayAnimation('comboVisual', 'combo', false);
            playSound('wo', 0.2)
        end
        hasComboBreak = false;
        hasComboBreak = false;
    end
    lastFocus = focus;
    -- called when the camera focus on dad
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    hasSectionHit = true;
	-- Function called when you hit a note (after note hit calculations)
	-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
	-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
	-- noteType: The note type string/tag
	-- isSustainNote: If it's a hold note, can be either true or false
end

function noteMissPress(direction)
    hasComboBreak = true;
	-- Called after the note press miss calculations
	-- Player pressed a button, but there was no note to hit (ghost miss)
end

function noteMiss(id, direction, noteType, isSustainNote)
    hasComboBreak = true;
	-- Called after the note miss calculations
	-- Player missed a note by letting it go offscreen
end