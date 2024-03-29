
function trussColormaps(Conec, Nodes, NodesDef, epsPlaHist)

nelems = size(Conec,1) ;
  
% Plot params
% ----------------------------------------------------------------------

lw1 = 2.0 ; ms1 = 11 ; plotFontSize = 22 ;

fig = figure ;

% Colormap
cmap = flipud( colormap('hot') ) ;
colormap(cmap) ;


hold on, grid on

for i=1:nelems
  enods = Conec(i,1:2);
  plot( Nodes(enods,1), Nodes(enods,2),['b--o'],'linewidth',lw1 )


  if sigmas(i)> 1e-3*max(abs(sigmas)),
    cmapi = cmap( max( [1 round( sigmas(i) / max(sigmas) * length(cmap) ) ] ),: );
    plot( nodesdef(enods,1), nodesdef(enods,2),'color',cmapi,'linewidth',lw1 )
  end

end


%~ quiver(nodesdef(nodeload,1), nodesdef(nodeload,2),fext(2*nodeload-1)*sc, fext( 2*nodeload)*sc ,'linewidth',LW,'b-x')


colorbar('title','stress')


print(fig, ['example' num2str(example) '.png'],'-dpng')
