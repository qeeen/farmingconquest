function entity(_ob, _x, _y) constructor{
	ob = _ob;
	posx = _x;
	posy = _y;
	last_posx = _x;
	last_posy = _y;
	requests = ds_queue_create();
	ent_state = "idle"
	
	function step(){
		input();
		do_requests();
	}
	
	function request(req, args){
		ds_queue_enqueue(requests, [req, args]);
	}
	
	function do_requests(){
		while(!ds_queue_empty(requests)){
			var req = ds_queue_dequeue(requests);
			var the_request = req[0];
			var args = req[1];
			
			req_switch(the_request, args);
		}
	}
	
	function req_switch(the_request, args){
	}
}      

function living(_ob, _x, _y) : entity(_ob, _x, _y) constructor{
	function input(){
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

function player(_ob, _x, _y) : living(_ob, _x, _y) constructor{
	function input(){
		k_r = keyboard_check_pressed(vk_right);
		k_l = keyboard_check_pressed(vk_left);
		k_d = keyboard_check_pressed(vk_down);
		k_u = keyboard_check_pressed(vk_up);
		k_r2 = keyboard_check_pressed(ord("D"));
		k_l2 = keyboard_check_pressed(ord("A"));
		k_d2 = keyboard_check_pressed(ord("S"));
		k_u2 = keyboard_check_pressed(ord("W"));
		
		var dir = -1;
		if(k_r || k_r2)
			dir = 0;
		if(k_l || k_l2)
			dir = 2;
		if(k_d || k_d2)
			dir = 1;
		if(k_u || k_u2)
			dir = 3;
		
		if(dir != -1)
			request("move", [dir, 1]);
		else
			request("stay", -1);
	}
	
}