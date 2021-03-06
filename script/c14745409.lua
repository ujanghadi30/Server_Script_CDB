--聖剣ガラティーン
function c14745409.initial_effect(c)
	c:SetUniqueOnField(1,0,14745409)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--register
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetOperation(c14745409.regop)
	e3:SetRange(0xff)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetLabelObject(e2)
	e4:SetCondition(c14745409.atkcon)
	e4:SetOperation(c14745409.atkop)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(14745409,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,14745409)
	e5:SetCondition(c14745409.eqcon)
	e5:SetTarget(c14745409.eqtg)
	e5:SetOperation(c14745409.eqop)
	c:RegisterEffect(e5)
end
function c14745409.regop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(aux.FilterEqualFunction(Card.GetEquipTarget,e:GetHandler()),1,nil) then return end
	local pe=e:GetLabelObject()
	pe:SetValue(1000)
end
function c14745409.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c14745409.atkop(e,tp,eg,ep,ev,re,r,rp)
	local pe=e:GetLabelObject()
	local atk=pe:GetValue()
	pe:SetValue(atk-200)
end
function c14745409.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c14745409.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)
end
function c14745409.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x107a) and c:IsRace(RACE_WARRIOR)
end
function c14745409.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14745409.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c14745409.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c14745409.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
