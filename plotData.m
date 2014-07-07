acts = unique(mappedLabel);
[s1 s2] = size(acts);
[s3 s4] = size(mappedData);
figure(1),hold on,
grid;
cmap = hsv(s1);
m2 = 1;
for m1 = 1:s1
    while(mappedLabel(m2,:) == acts(m1,:) && m2 < s3)
        plot3(mappedData(m2,1),mappedData(m2,2),mappedData(m2,3),'Color',cmap(m1,:),'marker','o');
%         text(reduced_datas(m2,1),reduced_datas(m2,2),reduced_datas(m2,3), num2str(label(m2,1)), 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','right');
        m2 = m2 + 1;
    end
end
