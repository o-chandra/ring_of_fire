sf.name = 'wildfire';
sf.caption='TODO';
curr_dir = cd;

fighandle = gcf;

% savefig(sf,target_dir,fighandle,p)
%
% sf is a savefig structure that must at least specify a name (string) for the
% figures, sf.name. A caption may be included, sf.caption. The input target_dir
% should be the name of the system or project folder. fighandle should
% contain a handle to the figure. The STABLAB structure p of parameters is
% an optional input. When provided, the componenets of p are printed.

set(gca,'FontSize',22);
set(gca,'LineWidth',2);

cd('/Users/blakebarker/Dropbox/stablab21/Olivia/latex/pics');

try
    fign=load('fignum');
catch me
    fignum=0;
    save('fignum','fignum');
    fign=load('fignum');
end

fignum=fign.fignum;
fignum=fignum+1;
save('fignum','fignum');
saveas(fighandle,[sf.name,'fig',num2str(fignum),'.fig']);
% saveas(fighandle,[sf.name,'fig',num2str(fignum),'.pdf']);
% saveas(fighandle,[sf.name,'fig',num2str(fignum),'.eps']);
% saveas(fighandle,[sf.name,'fig',num2str(fignum),'.jpg']);
print('-depsc',[sf.name,'fig',num2str(fignum),'.eps']);
system(['pstopdf ',sf.name,'fig',num2str(fignum),'.eps']);
cd(curr_dir);

fprintf('\n\n\\begin{figure}[htbp]\n \\begin{center}\n$\n\\begin{array}{lcr}\n\\includegraphics[scale=0.5]{pics/');
fprintf([sf.name,'fig',num2str(fignum)]);
fprintf('}\n\\end{array}\n$\n\\end{center}\n\\caption{');
fprintf(sf.caption)

fprintf('\nParameters (\n');
print_struct(p,1);
fprintf(')');

fprintf('  (Figure name: ');
for j = 1:length(sf.name)
    if strcmp(sf.name(j),'_')
        fprintf('\\');
    end
        fprintf(sf.name(j));
end

fprintf(['fig',num2str(fignum)]);
fprintf('}\n\\end{figure}\n\n')

