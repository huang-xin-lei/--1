function [final_solution,gbest]=GENE(pop,maxite,num_cargo,pm,box)
n=pop;
ger=maxite;
dim=num_cargo;
pm;
% n-- ��Ⱥ��ģ% ger-- ����������%pm-- �������
% v-- ��ʼ��Ⱥ����ģΪn��% fit-- ��Ӧ������


global num_box;


% ���ɳ�ʼ��Ⱥ
for i=1:n
    v(i,:)= fix((num_box)*rand(1,dim))+1; 
    Scheme=transform(v(i,:));                     %��ת���ɡ����䣺�����Ӧ����ʽ
    [feas_solution,Scheme]= placement(Scheme,box);             %װ�䴦��
    [PG,PV,pbest ]= evaluate(feas_solution) ;      %������Ӧ��
    fit(i)=pbest;
end

[gbest, index] = max(fit);
    for i=1:n
        v2(i,:) = v(index,:);
    end
    
[N,L]=size(v);           %�õ���ʼ��ģ�У���

it=1; % ����������
% ��ʼ����
while it<=ger 
    
    %ѡ����ѱ�������    
    for i=1:n
        if i~=index
            if rand > pm    % ����
                begin = 1 + fix(rand*dim);
                stop = begin + fix((dim-begin)*rand);
                v2(i,begin:stop) = v(i,begin:stop);
                
            else            % ����
                begin = 1 + fix(rand*dim);
                stop = begin + fix((dim-begin)*rand);
                v2(i,begin:stop)=fix(rand(1,(stop-begin+1))*num_box)+1;
            end
        else
            continue;
        end
         final_solution=v2(1,:);
        Scheme=transform(v2(i,:));                   
        [feas_solution,Scheme]= placement(Scheme,box);             
        [PG,PV,fit(i) ]= evaluate(feas_solution) ;      
        if fit(i) > gbest
            gbest = fit(i);
            index = i;
            final_solution = v2(i,:);
        else
           
        end
            
    end
    
    v=v2;   %����
    for i=1:n
        v2(i,:) = v(index,:);
    end
    
    it=it+1;            
end      

