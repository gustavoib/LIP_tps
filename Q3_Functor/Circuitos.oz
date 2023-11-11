functor
import
   LogicGates at 'LogicGates.ozf'
export
   circuito1: PrimeiraEq
   circuito2: SegundaEq
   circuito3: TerceiraEq
define
   % (A and B) or (~A and ~B)
   proc {PrimeiraEq A B ?S}
      C D
   in
      C = {LogicGates.andG A B}
      D = {LogicGates.andG {LogicGates.notG A} {LogicGates.notG B}}
      S = {LogicGates.orG C D}
   end

   % (~A or B) xor ((A e B) nand (C xor ~B))
   proc {SegundaEq A B C ?S}
       D E F G
    in
      D = {LogicGates.orG {LogicGates.notG A} B}
      E = {LogicGates.andG A B}
      F = {LogicGates.xorG C {LogicGates.notG B}}
      G = {LogicGates.nandG E F}
      S = {LogicGates.xorG D G}
   end
   
    % (A and (B and C)) or ((B nand ~C) xor ~D))
    proc {TerceiraEq A B C D ?S}
       E F G H
    in
       E = {LogicGates.andG B C}
       F = {LogicGates.andG A E}
       G = {LogicGates.nandG B {LogicGates.notG C}}
       H = {LogicGates.xorG G {LogicGates.notG D}}
       S = {LogicGates.orG F H}
    end   
end







