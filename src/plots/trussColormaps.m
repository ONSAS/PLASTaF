
function trussColormaps
  
figure
cmap = flipud( colormap('hot') ) ;
colormap(cmap);

hold on, grid on
for i=1:nelems
  enods = conec(i,:);
  plot( nodes(enods,1), nodes(enods,2),['b--o'],'linewidth',LW )

  if sigmas(i)> 1e-3*max(abs(sigmas)),
    cmapi = cmap( max( [1 round( sigmas(i) / max(sigmas) * length(cmap) ) ] ),: );
    plot( nodesdef(enods,1), nodesdef(enods,2),'color',cmapi,'linewidth',LW*2.0 )
  end
end
quiver(nodesdef(nodeload,1), nodesdef(nodeload,2),fext(2*nodeload-1)*sc, fext( 2*nodeload)*sc ,'linewidth',LW,'b-x')
colorbar('title','stress')
print(['example' num2str(example) '.png'],'-dpng')
