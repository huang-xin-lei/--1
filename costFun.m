%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ����һ�����ͷ������ܳɱ�=cd*����ʹ����Ŀ+ct*������ʻ�ܾ���
%����VC��          ���ͷ���
%����dist��        �������
%���cost��        �ܳɱ�
%���NV��          ����ʹ����Ŀ
function [cost,NV,TD,ff,c_11,w_ppm,w_pp]=costFun(VC,dist,Q_U,w_pp)
NV=size(VC,1);                      %����ʹ����Ŀ
TD=travel_distance(VC,dist);        %��ʻ�ܾ���
ff=mean(Q_U)*TD;%������
u=30;%̼˰
w=2.669;%̼�ŷ�ϵ��
cost=150*NV+NV*ff*5.41+NV*u*w*ff;%�̶��ɱ�+�ͺĳɱ�+̼˰�ɱ���150 �����̶��ɱ���5.41 �ͼ�
c_11=NV*w*ff; %̼�ŷ���
w_ppm=mean(w_pp);%ƽ�������
if w_ppm>1
    w_ppm=1;
end
end