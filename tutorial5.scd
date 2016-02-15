// The scripts in Eli Fieldsteel's
// SuperCollider Tutorial: 5. Multichannel Expansion
//https://www.youtube.com/watch?v=fAXETAyrv8s&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=6


//create popup window with meter for different channels
s.meter; // or command-M

//Multichannel Expansion
//An array of UGens will play over multiple channels of audio. SC will assign the array of UGens will play over consecutive ascending buses.
x ={SinOsc.ar}.play; //play a sine wave on a single channel
//if play array of UGens, SC will automatically assign them to a two channel (stereo) output.
x ={[SinOsc.ar(300),SinOsc.ar(500)]}.play; //play 300 Hz on left speaker, 500 Hz on right speaker.
// the next line is equivalent - SC will accept an array as an input and expand the output into an array of SinOsc's
x ={SinOsc.ar([300,500])}.play;
x.free;


//If perform math with two multichannel UGens, then the arguments of one UGen correspond with the arguments of the other. Arguments with the same index are operated on, and the output will also be multichannel with the same number of arguments.
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1]).range(0,1);
//  amp = SinOsc.kr(7).range(0,1); //if perform math on two multichannel UGens that do not have the same number of channels, the output will have the same number of channels as the larger UGen, and the shorter one will repeat until it is the same size.
	sig = SinOsc.ar([300,500]);
	sig = sig * amp; // 300 Hz channel fluctuates at 7 Hz, 500 Hz at 1 Hz
}.play;
)
x.free;


//with more than two channels, you can only hear the first two channels in the left and right speaker respectively
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1,2,0.2,6]).range(0,1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	sig = sig * amp;
}.play;
)
x.free;


// you can hear all the channels with Mix, or Splay
//mixed into one channel with Mix
//or, you can hear all the multiple channels distributed over stereo with Splay
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1,2,0.2,6]).range(0,1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	sig = sig * amp;
	[Mix.new(sig),Mix.new(sig)] * 0.25; // or use dup function:
	//Mix.new(sig).dup(2) * 0.25; //or ! is a syntactical shortcut for dup
	//Mix.new(sig)!2 * 0.25;
}.play;
)
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1,2,0.2,6]).range(0,1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	sig = sig * amp;
	Splay.ar(sig) * 0.5;
}.play;
)
x.free;

//a note about duplication
//below, the signal produced by PinkNoise is duplicated, the left and right channels are sending the exact same signal
x = {PinkNoise.ar(0.5)!2}.play;
//below, the argument for PinkNoise is duplicated. In this case independent unique PinkNoise signals are created
x = {PinkNoise.ar(0.5!2)}.play;
x.free;


//when creating synthdef for multiple channels, its correct to provide Out.ar your lowest channel.
(
SynthDef.new(\multi, {
	var sig, amp;
	amp = SinOsc.kr([7,1,2,0.2,6]).range(0,1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig); //correctly writes first channel to bus 0, and assigns remaining channels to consecutive ascending buses
//PITFALL:
//	Out.ar([0,1], sig); this may seem intuitively correct, but this invokes multichannel expansion of the 2 channels across two output buses. This means it will send output to three channels, where the middle channel has signal
}).add;
)
x = Synth.new(\multi);
x.free;


//create array of random values
//intuitive but wrong way, creates array of the same randomly chosen number
rrand(50,1200)!4;
//if encase rrand call in {}, then it is a function, and rrand will be called independently for each array element, resulting in an array with different random numbers
{rrand(50,1200)}!4;


//add randomness to SynthDef.
(
SynthDef.new(\multi, {
	var sig, amp;
	amp = SinOsc.kr({exprand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({exprand(50,1200)}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)
x = Synth.new(\multi); //if invoke this many times, you will hear that there are no new frequencies - this is because the random numbers, when using lower case exprand, are selected when the SynthDef is compiled.
x.free;


//vs UGen ExpRand, which selects random numbers every time the synth is created
(
SynthDef.new(\multi, {
	var sig, amp;
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)
x = Synth.new(\multi);
x.free;


//with envelope with 10s attack and 10s release, nice!
(
SynthDef.new(\multi, {
	var sig, amp, env;
	env = EnvGen.kr(Env.new([0,1,0],[10,10],[1,-1]), doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)
x = Synth.new(\multi);
x.free;


//to close, experiment with UGens.
