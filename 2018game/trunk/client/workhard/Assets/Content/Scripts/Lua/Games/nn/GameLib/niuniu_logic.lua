--card : card.color , card.point


local niuniu_logic = {}

function niuniu_logic.change_card(base_card )
	local niu_card = {}
	niu_card.color = math.floor(base_card/16)
	local point = base_card-niu_card.color*16
	if point>10 then 
		point = point -10 
	end	
	niu_card.point =point
end

function   niuniu_logic.compareCard( cardA, cardB)
	if cardA.point ~= cardB.point then
		return cardA.point<cardB.point
	else
		return cardA.color<cardB.color
	end
	
end



local function makeniuniu(fiveCards)
	local allresult = {}

 	--enum every case 
	for first=1,3 do
		for second = first+1,4 do
			for third = second +1,5 do
					local tmpthree = {} 
					local tmptwo = {}
					
					for i,v in ipairs(fiveCards) do
						
						if i == first or i== second or i == third then
							table.insert(tmpthree,{color=v.color,point=v.point})
						else 
							table.insert(tmptwo,{color=v.color,point=v.point})
						end	
					end
					--print("1..."..tmpthree[1].."2..."..tmpthree[2].."3..."..tmpthree[3])
					table.insert(allresult,{tmpthree,tmptwo})
					--table.insert(allresult,{fiveCards[first],fiveCards[second],fiveCards[third]})
			end
		end

	end
	return allresult 	
end

function niuniu_logic.splitNiuCards(fiveCards)
	

	 local allcase =  makeniuniu(fiveCards)
	 
	 --find max num
	 local maxindex = 1
	 local maxnum = 0
	 for i=1,#allcase do
		 local tmpnum =  niuniu_logic.countNiu(allcase[i][1],allcase[i][2])
		 if tmpnum>	maxnum then
		   maxnum= tmpnum
		   maxindex = i
		 end
	 end
	 
	 return maxnum, {allcase[maxindex][1],allcase[maxindex][2]}
	 
end





function  niuniu_logic.countNiu(threeCards,twoCards)
	--if gets point or not 


		local tmp_point= {}
		tmp_point[1]=threeCards[1].point
		tmp_point[2] = threeCards[2].point
		tmp_point[3] = threeCards[3].point
		tmp_point[4] = twoCards[1].point
		tmp_point[5] = twoCards[2].point

		for i,v in ipairs(tmp_point) do 
			if v> 10 then 
				
				tmp_point[i]=  10
			end
		end		


		local point = tmp_point[1]+tmp_point[2]+tmp_point[3]
		if point%10 == 0 then
			local tmp_r = tmp_point[4]+tmp_point[5]
			while tmp_r>10 do
				tmp_r = tmp_r - 10
			end
			return tmp_r	

		else
			return 0
		end
end

function niuniu_logic.sort_cards(five_cards)
	local tmp_result = {}
	for i,v in ipairs(five_cards) do 
		table.insert(tmp_result,{color = v.color,point = v.point})
	end	

	local cmp_func = function(cardA,cardB)
		if cardA.point ~= cardB.point then
		return cardA.point<cardB.point
		else
			return cardA.color<cardB.color
		end
	end	

	table.sort(tmp_result,cmp_func)

	return tmp_result
end

function niuniu_logic.is_straight(sorted_cards)
	for i=1,#sorted_cards-1 do 
		if sorted_cards[i+1].point - sorted_cards[i].point ~=1 then 
			return false
		end
	end

	return true		

end

function niuniu_logic.is_suited(sorted_cards)
	local tmp_color = sorted_cards[1].color
	for i,v in ipairs(sorted_cards) do 
		if v.color~=tmp_color then 
			return false
		end
	end

	return true		
end

function niuniu_logic.is_five_big(sorted_cards)
	for i,v in ipairs(sorted_cards) do 
		if v.point<=10 then 
			return false
		end
	end

	return true		
end

function niuniu_logic.is_five_small(sorted_cards)
	local tmp_total = 0
	for i,v in ipairs(sorted_cards) do 
		if v.point>=5 then 
			return false
		else
			tmp_total = tmp_total +v.point	
		end 
	end 
	if tmp_total >10 then 
		return false
	else
		return true
	end		

end

function niuniu_logic.is_flush(sorted_cards)
	if not niuniu_logic.is_straight(sorted_cards) then
		return false
	end 

	if not niuniu_logic.is_suited(sorted_cards) then 
		return false
	end		

	return true
end

function niuniu_logic.count_cards(cards)
	local tmp_info = {}
	for i,v in ipairs(cards) do 
		local tmp_point = v.point
		if not tmp_info[tmp_point] then 
			tmp_info[tmp_point] = 1
		else
			tmp_info[tmp_point] = tmp_info[tmp_point]+1
		end
	end			

	return tmp_info
end

function niuniu_logic.is_bomb(sorted_cards)
	local count_info = niuniu_logic.count_cards(sorted_cards)
	local tmp_max = 0
	for k,v in pairs(count_info) do 
		if v>tmp_max then 
			tmp_max = v 
		end
	end 

	if tmp_max~=4 then 
		return false
	else
		return true
	end				
end

function niuniu_logic.is_full_house(sorted_cards)
	local count_info = niuniu_logic.count_cards(sorted_cards)
	local tmp_two = false
	local tmp_three = false
	for k,v in pairs(count_info) do 
		if v == 2 then 
			tmp_two = true
		elseif v == 3 then
			tmp_three = true
		end
	end	

	if tmp_two and tmp_three then 
		return true
	else
		return false
	end		

end


return niuniu_logic