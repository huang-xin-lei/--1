%% Դ����ο� 
% ������Դ �������Ӻ�������
% �޸� �е�
% ���ݣ� ��ʱ�䴰��Լ����·���滮��ϱ���װ�����⣬��װ��������ӻ���
% �ص㣺 ���Ż������п��Ǳ�����װ��Ҳ�ڷ�λ�ã���Ƕȿ������⣬ϸ�����̺Ϳ��ӻ�
% ���㣺 û�������Խ�������ṩ�ο����壬ȱ��ʵ�ʼ�ֵ��û�н����߸����л����
%���Ľ��ĵ㣺 1.��װ�䲿����·��ѡ���Ȩ������������ǰڷ�λ�����û����飬���ͻ����������ƥ�䡣���ӻ��Ĺ��������Ҫ��ƥ��
% 2. ���Ͳ������ã����㷨
% ���� 162480875@qq.com �����ʻ��鷢��

%% 2020��12��19��16:34:43
% �汾 0.01
% ����������� ̼�ŷ���
%% 2020��12��27��15:51:32
% �汾 0.02
% �򵥵�������ͼ�����˱�ǩ
%% 2020��12��30��23:11:18
% �汾0.1
% ������װ�����չʾ��װ���Ż��ͳ�������ѡ��
%% 2020��12��31��10:24
% �汾0.11
% ����װ��Լ���복��Լ��Ƕ��
clear
clc
close all
tic
%% ��importdata�����������ȡ�ļ�
c101=importdata('c103.txt');
box=load('box'); %��������Ϣ  box: �� �� �� �� ���
box_sty=1; %װ������������
orginal_cargo=load('cargo'); %��ȡ��ͬ�ص�Ļ�����Ŀ���������  ��� ������Ŀ �� �� �� ��
cap=box(1);                                                        %�������װ����
v_cap=2;   %�����ٶȣ���λʱ�䣩
%% ��ȡ������Ϣ
E=c101(1,5);                                                    %��������ʱ�䴰��ʼʱ��
L=c101(1,6);                                                    %��������ʱ�䴰����ʱ��
vertexs=c101(:,2:3);                                            %���е������x��y
customer=vertexs(2:end,:);                                      %�˿�����
cusnum=size(customer,1);                                        %�˿���
v_num=3;                                                       %�������ʹ����Ŀ
demands=c101(2:end,4);                                          %������
a=c101(2:end,5);                                                %�˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
b=c101(2:end,6);                                                %�˿�ʱ�䴰����ʱ��[a[i],b[i]]
width=b-a;                                                      %�˿͵�ʱ�䴰���
s=c101(2:end,7);                                                %�ͻ���ķ���ʱ��
choose_way=input('����ľ������͡�������1 ����λ�� 2 ��γ��===');
if choose_way==1
    h=pdist(vertexs);
    dist=squareform(h);                                             %������� �������
   % dist(1,3)=555;
else 
     mi=[vertexs];
        cc=zeros(size(mi,1));
        for j=1:size(mi,1)
            for i=j:size(mi,1)
                cc(j,i)=abs(6371004*acos((sin(deg2rad(mi(j,2)))*sin(deg2rad(mi(i,2)))+cos(deg2rad(mi(j,2)))*cos(deg2rad(mi(i,2)))*cos(deg2rad(mi(i,1)-mi(j,1))))));
                if i==j || cc(j,i)==0
                     cc(j,i)=eps;
                end
                cc(i,j)=cc(j,i);
            end
        end
        un_1_1=cc;
        dist=un_1_1;        %�������
end
%% ��ʼ������
w_PPm_b=1;%��ʼ�����Ϊ1
m=50;                                                           %��������
alpha=1;                                                        %��Ϣ����Ҫ�̶�����
beta=3;                                                         %����������Ҫ�̶�����
gama=2;                                                         %�ȴ�ʱ����Ҫ�̶�����
delta=3;                                                        %ʱ�䴰�����Ҫ�̶�����
r0=0.5;                                                         %r0Ϊ��������ת�ƹ���Ĳ���
rho=0.85;                                                       %��Ϣ�ػӷ�����
Q=100;                                                          %������Ϣ��Ũ�ȵĳ���
Eta=1./dist;                                                    %��������
Tau=ones(cusnum+1,cusnum+1);                                    %��Ϣ�ؾ���
Table=zeros(m,cusnum);                                          %·����¼��
iter=1;                                                         %����������ֵ
iter_max=10;                                                   %����������
Route_best=zeros(iter_max,cusnum);                              %�������·��
Cost_best=zeros(iter_max,1);                                    %�������·���ĳɱ�
ture_c=0;  %�Ƿ�����װ�� 
%% ����Ѱ�����·��
while iter<=iter_max || ture_c~=1
    %% �ȹ������������ϵ�·��
    %�������ѡ��
    for i=1:m
        %����˿�ѡ��
        for j=1:cusnum
            r=rand;                                             %rΪ��[0,1]�ϵ��������
            np=next_point(i,Table,Tau,Eta,alpha,beta,gama,delta,r,r0,a,b,width,s,L,dist,cap,demands);
            Table(i,j)=np;
        end
    end
    %% ����������ϵĳɱ�=1000*����ʹ����Ŀ+������ʻ�ܾ���
    cost=zeros(m,1);
    NV=zeros(m,1);
    TD=zeros(m,1);
    for i=1:m
        [VC,NV,TD,Q_U,w_pp]=decode(Table(i,:),cap,demands,a,b,L,s,dist);
        [cost(i,1),NV(i,1),TD(i,1),ff(i,1),c_11(i,1),w_PPm(i,1)]=costFun(VC,dist,Q_U,w_pp);
    end
    %% ������С�ɱ���ƽ���ɱ�
    if iter == 1
        [min_Cost,min_index]=min(cost);
        c_bb=c_11(min_index);
        f_bb=ff(min_index);
        Cost_best(iter)=min_Cost;
        w_PPm_m(iter)=mean(w_PPm);
        Route_best(iter,:)=Table(min_index,:);
    else
        [min_Cost,min_index]=min(cost);
        w_PPm_m(iter)=mean(w_PPm);
        Cost_best(iter)=min(Cost_best(iter - 1),min_Cost);
        c_bb=c_11(min_index);
        f_bb=ff(min_index);
        w_PPm_b=w_PPm(min_index);
        if Cost_best(iter)==min_Cost
            Route_best(iter,:)=Table(min_index,:);
            c_bb=c_11(min_index);
            f_bb=ff(min_index);
             w_PPm_b=w_PPm(min_index);
        else
            Route_best(iter,:)=Route_best((iter-1),:);
            c_bb=c_11(min_index);
            f_bb=ff(min_index);
             w_PPm_b=w_PPm(min_index);
        end
    end
    %% ������Ϣ��
    bestR=Route_best(iter,:);
    [bestVC,bestNV,bestTD]=decode(bestR,cap,demands,a,b,L,s,dist);
    Tau=updateTau(Tau,bestR,rho,Q,cap,demands,a,b,L,s,dist);
   %% �ж����ɵ�·���Ƿ����Ҫ��
   % ���Թ���
    for i=1:size(bestVC,1)
         aa=bestVC{i,:};
        [PG,PV,gbest,timecost,Scheme]=Container(aa,box,orginal_cargo,box_sty); %��װ�޽���Լ��
            if PG>1||PV>1 % �ж������ʺͿռ������������ ���������ת������������
                box_sty=box_sty+1;
                ture_c=0;
                 disp('û�з���Ҫ���װ������,��Ҫ�ı�����')
%                  iter=abs(iter-1);
                kk=1;
                if max(box_sty)>size(box,1) 
                     disp('װ������ȫ����������Ҫ��,�����趨������ͣ')
%                     pause
                      box_sty=[1:kk];
                      kk=kk+1;
                      ture_c=0;
                end
            else
                ture_c=1;
            end
    end
    %% ���ʱ��
    t_1=bestTD/v_cap; % ·��ʱ��
    s_1=sum(s); % �ܷ���ʱ��
    T_BEAST=t_1+s_1; 
    %% ��ӡ��ǰ���Ž�
    if v_num<=num2str(bestNV)
        disp(['��',num2str(iter),'�����Ž�:'])
        disp(['����ʹ����Ŀ��',num2str(bestNV),'��װ��������ѡ��',num2str(box_sty),'��������ʻ�ܾ��룺',num2str(bestTD),'���̼�ŷ���',num2str(c_bb),'�����Ϊ',num2str(w_PPm_b),'���ʱ��',num2str(T_BEAST)]);
    else
        disp(['��',num2str(iter),'�����Ž�:'])
        disp(['����ѭ��������',num2str(bestNV),'��װ��������ѡ��',num2str(box_sty),'��������ʻ�ܾ��룺',num2str(bestTD),'���̼�ŷ���',num2str(c_bb),'�����Ϊ',num2str(w_PPm_b),'���ʱ��',num2str(T_BEAST)]);
    end
    fprintf('\n')
   
   %% ����������1�����·����¼��
    iter=iter+1;
    Table=zeros(m,cusnum);
end
%% �����ʾ
bestRoute=Route_best(end,:);
[bestVC,NV,TD]=decode(bestRoute,cap,demands,a,b,L,s,dist);
draw_Best(bestVC,vertexs);
 for i=1:size(bestVC,1)
%     currentDate=strcat('a',num2str(i))
%     aa.(currentDate)=bestVC{i,:};
        aa=bestVC{i,:};
%     save(strcat('bestVC',num2str(i),'.mat'), 'aa')
[PG,PV,gbest,timecost,Scheme]=Container(aa,box,orginal_cargo,box_sty); %��װ�޽���Լ��
result(Scheme,15);      %��װ�䷽��Scheme ��ÿ��15��������ʾ
figure
fprintf('���������ʣ�\t%5.3f %%\n',PG*100);
fprintf('�ռ������ʣ�\t%5.3f %%\n',PV*100);
fprintf('�ۺ������ʣ�\t%5.3f %%\n',gbest*100);
% fprintf('����ʱ�䣺\t\t%5.4f s\n',timecost);
% disp('ͼ��������...')

        depict( Scheme, 1,'r' )   %    ( �������������Ϊi���ӣ���ɫ�� ��ɫ��r\g\b\c\m\y\k\w
 end

%% ��ͼ
figure
plot(1:iter_max,Cost_best(1:iter_max),'b')
xlabel('��������')
ylabel('�ɱ�')
title('������С�ɱ��仯����ͼ')
% %% �ж����Ž��Ƿ�����ʱ�䴰Լ����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
 flag=Judge(bestVC,cap,demands,a,b,L,s,dist);
%% ������Ž����Ƿ����Ԫ�ض�ʧ���������ʧԪ�أ����û����Ϊ��
DEL=Judge_Del(bestVC);
figure
plot(1:iter_max,w_PPm_m(1:iter_max),'b')
xlabel('��������')
ylabel('�����')
title('���������ƽ���仯����ͼ')
figure
plot(1:m,w_PPm(1:m),'b')
xlabel('����')
ylabel('�����')
title('���һ�������ƽ���仯����ͼ')
toc