 function living(_ob, _x, _y) : entity(_ob, _x, _y) constructor{
	function input() {
	}
	
	function req_switch(the_request, args){
		switch(the_request){
				case "stay":
					ob.x = posx*16;
					ob.y = posy*16;
					break;
				case "move":
					last_posx = posx;
					last_posy = posy;
				
					switch(args[0]){
						case 0:
							posx += args[1];
							break;
						case 1:
							posy += args[1];
							break;
						case 2:
							posx -= args[1];
							break;
						case 3:
							posy -= args[1];
							break;
					}
					
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