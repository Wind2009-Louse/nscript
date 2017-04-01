--3L·Firefly
local m=37564847
local cm=_G["c"..m]

function cm.initial_effect(c)
	senya.leff(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(m*16)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_HAND)
	e6:SetHintTiming(0x3c0)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCountLimit(1,m)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING) and Duel.IsExistingMatchingCard(cm.filter3L,tp,LOCATION_MZONE,0,1,nil)
	end)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.scopytg)
	e6:SetOperation(cm.scopyop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(m*16)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_HAND)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCountLimit(1,m)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.filter3L,tp,LOCATION_MZONE,0,1,nil)
	end)
	e7:SetCost(cm.cost)
	e7:SetTarget(cm.scopytg2)
	e7:SetOperation(cm.scopyop)
	c:RegisterEffect(e7)
	if not cm.last_spell then
		cm.last_spell={}
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_SOLVED)
		ge:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
			return true
		end)
		ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.last_spell[Duel.GetTurnCount()]=re:GetHandler()
		end)
		Duel.RegisterEffect(ge,0)
	end
end
function cm.effect_operation_3L(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ev,re,rp)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,ev,re,rp)
		local sg=g:RandomSelect(tp,1)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_CARD,0,sc:GetOriginalCode())
		local te=sc:GetActivateEffect()  
		Duel.ChangeTargetCard(ev,Group.CreateGroup())
		Duel.ChangeChainOperation(ev,cm.cop(te))
	end)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	return e2
end
function cm.filter3L(c)
	return senya.check_set_3L(c) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.scopytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell[Duel.GetTurnCount()-1]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not tc then return false end
		return cm.scopyf1(tc)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.scopytg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell[Duel.GetTurnCount()-1]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		if not tc then return false end
		return cm.scopyf2(tc,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.scopyf1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.scopyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.scopyf1(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.scopyf2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:CheckActivateEffect(true,true,false) then return true end
	local te=c:GetActivateEffect()
	if te:GetCode()~=EVENT_CHAINING then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	return true
end
function cm.tfilter(c,ev,re,rp)
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) then return false end
	local te=c:GetActivateEffect()
	if not te then return false end
	local code=te:GetCode()
	local rcode=re:GetCode()
	if code~=EVENT_FREE_CHAIN and code~=rcode then return false end
	local tg=te:GetTarget()
	if not tg then return true end
	if code==EVENT_CHAINING then
		local cid=Duel.GetChainInfo(ev-1,CHAININFO_CHAIN_ID)
		local ceg,cep,cev,cre,cr,crp=table.unpack(senya.previous_chain_info[cid])
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	else
		local ex,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		return tg(re,rp,ceg,cep,cev,cre,cr,crp,0)
	end
end
function cm.cop(te)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tg=te:GetTarget()
		if bit.band(c:GetType(),TYPE_FIELD+TYPE_CONTINUOUS)==0 then
			c:CancelToGrave(false)
		end
		local pr=e:GetProperty()
		e:SetProperty(te:GetProperty())  
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then
			e:SetProperty(pr)
			return
		end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		e:SetProperty(pr)
	end
end