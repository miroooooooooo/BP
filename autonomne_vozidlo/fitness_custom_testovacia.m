function [fit, checkpointsReached, fitSep] = fitness_custom(nn, map, car, popIndex, geneIndex)

    fitFinish = 0;
    fitChpt = 0;
    fitInside = 0;
    fitPose = 0;
    fit = 0;

    pose = [car.carPosition car.headingAngle];
    step = 0;
    checkpointsReached = 0;

    [nn, weights] = nn.convertWeights(popIndex, geneIndex);


    while step < map.maxSteps
        step = step + 1; % priratavanie kroku

        if map.checkFinish(pose)% &&  (map.checkpointCount + 1) == checkpointsReached
            fitFinish = -2e3; % ak presiel automobil checkpoint, dostane odmenu
            break;
        end
        [radarReadings, cameraReadings] = car.getSensorReadings();
        
        if ~car.checkInsidePosition(pose) % kontrola ci je automobil na mape
            fitInside = inf; % ak je automobil mimo mapy tak dostane pokutu, ktora ho zabije
            break;
        end

        [out] = nn.evaluateOutput([radarReadings, car.speed / car.multiplyParameters], [pi/4], weights, popIndex, geneIndex); % get output angle

        car = car.update(out(1), out(2));
        pose = [car.carPosition, car.headingAngle];

        checkpointsRemaining = map.checkpointCount - checkpointsReached;

        currentPosition = car.getCarOccupancy(0);

        fitPose = fitPose + 1e3 * currentPosition;
        if currentPosition >= 6
            break;
        end
    end


    format long
    fit = step + fitPose + fitInside + fitChpt + fitFinish;

    fitSep =  [fitPose, step, fitChpt, fitFinish, fitInside, fit, checkpointsReached];
end


