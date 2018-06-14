// fetter stereo pass pulse
(
SynthDef(\bass,
	{|out=0, freq=100, amp=0.1, a = 0.01, r = 0.2, mod = 5, d = 0.15|
    Out.ar(out,
			Pulse.ar(
				[freq, freq *1.02],
				SinOsc.kr(mod).range(0.5-d, 0.5+d),
				EnvGen.kr(Env.perc(a, r, amp),
				doneAction: 2
		)));
	},
	variants: (
		alpha: [a: 0.01, r: 0.5],
		beta: [a: 3, r: 0.01],
		gamma: [a: 0.01, r: 4])
).add;
)

// electronic snare
(
SynthDef(\snare,
	{|out=0, freq=100, amp=0.1, a = 0.01, r = 0.2, mod = 5, d = 0.15|
    var env = Env.perc(0.01, 0.10, 0.1);
	var envgen = EnvGen.kr(env, doneAction: 2);

		Out.ar(out,
			(WhiteNoise.ar(
				(envgen * 1000) + freq
			) * envgen * 0.005) !2
		);
	},
	variants: (
		alpha: [a: 0.01, r: 0.5],
		beta: [a: 3, r: 0.01],
		gamma: [a: 0.01, r: 4])
).add;
)



y = Synth('snare');
x = Synth('bass', [\freq, 60, \r, 0.5]);
z = Synth.head(s, \bass);


(
var qs = 1;
var rel = 0.4;

Pbind(\instrument, 'snare',
	\freq, Prand([1, 1.2, 1.4, 1.5, 2], inf) * 220,
	\dur, 0.5,
	\r, rel).play(quant:qs);

)

(
var qs = 1;
var rel = 0.4;

Pbind(\instrument, 'bass',
	\freq, Prand([1, 1.2, 1.4, 1.5, 2], inf) * 60,
	\dur, 0.25,
	\r, rel).play(quant:qs);
)

(
var qs = 1;
var rel = 0.1;

Pbind(\instrument, \bass,
	\freq, Prand([1, 1.2, 1.4, 1.5, 2], inf) * 120,
	\dur, 0.25,
	\r, rel).play(quant:qs);


Pbind(\instrument, \bass,
	\freq, Prand([1, 1.2, 1.4, 1.5, 2], inf) * 180,
	\dur, 0.125,
	\r, rel).play(quant:qs);

)