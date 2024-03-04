# Optimize AHKv2 for speed
Optimize AHKv2 Code for Speed
![image](https://github.com/samfisherirl/Compare-Code-Speed-AHKv2/assets/98753696/9c25c281-e2b4-44d6-8945-e971fad7e334)

Credits:
- original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
- WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
- jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
- lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413


I'm not going to try to rewrite the original post text, a lot of it is great and should be read from the source https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
Many of the conventions such as #NoEnv and #SetBatchLines are defunct, but the rest is very valuable. 
I have restructured the tests for ahkv2. 

tests include:
- a few tips for IF checking of Boolean values
- Avoid spreading math over multiple lines and using variable for intermediate results if they are only used once. As much as possible condense math into one line and only use variables for storing math results if you need the results being used multiple times later.
- Terinary
- Variable expressions


Commas and Combined lines aren't faster in v2; with caveats.
v2 Guide / Tutorial
Over the course of 3 months, I've learned some optimization tricks. After a deeper dive and some reflection, I've found I had some misconceptions on their transient ability in moving to AHKv2. I noticed a lot of this syntax in experienced community members' scripts, including mine, and I want to share what I've found.

If you have tricks or tips for faster code in ahkv2, please share. Always excited to learn and share.

All notes will come from this post regarding Optimizing ahkv1. ( and/or class libs for v2.) https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

If you want to replicate the tests, they can be found for v1 in the above post and v2 here https://github.com/samfisherirl/Compare-Code-Speed-GUI-AHKv2/tree/main/_speedTestScripts

None of this post describes results outside the bounds of the tests. There are use cases that are faster in v2 with combined lines, just a bit of hyperbole in the title.

My tool for testing is DLLCall query counter

all functions get run 55000 times, and a few reruns for insurance.

https://github.com/samfisherirl/Compare-Code-Speed-GUI-AHKv2

The tests
Defining variables by lines and commas
tests are shortened for brevity

;test 1
t1a := 1
t1b := 1
t1c := 1
t1d := 1

;test 2
 t2f := t2g := t2h := t2i := t2j := 1

;test3
t3a := 1, t3b := 1, t3c := 1, t3d := 1
AHKv1 results =

	;test1 0.240315

	;test2 0.132753

	;test3 0.168953
ahkv2 results =

	 ;test1 0.00124844 (50% + faster)

	;test2 0.00259254

	;test3 0.00274485
We can see combining variables on a single line in these examples are no longer faster but hamper the code. We'll find out this is different with function calls.

Let's do it again with functions
these functions are across all tests ; condensed

	e() {   y := 999*222
	   return y }

	f() {  y := 999*222
	   return y }
	g() {   y := 999*222
	   return y }
test1

	a := e()
	b := f()
	c := g()
test2

a := e(),b := f(),c := g()
test3

    a := e()
,b := f()
,c := g()
results

	;test1 0.01627 (50% slower)
	;test2 0.01098
	;test3 0.011008
Even shortened conditionals aren't faster with combined lines
;test1

x := true

if x
   z:=1, a:=2, b:=1, c:=2
;test2

	x := true

	if x
	{ 
	   z:=1
	   a:=2
	   b:=1
	   c:=2
	}
test1 0.0026

test2 0.00180 ;30% faster

