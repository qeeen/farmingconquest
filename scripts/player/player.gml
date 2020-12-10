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