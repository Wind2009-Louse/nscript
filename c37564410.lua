--百慕 全力偶像·萨妮娅

local m=37564410
local cm=_G["c"..m]
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismCommonEffect(c,c37564410.target,c37564410.operation,true)
end
function c37564410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Senya.CheckPrism,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c37564410.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37564410,0))
	local g=Duel.SelectMatchingCard(tp,Senya.CheckPrism,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
