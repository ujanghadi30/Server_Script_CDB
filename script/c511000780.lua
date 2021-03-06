--Speed Spell - Overspeed
function c511000780.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000780.con)
	e1:SetCost(c511000780.cost)
	e1:SetTarget(c511000780.target)
	e1:SetOperation(c511000780.activate)
	c:RegisterEffect(e1)
end
function c511000780.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:GetCounter(0x91)>3
end
function c511000780.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and tc:IsCanRemoveCounter(tp,0x91,tc:GetCounter(0x91),REASON_COST) end	 
	tc:RemoveCounter(tp,0x91,tc:GetCounter(0x91),REASON_COST)	
end
function c511000780.monfilter(c)
	local lv=c:GetLevel()
	return lv>0 and lv<4 and c:IsAbleToHand()
end
function c511000780.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c511000780.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000780.monfilter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c511000780.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c511000780.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c511000780.monfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c511000780.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>1 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end'
	local c=e:GetHandler()
	local res
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(100100090)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c511000780.turncon1)
		res=4
	else
		res=3
	end
	e1:SetReset(RESET_PHASE+PHASE_END,res)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(0)
	e2:SetValue(res)
	e2:SetOperation(c511000780.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END,res)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e2)
	e3:SetDescription(aux.Stringid(4931121,descnum))
	e3:SetOperation(c511000780.reset)
	e3:SetReset(RESET_PHASE+PHASE_END,res)
	c:RegisterEffect(e3)
end
function c511000780.turncon1(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511000780.reset(e,tp,eg,ep,ev,re,r,rp)
	c511000780.turnop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function c511000780.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if e:GetValue()==4 then
		e:SetValue(0)
		ct=ct-1
		e:GetLabelObject():SetCondition(aux.TRUE)
	end
	ct=ct+1
	e:SetLabel(ct)
	if ev==1082946 then
		e:GetHandler():SetTurnCounter(ct)
	end
	if ct==3 then
		e:GetLabelObject():Reset()
		if re and re.Reset then re:Reset() end
	end
end
