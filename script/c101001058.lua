--星遺物の加護
--Star Relic's Aegis
--Script by mercury233
function c101001058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101001058)
	e1:SetTarget(c101001058.target)
	e1:SetOperation(c101001058.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101001058.reptg)
	e2:SetValue(c101001058.repval)
	e2:SetOperation(c101001058.repop)
	c:RegisterEffect(e2)
	--
	if not Card.IsLinkState then
		function Card.IsLinkState(c)
			if not c then return false end
			if c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()>0 then return true end
			local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
			local lc=g:GetFirst()
			while lc do
				local lg=lc:GetLinkedGroup()
				if lg and lg:IsContains(c) then return true end
				lc=g:GetNext()
			end
			return false
		end
	end
end
function c101001058.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fd) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c101001058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101001058.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c101001058.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c101001058.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsReason(REASON_BATTLE)
		and c:IsType(TYPE_LINK) and c:IsLinkState()
end
function c101001058.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101001058.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(101001058,0))
end
function c101001058.repval(e,c)
	return c101001058.repfilter(c,e:GetHandlerPlayer())
end
function c101001058.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end