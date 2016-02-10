// The scripts in Eli Fieldsteel's
// SuperCollider Tutorial: 3. Synth and SynthDef
//https://www.youtube.com/watch?v=LKGGWsXyiyo&index=4&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC


// function making sound
(
z = {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
}.play;
)
z.free;

//same sound defined with SynthDef
(
SynthDef.new(\sineTest, {
	arg noiseHz=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0, sig); //must define output UGen for SynthDef
}.add;
)
//how to create Synth using a particular SynthDef
x = Synth.new(\sineTest);
//can call it with input value different from default
x = Synth.new(\sineTest, [\noiseHz, 32]);
//and can set values as it is playing
x.set(\noiseHz, 12);
x.free;


//one more example
(
SynthDef.new(\pulseTest, {
	arg ampHz=4, fund=40, maxPartial=4, width=0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(0, sig2);
}).add;
)

x = Synth.new(\pulseTest);

x.set(\width, 0.05);
x.set(\width, 0.25);
x.set(\fund, 50);
x.set(\fund, 60);
x.set(\fund, 80);
x.set(\fund, 160);
x.set(\fund, 30);
x.set(\maxPartial, 8);
x.set(\maxPartial, 20);
x.set(\ampHz, 2);
x.set(\ampHz, 1);
x.set(\ampHz, 0.25);

x.free;

x = Synth.new(\pulseTest, [\ampHz, 3.3, \fund, 48, \maxPartial, 4, \width, 0.15]);
