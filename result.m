function  result( Scheme, k )
global num_box;

fprintf('\nװ�䷽�����£�');
for i=1:num_box
    fprintf('\n\n����%d�ڵĻ���Ϊ��\n',i);
    count=0;
    for j=1:size(Scheme,2)
        if Scheme(i,j)~=0
             count=count+1;
             fprintf('%d\t',Scheme(i,j));
            if mod(count,k)==0
                fprintf('\n');
                count=0;
            end
        else
            break;
        end
    end
end

end

