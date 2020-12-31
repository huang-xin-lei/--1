function [PG,PV,gbest,timecost,Scheme]=Container(aa,box,orginal_cargo,box_sty)
 %% ���м�װ���Ż�
global cargo; global lambda; global num_cargo;global num_box;global solution;

%% -------------------------------���Ʋ���---------------------------

lambda = 0.5;       % ����������Ȩ��

T0 = 100;           % ��ʼ�¶�
T_End = 1;          % ��ֹ�¶�
metropolis = 100;   % �˻��㷨�� metropolis������
cooling = 0.98;     % ����ϵ��

pop = 11;           %�Ŵ��㷨Ⱦɫ����
maxite = 10;       %�Ŵ�����������
pm = 0.1;           %�Ŵ��������
%% --------------------------------------------------------------------

%% ----------------------------��ʼ������ȡ������Ϣ ----------------------------

% aa=load(bestway); %��ȡ·���ϵĽ�
box=box(box_sty,:); % ѡ�������
% cargo=[];
orginal_cargo=orginal_cargo(aa,:); 
count=1;
for i=1:size(orginal_cargo,1)           %�ع������ʽ  cargo: �� �� �� �� ��� ������ ��>��>��
    for j=1:orginal_cargo(i,2) %������� =size(orginal_cargo,1)*orginal_cargo(i,2) 
        cargo(count,1:4) = orginal_cargo(i,3:6);
        cargo(count,5) = prod(cargo(count,2:4),2); 
        cargo(count,2:4) = sort(cargo(count,2:4),'descend');
        count=count+1;
    end
end         
for i=1:size(box,1)                          %�ع�����box: �� �� �� �� ���
    box(i,5)=prod(box(i,2:4),2);            
end

num_cargo=size(cargo,1);  % ������
num_box=size(box,1);      % ������

solution= fix((num_box)*rand(1,num_cargo))+1;   %������ɳ�ʼ��
Scheme=transform(solution);                     %��ת���ɡ����䣺�����Ӧ����ʽ
[feas_solution,Scheme]= placement(Scheme,box);             %װ�䴦��

[PG,PV,gbest ]= evaluate(feas_solution,box) ;      %������Ӧ��

%--------------------------------------------------------------------

%----------------------------�˻�------------------------
begin=cputime;   %��ʼ��ʱ

%�Ŵ��㷨�Ż�     GENE��Ⱦɫ����/��Ⱥ��ģ��������������Ⱦɫ�峤��/ά�ȣ�������ʣ�
[final_solution,gbest]=GENE(pop,maxite,num_cargo,pm,box) ;  

%�Ŵ�ִ����Ϻ�  ģ���˻��һ���Ż�
T = T0;
while T > T_End
    for i=1:metropolis
        %-----------��������������������½�
        newsolution=final_solution;
        R1=fix(rand*num_cargo)+1;
        R2=fix(rand*num_cargo)+1;
        inter=newsolution(R1);
        newsolution(R1)=newsolution(R2);
        newsolution(R2)=inter;
        NewScheme=transform(newsolution);                   % �������
        [feas_solution,NewScheme]= placement(NewScheme,box);              % װ�䴦��
        [NPG,NPV,pbest ]= evaluate(feas_solution,box);            % �����·���
        if pbest>gbest
            gbest = pbest;
            final_solution = newsolution;
            PG = NPG;
            PV = NPV;
            Scheme = NewScheme;
        else
            if  rand < exp( (pbest-gbest)*100*T0/T)
                gbest=pbest;
                final_solution=newsolution;
                PG = NPG;
                PV = NPV;
                Scheme = NewScheme;
            end
        end   
    end
    T = T * cooling;
end

timecost = cputime-begin;   %��ʱ����



