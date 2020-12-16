function animal(_ob, _x, _y) : living(_ob, _x, _y) constructor{
	
	selected = false;
	moving = false;
	
	//@Override
	function input() {
		if (mouse_check_button_pressed(mb_left) && collision_point(mouse_x, mouse_y, ob, false, false)) {
			if (!selected) {
				selected = true;
			} else {
				selected = false;
			}
		}
		
		if (mouse_check_button_pressed(mb_left) && selected) {
			gridx = ceil(mouse_x/16); 
			gridy = ceil(mouse_y/16);
			if (ds_list_size(the_grid.grid[| gridx + gridy*map_width]) == 0) {
				moving = true;
			}
		}
		
		if (moving) {
			request("move", [gridx, gridy]);
		} else {
			request("stay", -1);
		}
	}
	
	//@Override
	function req_switch(the_request, args){
		switch(the_request){
				case "stay":
					ob.x = posx*16;
					ob.y = posy*16;
					break;
				case "move":
					
				    
					last_posx = posx;
					last_posy = posy;
					
					ob.x = posx*16;
					ob.y = posy*16;
					
					var pos = the_grid.grid[| posx + posy*the_grid.map_width];
					ds_list_add(pos, ob);
					var old_pos = the_grid.grid[| last_posx + last_posy*the_grid.map_width];
					var old_ind = ds_list_find_index(old_pos, ob);
					ds_list_delete(old_pos, old_ind);
					
					break;
				case "stun":
					break;
		}
	}
	
	
}