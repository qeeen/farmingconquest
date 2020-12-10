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



