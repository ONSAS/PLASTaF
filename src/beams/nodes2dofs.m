function [gdl] = nodes2dofs(nodes,ndofs)

gdl = [] ;

for i = 1:length(nodes)

	gdl = [gdl  ( (nodes(i)-1)*ndofs + (1:ndofs) ) ] ; 

end

end
