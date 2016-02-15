// The scripts in Eli Fieldsteel's
// SuperCollider Tutorial: 4. Envelopes and doneAction
//https://www.youtube.com/watch?v=-wDAPo9hpCg&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=5

//shows what synths are still running
s.plotTree;


//introducing, Line envelope. A linear function
(
{
	var sig, env;
	env = Line.kr(1,0,1);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)
x.free;
s.freeAll;


//if you play the above function multiple times, you must use s.freeAll to stop all running synths. to automatically end the synth when it is done, use doneAction 2.
(
{
	var sig, env;
	env = Line.kr(1,0,1, doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)


//introducing, XLine envelope, which is an exponential function. Input values must be nonzero and the same sign. This sounds more natural since we perceive amplitude exponentially.
(
{
	var sig, env;
	env = XLine.kr(1,0.01,1, doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)


// same with decibels, use Line instead of XLine, since decibels is a linear measurement of loudness
(
{
	var sig, env;
	env = Line.kr(0,-40,1, doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env.dbamp;
}.play;
)
//convert amplitude to decibels
0.25.ampdb


//Xline for frequency. We also perceive frequency exponentially.
(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,1, doneAction:2);
	freq = XLine.kr(800,110,1, doneAction:2);
	sig = Pulse.ar(freq) * env;
}.play;
)


//With multiplication of functions with doneAction:2, the product ends whenever the first function with doneAction:2 ends.
(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,1, doneAction:2);
	freq = XLine.kr(800,110,5, doneAction:2);
	sig = Pulse.ar(freq) * env;
}.play;
)
(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,5, doneAction:2);
	freq = XLine.kr(800,110,1, doneAction:2);
	sig = Pulse.ar(freq) * env;
}.play;
)


//to avoid cutoff, only apply doneAction:2 on longest function.
(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,5, doneAction:2);
	freq = XLine.kr(800,110,1, doneAction:0);
	sig = Pulse.ar(freq) * env;
}.play;
)


//Introducing Env. By default, it is a triangle envelope
Env.new.plot;


//Hear default Env
(
{
	var sig, env;
	env = EnvGen.kr(Env.new, doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)
//Define custom envelope
Env.new([0,1,0.2,0], [0.5,1,2]).plot;
//New with exponential interpolation, must make 0's small
Env.new([0.01,1,0.2,0.01], [0.5,1,2],\exp).plot;
//Alternatively, input a third vector with curvature values
Env.new([0,1,0.2,0], [0.5,1,2], [3,-3,0]).plot;
Env.new([0,1,0.2,0], [0.5,1,2], [12,-12,0]).plot;
Env.new([0,1,0.2,0], [0.5,1,2], [-3,3,0]).plot;
Env.new([0,1,0.2,0], [0.5,1,2], [\sine,\sine,0]).plot;
//Hear custom Env
(
{
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]),
		doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)


//Now with gate, which can act as a trigger, which resets the envelope. For gate to trigger, it must move from a non-positive value to positive value.
(
x = {
	arg gate = 0;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), gate);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play;
)
x.set(\gate, 1);
x.set(\gate, 1); //does not retrigger second time, since gate is already at one. Can set manually, back to zero.
x.set(\gate, 0);


//with trigger argument, which creates a control-rate impulse, which will return value to zero automatically.
(
x = {
	arg t_gate = 0;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play;
)
x.set(\gate, 1);
x.set(\gate, 1); //can retrigger now multiple times.
//set t_gate=1 to play upon definition, and it is still retriggerable
(
x = {
	arg t_gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play;
)
x.set(\gate, 1);
x.set(\gate, 1); //can retrigger now multiple times.


//if use doneAction:2, can only retrigger while envelope is still playing. If it is allowed to finish, it will not be retriggerable.
(
x = {
	arg t_gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate, doneAction:2);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play;
)
x.set(\gate, 1);


//adsr=attack-decay-sustain-release
(
x = {
	arg gate = 0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate);
	sig = VarSaw.ar(SinOsc.kr(16).range(500,1000)) * env;
}.play;
)
x.set(\gate, 1);
x.set(\gate, 0);
//if use t_gate, cannot sustain adsr, so best to use regular gate argument
(
x = {
	arg t_gate = 0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, t_gate);
	sig = VarSaw.ar(SinOsc.kr(16).range(500,1000)) * env;
}.play;
)
x.set(\t_gate, 1);


(
x = {
	arg gate = 0;
	var sig, env, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 2000, 0.1);
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = VarSaw.ar(SinOsc.kr(freq).range(500,1000)) * env;
}.play;
)
x.set(\gate, 1);
x.set(\gate, 0);