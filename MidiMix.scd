// Synthdefs

(
SynthDef("laserbeam", {
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, att = 0.01;
	var snd, freqenv, ampenv;
	// frequency envelope
	freqenv = EnvGen.ar(Env([4, 0.5, 1, 1], [att, 0.01, 1.0]));
	// amplitude envelope
	// no gate: fixed-time envelope, self-terminating.
	ampenv = EnvGen.ar(
		envelope: Env([0, 1, 0.5, 0.0], [0.02, 0.2, 0.1]),
		levelScale: amp,
		doneAction: 2);
	snd = LFTri.ar(freq: freq * freqenv, mul: ampenv);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
)

(
SynthDef("werkit", {
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, gate = 1, cutoff = 100, rq = 0.1, att = 0.01, dec = 0, sus = 1, rel = 1, delay = 0.3;

	var source, filter, env, snd, delayEnv;
	source = WhiteNoise.ar;
	filter = BLowPass4.ar(source, freq, rq) * 0.3;
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	snd = (0.7 * filter + (0.3 * filter.distort)) * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;
)

(
SynthDef("trianglewavebells",{
	arg out = 0, pan = 0.0, freq = 440, amp = 1.0, gate = 1, att = 0.01, dec = 0.1, sus = 1, rel = 0.5, lforate = 10, lfowidth = 0.0, cutoff = 100, rq = 0.5;

	var osc1, osc2, vibrato, filter, env;
	vibrato = SinOsc.ar(lforate, Rand(0, 2.0));
	osc1 = Saw.ar(freq * (1.0 + (lfowidth * vibrato)), 0.75);
	osc2 = Mix(LFTri.ar((freq.cpsmidi + [11.9, 12.1]).midicps));
	filter = RHPF.ar((osc1 + (osc2 * 0.5)) * 0.5, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	Out.ar(out, Pan2.ar(filter * env, pan));
}).add;
)

/// Midicontrol


~sn = Synth(\werkit);
~sm = Synth(\trianglewavebells);


(
MIDIClient.init;
MIDIIn.connectAll;

MIDIIn.control = { arg src, chan, num, val;
	//[num, val].postln;
	switch (num,
		19, {
			["regler1 ", val].postln;
			~sn.set(\freq, (val+1)/128*3000);
			~sm.set(\freq, (val+1)/128*3000);
		},
		23, {
			["regler2 ", val].postln;
			~sn.set(\rq, (val+1)/128*1);
		},
		27, {["regler3 ", val].postln;},
		31, {["regler4 ", val].postln;},
		49, {["regler5 ", val].postln;},
		53, {["regler6 ", val].postln;},
		57, {["regler7 ", val].postln;},
		61, {["regler8 ", val].postln;},
		62, {["master ", val].postln;},
	);
};
)

