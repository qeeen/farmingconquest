function mapgen() constructor{
	randomize();
	
	g_map[0][0] = "";
	width = 72;
	height = 48;
	base_width = 8;
	base_height = 8;
	
	//obviously generates the actual map, which is stored in g_map
	// "C"s are neutral spaces, "B"s and "E"s are for each side, and "H"s basically mark the center of each section
	function create_map(){
		map_init();
		add_neutral();
		add_hallways();
	}

	//initializses the g_map, and adds the player bases
	function map_init(){
		//initialize the grid	
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				g_map[i][k] = " ";
			}
		}
	
		//create the 2 bases
		for(var k = 0; k < base_height; k++){
			for(var i = 0; i < base_width; i++){
				g_map[i][k + height/2 - base_height/2] = "B";
				if(i == base_width-1 && k == base_height/2){
					g_map[i][k + height/2 - base_height/2] = "H";
				}
			}
		}
		for(var k = 0; k < base_height; k++){
			for(var i = 0; i < base_width; i++){
				g_map[i + width-base_width][k + height/2 - base_height/2] = "E";
				if(i == 0 && k == base_height/2){
					g_map[i + width-base_width][k + height/2 - base_height/2] = "H";
				}
			}
		}

	}
	
	//adds all the neutral clusters to the map
	function add_neutral(){
		var c_size = 12;
		/*
		Essentially this checks every possible 12x12 (based on the cluster size) area within g_map, and marks which ones are completely empty
		afterwards it picks one at random, creates a cluster and places it that the chosen position
		this process is then repeated up to sixteen times, essentially ending once there are no more completely open 12x12 areas
		*/
		for(var n = 0; n < 16; n++){
			var options = ds_list_create();
			for(var mapy = 0; mapy < height - c_size; mapy++){
				for(var mapx = 0; mapx < width - c_size; mapx++){
					if(g_map[mapx][mapy] != " "){
						continue;
					}
					var found = true;
					for(var k = 0; k < c_size; k++){
						for(var i = 0; i < c_size; i++){
							if(g_map[mapx+i][mapy+k] != " "){
								found = false;
								break;
							}
						}
					}
					if(found){
						ds_list_add(options, [mapx, mapy]);
					}
				}
			}
			if(ds_list_size(options) == 0){
				break;
			}
			var start = options[| irandom_range(0, ds_list_size(options)-1)];
			var startx = start[0];
			var starty = start[1];
			
			var c = create_cluster();
			for(var k = 0; k < c_size; k++){
				for(var i = 0; i < c_size; i++){
					g_map[startx + i][starty + k] = c[i][k];
				}
			}
			g_map[startx + 6][starty + 6] = "H";
			
			ds_list_destroy(options);
		}
	}

	//this pretty simple takes each "H" or hook on the map, and connects it to its 2 closest hooks with a 3 tile wide line
	function add_hallways(){
		centers[0] = [0, 0];
		current_cent = 0;
		
		//find where each of the "H"s are located and store them in a list
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				if(g_map[i][k] == "H"){
					centers[current_cent] = [i, k];
					current_cent++;
				}
			}
		}
		
		//the process is run for each hook
		for(var i = 0; i < array_length(centers); i++){
			var shortest_coords = -1;
			var shortest_distance = -1;
			var sec_shortest_coords = -1;
			var sec_shortest_distance = -1;
			var x1 = centers[i][0];
			var y1 = centers[i][1];
			
			//for the current hook find the 2 closest ones
			for(var k = 0; k < array_length(centers); k++){
				if(centers[i] == centers[k]){
					continue;
				}
				
				var x2 = centers[k][0];
				var y2 = centers[k][1];
				
				var c_distance = sqrt(sqr(x2-x1) + sqr(y2-y1));
				if(shortest_coords == -1 || shortest_distance > c_distance){
					sec_shortest_coords = shortest_coords;
					sec_shortest_distance = shortest_distance;
					shortest_coords = centers[k];
					shortest_distance = c_distance;
				}
				else if(sec_shortest_coords = -1 || sec_shortest_distance > c_distance){
					sec_shortest_coords = centers[k];
					sec_shortest_distance = c_distance;
				}
			}
			
			//draw a line between the current hook and the closest one
			var x2 = shortest_coords[0];
			var y2 = shortest_coords[1];
			for(var m = 0; m < 100; m++){
				new_pos_x = floor(lerp(x1, x2, m/100.0));
				new_pos_y = floor(lerp(y1, y2, m/100.0));
				
				if(g_map[new_pos_x][new_pos_y] != "H"){
					g_map[new_pos_x][new_pos_y] = "C";
				}
				if(g_map[new_pos_x+1][new_pos_y] != "H"){
					g_map[new_pos_x+1][new_pos_y] = "C";
				}
				if(g_map[new_pos_x][new_pos_y+1] != "H"){
					g_map[new_pos_x][new_pos_y+1] = "C";
				}
				if(g_map[new_pos_x+1][new_pos_y+1] != "H"){
					g_map[new_pos_x+1][new_pos_y+1] = "C";
				}
			}
			
			//draw a line between the current hook and the second closest one
			x2 = sec_shortest_coords[0];
			y2 = sec_shortest_coords[1];
			for(var m = 0; m < 100; m++){
				new_pos_x = floor(lerp(x1, x2, m/100.0));
				new_pos_y = floor(lerp(y1, y2, m/100.0));
				
				if(g_map[new_pos_x][new_pos_y] != "H"){
					g_map[new_pos_x][new_pos_y] = "C";
				}
				if(g_map[new_pos_x+1][new_pos_y] != "H"){
					g_map[new_pos_x+1][new_pos_y] = "C";
				}
				if(g_map[new_pos_x][new_pos_y+1] != "H"){
					g_map[new_pos_x][new_pos_y+1] = "C";
				}
				if(g_map[new_pos_x+1][new_pos_y+1] != "H"){
					g_map[new_pos_x+1][new_pos_y+1] = "C";
				}
			}
		}
	}

	//creates a cluster to create the main sections of the map
	function create_cluster(){
		/*
		This creates a 12x12 area(can be modified), and places 3x3 and 2x2 squares within it at random
		it then for each empty position, checks all 8 adjacent positions and fills itself if it is adjacent to at least 4 via the smooth function(also subject to change)
		the 12x12 matrix is then returned
		*/
		var mini_w = 12;
		var mini_h = 12;
		mini_grid[0][0] = "";
		for(var k = 0; k < mini_h; k++){
			for(var i = 0; i < mini_w; i++){
				mini_grid[i][k] = "";
			}
		}
		
		var c_x = irandom_range(0, 10);
		var c_y = irandom_range(0, 10);
		for(var n = 0; n < 12; n++){
			var c_x = irandom_range(0, 10);
			var c_y = irandom_range(0, 10);
			mini_grid[c_x][c_y] = "C";
			mini_grid[c_x+1][c_y] = "C";
			mini_grid[c_x][c_y+1] = "C";
			mini_grid[c_x+1][c_y+1] = "C";
		}
		for(var n = 0; n < 8; n++){
			var c_x = irandom_range(0, 9);
			var c_y = irandom_range(0, 9);
			mini_grid[c_x][c_y] = "C";
			mini_grid[c_x+1][c_y] = "C";
			mini_grid[c_x][c_y+1] = "C";
			mini_grid[c_x+1][c_y+1] = "C";
			mini_grid[c_x+2][c_y] = "C";
			mini_grid[c_x][c_y+2] = "C";
			mini_grid[c_x+2][c_y+1] = "C";
			mini_grid[c_x+1][c_y+2] = "C";
			mini_grid[c_x+2][c_y+2] = "C";
		}
		return smooth(mini_grid);
	}

	//look above, extension of "create_cluster()"
	function smooth(data){
		new_data[0][0] = "";
		data_width = array_length(data);
		data_height = array_length(data[0]);
		for(var k = 0; k < data_height; k++){
			for(var i = 0; i < data_width; i++){
				new_data[i][k] = data[i][k];
			}
		}
		for(var k = 0; k < data_height; k++){
			for(var i = 0; i < data_width; i++){
				if(data[i][k] == ""){
					adjs = [0, 0, 0, 0, 0, 0, 0, 0, 0];
					if(i == 0){
						adjs[0] = -1;
						adjs[3] = -1;
						adjs[6] = -1;
					}
					if(i == data_width-1){
						adjs[2] = -1;
						adjs[5] = -1;
						adjs[8] = -1;
					}
					if(k == 0){
						adjs[0] = -1;
						adjs[1] = -1;
						adjs[2] = -1;
					}
					if(k == data_height-1){
						adjs[6] = -1;
						adjs[7] = -1;
						adjs[8] = -1;
					}
					
					if(adjs[0] != -1){
						adjs[0] = data[i-1][k-1] == "C" ? 1 : 0;
					}
					if(adjs[1] != -1){
						adjs[1] = data[i][k-1] == "C" ? 1 : 0;
					}
					if(adjs[2] != -1){
						adjs[2] = data[i+1][k-1] == "C" ? 1 : 0;
					}
					if(adjs[3] != -1){
						adjs[3] = data[i-1][k] == "C" ? 1 : 0;
					}
					if(adjs[5] != -1){
						adjs[5] = data[i+1][k] == "C" ? 1 : 0;
					}
					if(adjs[6] != -1){
						adjs[6] = data[i-1][k+1] == "C" ? 1 : 0;
					}
					if(adjs[7] != -1){
						adjs[7] = data[i][k+1] == "C" ? 1 : 0;
					}
					if(adjs[8] != -1){
						adjs[8] = data[i+1][k+1] == "C" ? 1 : 0;
					}
					
					var sum = 0;
					for(var m = 0; m < 9; m++){
						if(adjs[m] == -1)
							continue;
						sum += adjs[m];
					}
					if(sum >= 4){
						new_data[i][k] = "C";
					}
				}
			}
		}
		
		return new_data;
	}
	
	//draws the grid to text, for debugging
	function draw_the_grid(){
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				draw_text(i*16 + 100, k*16, g_map[i][k]);
			}
		}
	}
}