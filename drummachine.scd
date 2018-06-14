(
SynthDef(\kick, {|out = 0, amp = 0, pan|
	var env, bass;
	env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
	bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
	Out.ar(out, Pan2.ar(bass*env, pan, amp));
}).add;

SynthDef(\snare, {|out = 0, amp = 0, pan|
	var env, snare;
	env = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);
	snare = SinOsc.ar(120) - WhiteNoise.ar(0.5, 0.5);
	Out.ar(out, Pan2.ar(snare*env, pan, amp));
}).add;

SynthDef(\hat, {|out = 0, amp = 0, pan|
	var env, hat;
	env = EnvGen.kr(Env.perc(0.002, 0.3, 1, -2), 1, doneAction:2);
	hat = Klank.ar(`[
		[ 6563, 9875 ],
		[ 0.6, 0.5 ],
		[ 0.002, 0.003] ], PinkNoise.ar(1));
	Out.ar(out, Pan2.ar(hat*env, pan, amp));
}).add;

SynthDef(\tom, {|out = 0, amp = 0, pan|
var env, tom;
env = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);
tom = SinOsc.ar(440);
Out.ar(out, Pan2.ar(tom*env, pan, amp));
}).add;
)


// the actual drum machine
(
TempoClock.default.tempo = 80/60;

c = Pseq ([0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
d = Pseq ([0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1]);
d = Pseq ([0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1]);
b = Pseq ([0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0]);
a = Pseq ([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]);


p = Ppar(
	[a, b, c, d].collect { |pattern, i|
		Pbind(
			\instrument, [\kick, \snare, \hat, \tom].at(i),
			\dur, 0.25,
			\amp, 0.1,
			\noteOrRest, Pif(pattern > 0, 1, Rest)
		)
	},
	inf
).play;
)