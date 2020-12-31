function [ PG,PV,fitness ] = evaluate( solution,box )

global cargo; global lambda
fit_G = 0;
fit_V = 0;

for i=1:size(solution,2)
        if solution(i) ~= 0
            fit_G= fit_G + cargo(i,1);
        end   
end
PG=fit_G/sum(box(:,1));%/0.7592240395; %������������

for i=1:size(solution,2)
        if solution(i) ~= 0
            fit_V= fit_V + cargo(solution(i),5);
        end   
end
PV=fit_V/ sum(box(:,5));%/0.1551777072;%�����������

fitness=lambda*PG+(1-lambda)*PV;