functor
export
    andG: AndG
    orG: OrG
    xorG: XorG
    nandG: NandG
    norG: NorG
    notG: NotG
define      
fun {GateMaker F}
   fun {$ Xs Ys}
      fun {GateLoop Xs Ys}
	 case Xs#Ys of (X|Xr)#(Y|Yr) then
	    {F X Y}|{GateLoop Xr Yr}
	 end
      end
   in
      thread {GateLoop Xs Ys} end
   end
end

AndG = {GateMaker fun {$ X Y} X*Y end}
OrG = {GateMaker fun {$ X Y} X+Y-X*Y end}
XorG = {GateMaker fun {$ X Y} X+Y-2*X*Y end}
NandG = {GateMaker fun {$ X Y} 1-X*Y end}
NorG = {GateMaker fun {$ X Y} 1-X-Y+X*Y end}

fun {NotG Xs}
   local 
      fun {NotLoop Xs}
	 case Xs of X|Xr then (1-X)|{NotLoop Xr} end
      end
   in
      thread {NotLoop Xs} end
   end
end

end	  