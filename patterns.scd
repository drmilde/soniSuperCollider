
// create drum set from 10 samples, lpad into dictionary
(
d = Dictionary.new;
d.add(\drums ->
	PathName("C:/Users/audio_a_01/Desktop/system1/SuperCollider/sounds/drums").entries.collect(
		{
			arg sf;
			Buffer.read(s, sf.fullPath);
		}
	);
)
)

// bufferplay
(
SynthDef.new(\bufplay, {
		arg buf=0, rate=1, amp=1;
		var sig;
		sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, doneAction: 2);
		sig = sig * amp;
		Out.ar(0, sig!2);
	}
).add;

)

Synth.new(\bufplay, [\buf, d[\drums][5]]);

d[\drums].choose.play;

s.scope;

TempoClock.default.tempo = 100/60;


// bass drum
(
Pdef (\kick,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq( [0.5, 0.5, 0.5, 0.25, 0.25], inf),
		\buf, d[\drums][4],
		\rate, Pxrand([0.7, 1.0, 1.7, 0.9, 1.3], inf)
	);
).play(quant:2);
)

// hh
(
Pdef (\hh,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq( [0.25, 0.5, 0.5, 0.25, 0.5], inf),
		\buf, d[\drums][2],
		\amp, 0.2
	);
).play(quant:2);
)

// snare
(
Pdef (\snare,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq( [1, 1], inf),
		\buf, d[\drums][5],
		\amp, 0.02
	);
).play(quant:2);
)


s.plotTree


///////

(
SynthDef(\bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;

//TempoClock.default.tempo = 100/60;

p = Pxrand([
    Pbind(
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.05, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.05, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.05, \detune, 1.005
    ),
    Pmono(\bass,
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.05, \detune, 1.005
    )
], inf).play(quant: 1);
)

// totally cheesy, but who could resist?
(
SynthDef(\kik, { |preamp = 1, amp = 1|
    var    freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp).distort * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: 2);
    Out.ar(0, sig ! 2);
}).add;

// before you play:
// what do you anticipate '\delta, 1' will do?
k = Pbind(\instrument, \kik, \delta, 1, \preamp, 4.5, \amp, 0.02).play(quant: 1);
)

p.stop;
k.stop;
