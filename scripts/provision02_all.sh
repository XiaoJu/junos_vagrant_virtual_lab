configure
set policy-options policy-statement RIP term 1 from protocol direct
set policy-options policy-statement RIP term 1 from protocol rip       
set policy-options policy-statement RIP then accept                 
set protocols rip group RIPGROUP export RIP
commit and-quit
