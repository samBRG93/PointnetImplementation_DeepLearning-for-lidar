function problema = CheckGround(TreeCHM,Terrain,DSM,CHM,ID)
 %% check ground
%     DSM(CHM(:,3)<0,:)=[];
%     CHM(CHM(:,3)<0,:)=[];
    Ground = Terrain(Terrain(:,6)==2,:); %% ground 
    Ground = sortrows(Ground,3);
    Hdiff = [0;diff(Ground(:,3))];
    Ground(Hdiff>0.3,:)=[];

    DSM = DSM(DSM(:,3)>max(Ground(:,3)),:);

    %% subract ground
    if isempty(DSM)==1
        problema = 1;
        DSM=CHM;
    else
        DSM(:,3) = DSM(:,3)-max(Ground(:,3));
        HDiff = max(CHM(:,3))-max(DSM(:,3));
        DSM(:,3) = DSM(:,3)+HDiff;
        DSM=[DSM;CHM(CHM(:,3)<=HDiff,:)];
        problema=0;
    end
    
    DSM(DSM(:,3)<0,:)=[];
    dlmwrite([  num2str(ID) '.txt'],DSM,'delimiter',' ','precision',10);
    system(['txt2las -parse xyzrics '    num2str(ID) '.txt -o ' TreeCHM  num2str(ID) '.las'] );
  

end

