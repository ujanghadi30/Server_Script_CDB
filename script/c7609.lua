--捕食植物キメラフレシア
--Predator Plant Chimera Rafflesia
--Script by nekrozar
function c7609.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcFun2(c,c7609.ffilter,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
	else
		aux.AddFusionProcFun2(c,c7609.ffilter,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
	end
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7609,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c7609.rmtg)
	e1:SetOperation(c7609.rmop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7609,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c7609.atkcon)
	e2:SetTarget(c7609.atktg)
	e2:SetOperation(c7609.atkop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c7609.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7609,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c7609.thcon)
	e4:SetTarget(c7609.thtg)
	e4:SetOperation(c7609.thop)
	c:RegisterEffect(e4)
end
function c7609.ffilter(c)
	return c:IsFusionSetCard(0xf3) or c:IsFusionCode(96622984,22011689,69105797)
end
function c7609.rmfilter(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv) and c:IsAbleToRemove()
end
function c7609.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c7609.rmfilter(chkc,c:GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c7609.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c7609.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c7609.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c7609.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:GetAttack()>=1000
end
function c7609.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function c7609.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if  tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>=1000 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
	end
end
function c7609.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(7609,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c7609.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(7609)>0
end
function c7609.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c7609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7609.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7609.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end