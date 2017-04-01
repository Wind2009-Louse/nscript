--soku

local m,cm=senya.sayuri_ritual(37564904)
cm.named_with_remix=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	senya.icopy(c,1,m,senya.sedescost,cm.condition2,LOCATION_HAND)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(senya.order_table_new({}))
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
cm.mat_filter=senya.sayuri_mat_filter_12
function cm.cfilter(c,ori)
	return senya.check_set_sayuri(c) and c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sayuri_trigger_operation(c,e,tp,eg,ep,ev,re,r,rp)
	c:RegisterFlagEffect(m,0xfe1000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,m*16)
end
cm.sayuri_trigger_forced=true
function cm.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER)
end
function cm.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=senya.order_table[e:GetLabel()]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(cm.copyfilter,tp,0,LOCATION_MZONE,nil)
	local dg=exg:Filter(cm.gfilter,nil,g)
	dg:ForEach(function(tc)  
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end)
	local cg=g:Filter(cm.gfilter1,nil,exg)
	cg:ForEach(function(tc)  
		copyt[tc]=cm.copy(c,tc:GetOriginalCode())
		exg:AddCard(tc)
	end)
end
function cm.copy(c,code)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		if e:IsHasType(0x7e0) then
			e:SetCondition(cm.rcon(e:GetCondition()))
		end
		f(tc,e,forced)
	end
	local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	Card.RegisterEffect=f
	return cid
end
function cm.rcon(con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():GetFlagEffect(m)>0 then return true end
		return not con or con(e,tp,eg,ep,ev,re,r,rp)
	end
end