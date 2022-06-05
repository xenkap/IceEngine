hasComboBreak = false;
sectionHits = 0;
function onCreate()
	-- triggered when the lua file is started, some variables weren't created yet
    makeAnimatedLuaSprite('comboVisual', 'noteCombo', 100, 150);
    addAnimationByPrefix('comboVisual', 'appear', 'appear', 24, false);
    addAnimationByPrefix('comboVisual', 'disappear', 'disappear', 24, false);
    setScrollFactor('comboVisual', 0, 0);
    setObjectOrder('comboVisual', 100);
    setObjectCamera('comboVisual', 'hud');
    scaleObject('comboVisual', 0.9, 0.9);
    setProperty('comboVisual.visible', false);
end

lastFocus = 'boyfriend'
function onMoveCamera(focus)
    if focus == 'dad' and lastFocus ~= focus then
        if hasComboBreak == false and sectionHits > 0 then
            setProperty('comboVisual.visible', true);
            objectPlayAnimation('comboVisual', 'appear', false);
            playSound('noteComboSound');
            runTimer('disappearCombo', 0.5, 1)
        end
        hasComboBreak = false;
        sectionHits = 0;
    end
    lastFocus = focus;
    -- called when the camera focus on dad
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'disappearCombo' then
        setProperty('comboVisual.offset.x', getProperty('comboVisual.offset.x') + 350)
        objectPlayAnimation('comboVisual', 'disappear', false);
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    sectionHits = sectionHits + 1;
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