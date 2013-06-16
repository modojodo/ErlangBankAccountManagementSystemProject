-module(current).
-compile(export_all).
-include("records.hrl").
init_current()->
ets:new(current,[named_table,set,{keypos, #account.cnic}]).

new()->
Str="",
First=io:get_line("Enter your first name:"),
First_ex=accounts:filter_getline(First,Str),
Last=io:get_line("Enter your last name: "),
Last_ex=accounts:filter_getline(Last,Str),
Address=io:get_line("Enter your address:"),
Address_ex=accounts:filter_getline(Address,Str),
First_with_space=string:concat(First_ex," "),
Full=string:concat(First_with_space,Last_ex),
Id=io:read("Enter your CNIC number:\n "),
Id_ex=accounts:filter_read(Id),

accounts:check_status(ets:insert(current, #account{cnic=Id_ex, name=Full, address=Address_ex, date=date() , time=time() })),
Return=hd(io:get_line("|Press 'b' to back to the MAIN MENU     |\n|Press 'c' to continue creating accounts|\n|Press 'q' to quit					   |\n")),	
case Return of 
		$b->accounts:start();
		$B->accounts:start();
		$c->accounts:create();
		$C->accounts:create();
		$q->accounts:quit();
		$Q->accounts:quit()
	end.

