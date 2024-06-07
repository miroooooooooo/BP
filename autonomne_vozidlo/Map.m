classdef Map
    %   Trieda mapy, ktora sluzi na trenovanie ako aj testovanie
    %   automobilu. Vstupnymi arugmentami je varianta mapy 3, 5 ->
    %   trenovacie mapy, 4, 6 -> testovacie mapy

    properties
        image
        bwImage
        map
        mapSize = 0;
        scale = 1;
        checkpoints = [];
        finish = []
        checkpointCount = 0;
        checkpointsEdges = [];
        maxSteps = 0;

        % starting positions for a car on a map
        startX
        startY
        startAngle
    end


    methods
        function obj = Map(variant)
            obj = obj.getMapProperties(variant);
        end

        function obj = getMapProperties(obj, variant)
            scale = 1;
            path = "CIRCUITS\";
            switch variant
%                 case 1
%                     img = path+"O.png";
%                     obj.startX = 55 / scale;
%                     obj.startY = 70 / scale;
%                     obj.maxSteps = 250 * scale;
%                     obj.anlge = 0;
%                     finish = [47 49 49 47 47, 66 66 80 80 66] / scale;
%                     checkpoints = [[61 63 63 61 61] [66 66 80 80 66];
%                         [75 77 77 75 75] [66 66 80 80 66];
%                         [82 82 94 94 82] [64 62 62 64 64];
%                         [82 82 94 94 82] [50 52 52 50 50];
%                         [82 82 94 94 82] [36 38 38 36 36];
%                         [75 77 77 75 75] [18 18 32 32 18];
%                         [61 63 63 61 61] [18 18 32 32 18];
%                         [47 49 49 47 47] [18 18 32 32 18];
%                         [33 35 35 33 33] [18 18 32 32 18];
%                         [20 22 22 20 20] [18 18 34 34 18];
%                         [8 8 20 20 8]    [38 36 36 38 38];
%                         [8 8 20 20 8]    [52 50 50 52 52];
%                         [8 8 20 20 8]    [64 62 62 64 64];
%                         [22 24 24 22 22] [66 66 80 80 66];
%                         [34 36 36 34 34] [66 66 80 80 66]] / scale;
%                 case 2
%                     %ZigZagRoad
%                     img = path+"ZigZagRoad.png";
%                     obj.startX = 12 * scale;
%                     obj.startY = 5 * scale;
%                     obj.startAngle = 0;
%                     obj.maxSteps = round(10000 * scale);
%                     finish = [148   156   156   148   148,   145   145   147   147   145] * scale;
%                     checkpoints =   [30	31	31	30	30	1	1	9	9	1;
%                                     42	42	50	50	42	21	22	22	21	21;
%                                     60	61	61	60	60	30	30	38	38	30;
%                                     85	86	86	85	85	30	30	38	38	30;
%                                     86	85	85	86	86	51	51	59	59	51;
%                                     61	61	69	69	61	63.5	64.5	64.5	63.5	63.5;
%                                     53.5	52.5	52.5	53.5	53.5	82	82	90	90	82;
%                                     42	42	50	50	42	110	111	111	110	110;
%                                     67.5	68.5	68.5	67.5	67.5	131	131	139	139	131;
%                                     95	96	96	95	95	113	113	121	121	113;
%                                     140	141	141	140	140	113	113	121	121	113]  * scale;
                case 3
                    img = path+"bigMap.png";
                    obj.startX = 70 * scale;
                    obj.startY = 30 * scale;
                    obj.startAngle = 0;
                    obj.maxSteps = round(700 * scale);
                    finish = [311 311 343 343 311, 100 90 90 100 100] / scale;
                    checkpoints = [120 130 130 120 120, 46 46 14 14 46;
                                   180 190 190 180 180, 46 46 14 14 46;
                                   190 180 180 190 190, 75 75 107 107 75;
                                   130 120 120 130 130, 75 75 107 107 75;
                                   78 78 110 110 78, 157 167 167 157 157;
                                   78 78 110 110 78, 217 227 227 217 217;
                                   120 130 130 120 120, 255 255 287 287 255;
                                   180 190 190 180 180, 226 226 194 194 226;
                                   240 250 250 240 240, 226 226 194 194 226;
                                   250 240 240 250 250, 257 257 289 289 257;
                                   240 250 250 240 240, 318 318 350 350 318;
                                   300 310 310 300 300, 318 318 350 350 318;
                                   311 311 343 343 311, 278 268 268 278 278;
                                   311 311 343 343 311, 218 208 208 218 218;
                                   311 311 343 343 311, 158 148 148 158 158;];
                case 4
                    img = path+"bigMap3.png";
                    obj.startX = 200 * scale;
                    obj.startY = 50 * scale;
                    obj.startAngle = pi/3;
                    obj.maxSteps = round(1000 * scale);
                    finish = [330 340 340 330 330, 340 340 372 372 340] / scale;
                    checkpoints = [];  
%                     checkpoints = [220 230 230 220 220,  73 73 41 41 73;
%                                    237 237 269 269 237, 120 130 130 120 120;
%                                    298 298 330 330 298, 190 200 200 190 190;
%                                    248 238 238 248 248, 234 234 202 202 234;
%                                    188 178 178 188 188, 234 234 202 202 234;
%                                    117 117 149 149 117, 200 190 190 200 200;
%                                    117 117 149 149 117, 140 130 130 140 140;
%                                    69 69 101 101 69, 130 140 140 130 130;
%                                    69 69 101 101 69, 190 200 200 190 190;
%                                    69 69 101 101 69, 250 260 260 250 250;
%                                    133 133 165 165 133, 308 318 318 308 308;
%                                    205 215 205 195 205, 365 363 331 334 365;
%                                    245 255 255 245 245, 313 313 281 281 313;];
                case 5
                    img = path+"bigMap4.png";
                    obj.startX = 207 * scale;
                    obj.startY = 30 * scale;
                    obj.startAngle = -pi;
                    obj.maxSteps = round(1000 * scale);
                    finish = [327   337   337   327   327, 336 336 368 368 336] / scale;
                    checkpoints = [ 184   184   152   152   184    57    67    67    57    57
                                    89    89   121   121    89   120   130   130   120   120
                                   127   137   137   127   127   209   209   177   177   209
                                   185   195   195   185   185   256   256   225   225   256
                                   257   267   267   257   257   209   209   177   177   209
                                   327   327   359   359   327   220   230   230   220   220
                                   257   247   247   257   257   273   273   305   305   273
                                   137   127   127   137   137   273   273   305   305   273
                                   127   137   137   127   127   336   336   368   368   336
                                   247   257   257   247   247   336   336   368   368   336];
                case 6
                    img = path+"bigMap5.png";
                    obj.startX = 100 * scale;
                    obj.startY = 290 * scale;
                    obj.startAngle = 0;
                    obj.maxSteps = round(1000 * scale);
                    finish = [300 310 310 300 300, 33 33 65 65 33];
                    checkpoints = [];

                otherwise
                    error("The selected map does not exist!");
            end

            obj = obj.processImage(img);
            obj = obj.rescaleMap(scale);
            obj = obj.insertCheckpoints(checkpoints);
            obj = obj.insertFinish(finish);
        end
        
        % zvacsenie alebo zmensenie mapy
        function obj = rescaleMap(obj, scale)
            obj.image = imresize(obj.image, scale);
            map = imresize(obj.bwImage, scale);
            obj.mapSize = length(map);
            obj.map = createMap(map);
        end
        
        % Pridanie checkpointov
        function obj = insertCheckpoints(obj, checkpoints)
            if ~isempty(checkpoints)
                obj.checkpoints = checkpoints;
                obj.checkpointCount = length(checkpoints(:,1));
            end
        end

        % Vykreslenie checkpointov
        function drawCheckpoints(obj)
            for i = 1:obj.checkpointCount
                obj.checkpointsEdges(i, :) = [obj.checkpoints(i, 1) obj.checkpoints(i,6) obj.checkpoints(i, 4) obj.checkpoints(i,9)];
                fill(obj.checkpoints(i,1:5), obj.checkpoints(i, 6:end),'g', 'FaceAlpha', 0.2)
                plot([obj.checkpointsEdges(i,1) obj.checkpointsEdges(i,3)], [obj.checkpointsEdges(i,2) obj.checkpointsEdges(i,4)], 'Color', 'r' ,'LineWidth', 2)
            end

        end
        
        % Vykreslenie ciela
        function drawFinish(obj)
            finishEdges(:) = [obj.finish(1, 1) obj.finish(1,6) obj.finish(1, 4) obj.finish(1,9)];
            fill(obj.finish(1, 1:5), obj.finish(1, 6:end),'b')
            plot([finishEdges(1,1) finishEdges(1,3)], [finishEdges(1,2) finishEdges(1,4)], 'r', 'LineWidth', 2)
        end

        % Pridanie ciela
        function obj = insertFinish(obj, finish)
            if ~isempty(finish)
                obj.finish = finish;
            end
        end

        % Kontrola, ci objekt auta nabural alebo nie
        function occupancy = checkOccupancy(obj, car, pose) 
            occupancy = getOccupancy(obj.map, [pose(1), pose(2)]) || ...
            getOccupancy(obj.map, [pose(1)+car.carWidth/2, pose(2)]) || ...
            getOccupancy(obj.map, [pose(1)-car.carWidth/2, pose(2)]) || ...
            getOccupancy(obj.map, [pose(1)+car.carWidth/2, pose(2)-car.carLength])|| ...
            getOccupancy(obj.map, [pose(1)-car.carWidth/2, pose(2)-car.carLength]);
        end
        
        % Kontrola ci sme v ceily
        function finished = checkFinish(obj, pose)
            finished = 0;

            PX = pose(1);
            PY = pose(2);

            [in, on] = inpolygon(PX, PY, obj.finish(1,1:5), obj.finish(1, 6:end));

            if (in > 0 || on > 0)
                finished = 1;
            end
        end
        
        % Kontrola ci sme vo vnutri mapy
        function inside = checkInside(obj, pose)
            inside = 0;
            if pose(1) >= obj.mapSize || pose(1) <= 0
                inside = 1;
            end
            if pose(2) >= obj.mapSize || pose(2) <= 0
                inside = 1;
            end
        end

        % Kontrola ci sme presli checkpointom
        function [checkpointSol] = checkCheckpoints(obj, pose, checkpointsReached)
            PX = pose(1);
            PY = pose(2);
            checkpointSol = 0;
            finishLeft = 0;

            for chpt = 1:length(obj.checkpoints(:,1))
                nextChpt = checkpointsReached + 1; % Nasledujuci checkpoint

                if nextChpt <= obj.checkpointCount
                    checkpoint = obj.checkpoints(chpt, :); % Aktualny checkpoint
                elseif nextChpt == obj.checkpointCount + 1
                    checkpoint = obj.finish;
                    finishLeft = 1;
                end
                if nextChpt <= obj.checkpointCount + 1
                    [in, on] = inpolygon(PX, PY, checkpoint(1,1:5), checkpoint(1, 6:end));
    
                    if (in > 0 || on > 0) && ((nextChpt) == chpt || finishLeft == 1)
                        checkpointSol = 1;
                    elseif (in > 0 || on > 0)
                        checkpointSol = 2;
                    end
                end
            end
        end
        
        % Spracovanie obrazku mapy
        function obj = processImage(obj, image)
            obj.image = imread(image);
            grayImage = rgb2gray(obj.image);
            obj.bwImage = grayImage > 123;
            obj.image = flip(obj.image, 1); %  Potrebujeme ich flipnut pretoze objekt Image ma reverznu y-ovu os
        end

    end

    methods (Static)
    end
end

function map = createMap(map)
    map = binaryOccupancyMap(map);
end

