//startNode and endNode should both be integers
function BFS_shortest_path(startNode, endNode){
	var grid = array_create(ds_list_size(the_grid.grid));
	var queue = ds_list_create();
	ds_list_add(queue, startNode);
	var visited = array_create(ds_list_size(the_grid.grid));
	var parentsList = array_create(ds_list_size(the_grid.grid));

	//Create an array from the grid that marks 1 as traversable spaces and 0 as barriers.
	for (var i = 0; i < array_length(grid); i++) {
		if (ds_list_find_value(the_grid.grid, i) == noone) {
			grid[i] = 1;
		} else {
			grid[i] = 0;
		}
	}
	
	//set all of parentsList to -1
    for (var i = 0; i < array_length(parentsList); i++) {
        parentsList[i] = -1;
    }
	
	//set all of visited to false
	for (var i = 0; i < array_length(visited); i++) {
		visited[i] = false;
	}
	visited[startNode] = true;
	
	var queueIndex = 0;
	var currentNode = startNode;
	while (visited[endNode] == false) {
		
		//Check if the node to the right of the current node is within the bounds of the grid
        if ((currentNode + 1) % 5 < 5) {
            //check if the node to the right of the current node is a space and not a wall
            if (grid[currentNode + 1] == 1) {
                //check if the node to the right of the current node has been visited
                if (visited[currentNode + 1] == false) {
                    //if all the above conditions are met, add the node to the right of the current node to the queue
                    ds_list_add(queue, currentNode + 1);
                    visited[currentNode + 1] = true;
                    parentsList[currentNode + 1] = currentNode;
                }
            }
        }
		
		//Check if the node to the left of the current node is within the bounds of the grid
        if ((currentNode - 1) % 5 != 4) {
            //check if the node to the left of the current node is a space and not a wall
            if (grid[currentNode - 1] == 1) {
                //check if the node to the left of the current node has been visited
                if (visited[currentNode - 1] == false) {
                    //if all the above conditions are met, add the node to the left of the current node to the queue
                    ds_list_add(queue, currentNode - 1);
                    visited[currentNode - 1] = true;
                    parentsList[currentNode - 1] = currentNode;
                }
            }
        }
		
		//Check if the node below the current node is within the bounds of the grid
        if (currentNode + 5 < array_length(grid)) {
            //check if the node below the current node is a space and not a wall
            if (grid[currentNode + 5] == 1) {
                //check if the node below the current node has been visited
                if (visited[currentNode + 5] == false) {
                    //if all the above conditions are met, add the node below the current node to the queue
                    ds_list_add(queue, currentNode + 5);
                    visited[currentNode + 5] = true;
                    parentsList[currentNode + 5] = currentNode;
                }
            }
        }
		
		//Check if the node above the current node is within the bounds of the grid
        if (currentNode - 5 > 0) {
            //check if the node above the current node is a space and not a wall
            if (grid[currentNode - 5] == 1) {
                //check if the node above the current node has been visited
                if (visited[currentNode - 5] == false) {
                    //if all the above conditions are met, add the node above the current node to the queue
                    ds_list_add(queue, currentNode - 5);
                    visited[currentNode - 5] = true;
                    parentsList[currentNode - 5] = currentNode;
                }
            }
        }
		
		
        if (queueIndex + 1 < ds_list_size(queue)) {
            queueIndex++;
			currentNode = ds_list_find_value(queue, queueIndex);
        } 
		else {
            return noone;
        }
		
	}
	
	//reconstruct the shortest route from startNode to endNode using parentsList (Note: it is in opposite order)
        currentNode = endNode;
		var shortestPath = ds_list_create();
		ds_list_add(shortestPath, endNode);
        while (currentNode != startNode) {
			ds_list_add(shortestPath, parentsList[currentNode]);
            currentNode = parentsList[currentNode];
        }
		
	//Reverse the shortestPath DS List, as it is in opposite order, and convert the DS List to an array.
    var shortestPathArray = array_create(ds_list_size(shortestPath));
    for (var i = 0; i < array_length(shortestPathArray); i++) {
        shortestPathArray[(array_length(shortestPathArray) - 1) - i] = ds_list_find_value(shortestPath, i);
    }
	
	var s = "Shortest Path: "
	for (var i = 0; i < array_length(shortestPathArray); i++) {
		s = s + shortestPathArray[i] + " ";
	}
	draw_text(20, 20, s);
	
	return shortestPathArray;
	
} 