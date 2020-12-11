function mapgen() constructor{
	randomize();
	
	g_map[0][0] = "";
	width = 72;
	height = 48;
	base_width = 8;
	base_height = 8;
	
	function create_map(){
		map_init();
		add_neutral();
		add_hallways();
		//print_the_grid()
	}

	function map_init(){
		//initialize the grid	
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				g_map[i][k] = " ";
			}
		}
	
		//create the bases
		for(var k = 0; k < base_height; k++){
			for(var i = 0; i < base_width; i++){
				g_map[i][k + height/2 - base_height/2] = "B";
			}
		}
	
		for(var k = 0; k < base_height; k++){
			for(var i = 0; i < base_width; i++){
				g_map[i + width-base_width][k + height/2 - base_height/2] = "E";
			}
		}

	}
	
	function add_neutral(){
		for(var n = 0; n < 8; n++){
			var found = false;
			var startx = 0;
			var starty = 0
			while(!found){
				startx = irandom_range(0, width-1);
				starty = irandom_range(0, height-1);
				
				failed = false;
				for(var k = 0; k < 12; k++){
					for(var i = 0; i < 12; i++){
						if(i+startx >= width || k+starty >= height){
							failed = true;
							break;
						}
							
						if(g_map[i+startx][k+starty] != " "){
							failed = true;
							break;
						}
					}
				}
				if(!failed){
					found = true;
				}
			}
			
			var c = create_cluster();
			for(var k = 0; k < 12; k++){
				for(var i = 0; i < 12; i++){
					g_map[startx + i][starty + k] = c[i][k];
				}
			}
			g_map[startx + 6][starty + 6] = "H";
		}
		
		
	}

	function add_hallways(){
		centers[0] = [0, 0];
		current_cent = 0;
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				if(g_map[i][k] == "H"){
					centers[current_cent] = [i, k];
					current_cent++;
				}
			}
		}
		for(var i = 0; i < array_length(centers); i++){
			var shortest_coords = -1;
			var shortest_distance = -1;
			var x1 = centers[i][0];
			var y1 = centers[i][1];
			for(var k = 0; k < array_length(centers); k++){
				if(centers[i] == centers[k]){
					continue;
				}
				
				var x2 = centers[k][0];
				var y2 = centers[k][1];
				
				var c_distance = sqrt(sqr(x2-x1) + sqr(y2-y1));
				if(shortest_coords == -1 || shortest_distance > c_distance){
					shortest_coords = centers[k];
					shortest_distance = c_distance;
				}
			}
			
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
		}
	}

	function create_cluster(){
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

	function average(data){
		sum = 0.0;
		for(var k = 0; k < array_length(data[0]); k++){
			for(var i = 0; i < array_length(data); i++){
				sum += data[i][k];
			}
		}
		return sum/(array_length(data[0])*array_length(data));
	}

	function print_the_grid(){
		var str = "";
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				str = str + g_map[i][k];
			}
			str = str + "\n";
		}
		show_message(str);
	}
	
	function draw_the_grid(){
		for(var k = 0; k < height; k++){
			for(var i = 0; i < width; i++){
				draw_text(i*16, k*16, g_map[i][k]);
			}
		}
	}
}