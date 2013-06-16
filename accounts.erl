-module(accounts).
-compile(export_all).
-include("records.hrl").

start()->
P1=hd(io:get_line("Press 1 to create an account\nPress 2 to update an account\nPress 3 to delete an account\nPress 4 to deposit an amount\nPress 5 to withdraw an amount\n\nEnter your choice:")),
case P1 of
	$1->create();
	$2->update_choice();
	$3->delete_choice();
	$4->deposit_choice();
	$5->withdraw_choice()
end.

create()->
Acc_Type=hd(io:get_line("-----Press a to create current account------Press 'b' to create savings account\n\nEnter your choice:")),
case Acc_Type of
	$a->current:new(); 
	$A->current:new();
	$b->savings:new();
	$B->savings:new()
end.

update_choice()->
U1=hd(io:get_line("|-----------Enter your account type----------|\nPress 'a' for current account || Press 'b' for savings account\n\nEnter your choice:")),
case U1 of
	$a->update(current);
	$A->update(current);
	$b->update(savings);
	$B->update(savings)
end.

update(Table)->
T1=hd(io:get_line("What do you want to update?\na)Name\nb)Address\n\nEnter your choice:")),
case T1 of
	$a->update_name(Table);
	$A->update_name(Table);
	$b->update_address(Table);
	$B->update_address(Table)
end.

update_name(Table)->
Key=io:read("Enter your CNIC number:\n "),
Key_ex=filter_read(Key),
Str1="",
Name=io:get_line("Enter new name:"),
Name_ex=filter_getline(Name,Str1),
Stat=ets:update_element(Table, Key_ex, {3, Name_ex}),
check_update_status(Stat),
return().



update_address(Table)->
Key=io:read("Enter your CNIC number:\n "),
Key_ex=filter_read(Key),
Str1="",
Address=io:get_line("Enter new Address:"),
Address_ex=filter_getline(Address,Str1),
Stat=ets:update_element(Table, Key_ex, {4, Address_ex}),
check_update_status(Stat),
return().

delete_choice()->
D1=hd(io:get_line("|-----------Enter your account type----------|\nPress 'a' for current account || Press 'b' for savings account\n\nEnter your choice:")),
case D1 of
	$a->delete(current);
	$A->delete(current);
	$b->delete(savings);
	$B->delete(savings)
end.

delete(Table)->
Key=io:read("Enter your CNIC number:\n "),
Key_ex=filter_read(Key),
Stat=ets:delete(Table,Key_ex),
check_delete_status(Stat),
return().

deposit_choice()->
D=hd(io:get_line("|-----------Enter your account type----------|\nPress 'a' for current account || Press 'b' for savings account\n\nEnter your choice:")),
case D of
	$a->deposit(current);
	$A->deposit(current);
	$b->deposit(savings);
	$B->deposit(savings)
end.

deposit(Table)->
Key=io:read("Enter your CNIC number:\n "),
Key_ex=filter_read(Key),
Amount=io:read("Enter the amount to deposit:\n "),
Amount_ex=filter_read(Amount),
Old=ets:lookup_element(Table,Key_ex,7),
Stat=ets:update_element(Table, Key_ex, {7, Old+Amount_ex}),
check_deposit_status(Stat),
return().


withdraw_choice()->
W=hd(io:get_line("|-----------Enter your account type----------|\nPress 'a' for current account || Press 'b' for savings account\n\nEnter your choice:")),
case W of
	$a->withdraw(current);
	$A->withdraw(current);
	$b->withdraw(savings);
	$B->withdraw(savings)
end.

withdraw(Table)->
Key=io:read("Enter your CNIC number:\n "),
Key_ex=filter_read(Key),
Amount=io:read("Enter the amount to withdraw:\n "),
Amount_ex=filter_read(Amount),
Old=ets:lookup_element(Table,Key_ex,7),
Amount_Withdraw=check_withdraw(Amount_ex,Old),
Stat=ets:update_element(Table, Key_ex, {7, Old-Amount_Withdraw}),
check_withdraw_status(Stat),
return().
check_withdraw_status(Stat)->
case Stat of
	true-> io:format("Withdrawal succesfull !\n\n");
 	false-> io:format("Withdrawal failed !\n\n")
 end.


check_withdraw(Amount_ex,Old)->
if 
	Amount_ex>Old->io:format("Invalid Amount"),return();
	Amount_ex<0->io:format("Invalid Amount"),return();
	Amount_ex<Old,Amount_ex>0->Amount_ex
end.




check_deposit_status(Stat)->
case Stat of
	true-> io:format("Amount succesfully deposited !\n\n");
 	false-> io:format("Amount could not be deposited !\n\n")
 end.

check_delete_status(Stat)->
case Stat of
	true-> io:format("Account succesfully deleted !\n\n");
 	false-> io:format("Account deletion failed !\n\n")
 end.


check_update_status(Stat)->
case Stat of
	true-> io:format("Account succesfully updated !\n\n");
 	false-> io:format("Account updation failed !\n\n")
 end.

return()->
Return=hd(io:get_line("|Press 'b' to back to the MAIN MENU     |\n|Press 'q' to quit					   |\n")),	
case Return of 
		$b->start();
		$B->start();
		$q->quit();
		$Q->quit()
	end.


filter_read(R)->{ok,Input}=R, Input.
check_status(S)->
case S of
 true-> io:format("Account succesfully created !\n\n");
 false-> io:format("Account creation denied !\n\n")
end.

filter_getline(String , New)->[H|T]=String,
if 
 H /=$\n ->filter_getline(T,New++[H]);
 H==$\n->New
end.


quit()->io:format("** Thankyou for using :) ** ").