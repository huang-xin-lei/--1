function [ scheme ] = transform( solution )
%TRANSFORM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global num_cargo;
global num_box;

MostNumCargo=max(histc(solution,num_box));
scheme=zeros(num_box,MostNumCargo);
countcargo=ones(1,num_box);
for i=1:num_cargo
    index=solution(i);
 scheme(index,countcargo(index))=i;
 countcargo(index)=countcargo(index)+1;
end

end

