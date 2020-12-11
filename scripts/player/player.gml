function player(_ob, _x, _y) : living(_ob, _x, _y) constructor{
	function input(){
		k_r = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
		k_l = keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"));
		k_d = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
		k_u = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
		
		var dir = -1;
		if(k_r)
			dir = 0;
		if(k_l)
			dir = 2;
		if(k_d)
			dir = 1;
		if(k_u)
			dir = 3;
		
		if(dir != -1)
			request("move", [dir, 1]);
		else
			request("stay", -1);
	}
	
}