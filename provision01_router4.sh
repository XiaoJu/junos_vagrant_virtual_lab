configure
set protocols rip group RIPGROUP neighbor ge-0/0/0.0 send none 
set protocols rip group RIPGROUP neighbor ge-0/0/1.0              
set protocols rip group RIPGROUP neighbor ge-0/0/2.0    
set protocols rip group RIPGROUP neighbor ge-0/0/3.0 send none 
commit and-quit
