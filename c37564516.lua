--Imagery
local m=37564516
local cm=_G["c"..m]
--if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function cm.initial_effect(c)
	senya.nnhr(c)
	aux.AddXyzProcedure(c,cm.mfilter,7,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,m)
	e1:SetCost(senya.desccost())
	e1:SetTarget(cm.target0)
	e1:SetOperation(cm.operation0)
	c:RegisterEffect(e1)
	senya.scopy(c,0,0,nil,nil,senya.desccost(),1,m,nil,true)
end
function cm.mfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function cm.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler(),tp)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,1,0,LOCATION_GRAVE)
	end
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		senya.overlaycard(c,tc)
	end
end