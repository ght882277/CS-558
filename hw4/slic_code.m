function res = slic_code(path)
    % 1. init
    b=50;
    img=imread(path);
    img=single(img);
    h=size(img,1);
    w=size(img,2);
    hn=ceil(h/b);
    wn=ceil(w/b);
    d=5;
    centers=zeros(hn, wn ,d);
    oldCenters = uint8(centers);
    for i=1:hn
        x=b/2+b*(i-1);
        x=min(x,h);
        for j=1:wn
            y=b/2+b*(j-1);
            y=min(y,w);
            centers(i,j,:)=[x y squeeze(img(x,y,:)).'];
        end
    end
    belongTo=ones(h,w,2);
    for i=1:h
        for j=1:w
            belongTo(i,j,1)=floor(i/b)+1;
            belongTo(i,j,2)=floor(j/b)+1;
        end
    end
    ifEnd=false;
    maxIters=3;
    iter=1;
    ws=3;
    
    while ~ifEnd && iter <= maxIters
        centers=single(centers);
        % 2. local shift
        for i=2:hn-1
            for j=2:wn-1
                minDis = 9999999;
                minX = -1;
                minY = -1;
                window=zeros(ws,ws);
                for x = -1:1
                    for y = -1:1
                        window(x+2,y+2) = grad(centers(i,j,1)+x,centers(i,j,2)+y,img);
                        if window(x+2,y+2) < minDis
                            minDis = window(x+2,y+2);
                            minX=x;
                            minY=y;
                        end
                    end
                end
                newX = centers(i,j,1)+minX-2;
                newY = centers(i,j,2)+minY-2;
                centers(i,j,:)=[newX newY squeeze(img(newX,newY,:)).'];
            end
        end
        % 3. centroid update
        for i=1:h
            for j=1:w
                minDis = 99999999;
                for k=1:hn
                    for l=1:wn
                        c=centers(k,l,:);
                        %4. optional
                        if(c(1)-i>2*b||c(1)-i<-2*b||c(2)-j>2*b||c(2)-j<-2*b)
                            continue
                        end
                        dis=norm([i/2 j/2 squeeze(img(i,j,:)).']-[c(1)/2 c(2)/2 c(3) c(4) c(5)]);
                        if(dis<minDis)
                            minDis=dis;
                            belongTo(i,j,1)=k;
                            belongTo(i,j,2)=l;
                        end
                    end
                end
                
            end
        end
        
        % judge converge
        centers=uint8(centers);
        if isequal(centers, oldCenters)
            ifEnd=true;
        end
        oldCenters=centers;
        
        % 5. iter
        iter=iter+1;
    end
    % paint black
    for i=1:h-1
        for j=1:w-1
            if belongTo(i,j,1)==belongTo(i+1,j+1,1)&&belongTo(i,j,2)==belongTo(i+1,j+1,2)
                c=centers(belongTo(i,j,1), belongTo(i,j,2), :);
                img(i,j,:)=c(3:d);
            else
                img(i,j,:)=[0 0 0];
            end
            
        end
    end
    % 6. output
    res=uint8(img);
end

function g = grad(x,y,img)
    g = norm([norm(img(x+1,y,1)-img(x-1,y,1),img(x,y+1,1)-img(x,y-1,1)),norm(img(x+1,y,2)-img(x-1,y,2),img(x,y+1,2)-img(x,y-1,2)),norm(img(x+1,y,3)-img(x-1,y,3),img(x,y+1,3)-img(x,y-1,3))]);
end