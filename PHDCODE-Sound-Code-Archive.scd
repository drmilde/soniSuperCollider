// ************************************************************
// Code for PHD Submission, 2016
// by Jonas Hummel, @monodread81
// ************************************************************
// A collection of sounds for performance
// 2013-2015

// This includes
// A – Bass sounds
// B - percussion / drumkit sounds


/////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

(
// bass sounds
(
// this one needs a gate-off to end!
SynthDef(\daf_bass,{ |out, freq=440, sustain=1, dist=1, gate=1, amp=0.1|
	var snd, env, fenv, harm;
	harm = [1,1.01,2,2.02,3.5,4.01,5.501];
	harm = harm ++ (harm*2);
	snd = SinOsc.ar(freq*harm,0, harm.reciprocal).sum * dist;
	snd = snd.tanh+ SinOsc.ar(freq / [1, 2], 0, amp*2).sum.tanh!2;
	env = EnvGen.kr(Env.adsr(0.001,0.2,0.9,0.25), gate, doneAction:2);
	Out.ar(out, snd!2 * env * amp);
}).add;
);
/*
(instrument: \daf_bass, freq: 150, sustain: 0.2).play
*/

(
SynthDef(\bass, {|out=0 freq = 60 amp = 0.5 gate=1 cutoff= 1000 rq=0.5 pan=0.0 sustain=1 noise=0.01 preamp=4 lfo=0.1, harm=0.99|
	var osc, filter, env, filterenv, high, harmonix;
	harmonix = ([harm, harm+1] * Harmonics.new(8).geom(harm).reverse); // nice beatings!
	osc = Splay.ar(LFTri.ar(freq * harmonix.postln,0, preamp * (0.25!8)).softclip);
	filterenv = EnvGen.ar(Env.new([3,1,2,1],[0.1,0.5,0.4]), gate, timeScale: sustain);
	filter =  RLPF.ar(osc, cutoff*filterenv+20,rq, 0.5).tanh;
	env = EnvGen.ar(Env.linen(0.01, sustain, 0.2), timeScale:sustain, doneAction:2);
	lfo = LFSaw.kr(lfo,0,0.45,1);
	high = HPF.ar(Decay.ar(PinkNoise.ar(noise*0.1), sustain*0.1, lfo), freq.linlin(20,3000,3000,12000)*lfo, 1/preamp).softclip;
	filter = filter + (high*0.3);
	Out.ar(out, Pan2.ar(filter*env*amp,pan))
}).add;
);
/*
(instrument: \bass, freq:80, sustain: 1, amp: 0.6).play
*/


(
SynthDef(\bass2, {|out=0 freq = 60 amp = 0.1 cutoff= 3000 rq=0.5 pan=0.0 sustain=1 preamp=1 noise=1|
	var osc, filter, env, filterenv, high;
	freq = freq + LFNoise2.kr(noise).range(0, noise*2);
	osc = SinOsc.ar(freq, 0.1, preamp) + LFSaw.ar(freq*2, 0, 0.2 * preamp);
	filterenv = EnvGen.ar(Env.new([2,0.5], [0.5,0.2]), timeScale:sustain);
	filter =  RLPF.ar(osc.tanh, cutoff*filterenv+20,rq);
	env = EnvGen.ar(Env.linen(0.01, sustain, 0.1), doneAction:2);
	filter = Mix(filter.softclip) ;
	Out.ar(out, Pan2.ar(filter*env*amp,pan))
}).add;

);
/*
(instrument: \bass2, freq:100, sustain: 1, amp: 0.6).play
*/


(
SynthDef(\bass3, { arg amp=0.1, freq=45, atk=0.2, dcy=6, shape=1, pan=0, sustain=1, out;
	var son, env;
	env = EnvGen.kr(Env.linen(atk,sustain, 0.2), timeScale:sustain, doneAction:2);
	son = BBandStop.ar(Saw.ar(0.1*shape*sustain, Decay2.kr(dcy*shape, 0.01, 0.3*shape))**1.5, freq * [1, 1.01], 0.05);
	son = HPF.ar(LeakDC.ar(son, 0.9), 120, 2);
	Out.ar(out, Splay.ar(son.tanh * env, 0, amp, pan))
}).add
);
/*
(instrument: \bass3, shape:1, dcy:6, amp: 1, freq: 50, atk:0.3).play
*/


(
SynthDef(\bassDrop, { |out=0, freq=90, ffreq=540, rq=0.1, amp=0.1, pan=0, sustain=1, ring=0.1|
	var son,env, saw;
	env = EnvGen.ar(Env.linen(0.001, sustain, 0.5),  timeScale:sustain, doneAction:2);
	son = SinOsc.ar(freq * XLine.kr(1.25, 1, sustain), 0.1, 0.5);
	son = Decay.ar(son, 0.01, ring+0.001);
	son = BLowPass.ar((son.tanh), ffreq, 0.005+rq, 0.5);
	Out.ar(out,Pan2.ar(son  * env, pan, amp))
}).add;
);
/*
(instrument: \bassDrop, sustain: 0.5, freq: 52, amp: 0.6).play
*/
);

/////////////////////////////////////////////
// PERCUSSIONS
(
	SynthDef(\impulse, { arg out=0, freq=10, sustain=1, amp=0.1, pan=0;
		var sound, env;
			sound = Impulse.ar(freq, mul:amp);
			env = EnvGen.kr(Env.linen(0.01, 0.01*sustain, 0.01, 0.6, -3), doneAction:2);
			sound = Pan2.ar(sound*[1,1.01],pan);
			Out.ar(out, sound) * env;
	}).add;
);
/*
(instrument: \impulse, sustain: 1, amp: 0.6).play
*/

// variation of the above, similar to percSine
(
SynthDef(\percSine, { arg out, freq=440, amp = 0.1, sustain=0.1, dur=1, pan=0, noise=0.1;
		var sound, env, src;
		sound = SinOsc.ar(freq, mul:amp);
// 		or choose only noise	as sound
		noise = PinkNoise.ar(noise*amp);
		sound = sound+noise;
		env = EnvGen.ar(Env.perc(0.005, sustain*dur, -10.dbamp), doneAction:2);
		src = Pan2.ar(sound*env, pan);
		Out.ar(out, src)
		}).add;
);
/*
(instrument: \percSine, sustain: 1, amp: 0.6).play
*/

// with Dust inside
(
	SynthDef(\impulseD, { arg out=0, freq=1, sustain=1, amp=0.1, pan=0, noise=1;
		var son, dust,env;
			son = Impulse.ar(freq, mul:amp);
			dust = Dust.ar(freq*LFNoise0.kr(1,2,2), amp);
			son = (dust*noise)+son;
			env = EnvGen.kr(Env.perc(0.01, sustain, amp, -4), doneAction:2);
			Out.ar(out, Pan2.ar(Limiter.ar(son*[1,1.01]*env),pan));
	}).add;
);
/*
(instrument: \impulseD, sustain: 1.5, amp: 0.6, noise:1).play
*/

////////////////////////////////////////////////// PERC/DRUMKIT
(
// HI HATs (hh)
// former rfo3 sound, can produce bass kicks as well
(
SynthDef(\hhPitch, {|out, sustain = 1, freq = 8000, amp=0.1, noise=0.5, pan=0|
		var env = Line.kr(1, 0, sustain, doneAction: 2);
		var son = BPF.ar(WhiteNoise.ar(noise, 4), freq*XLine.kr(0.9,1.1,sustain), 0.15, 2);
	Out.ar(out, Pan2.ar(son * env * amp, pan));
	}).add;
);
/*
Synth(\hhPitch);
 */

(
SynthDef(\hhRev, {|out, sustain = 0.1, amp=0.1, freq=6799, pan=0|
	// these are synths argumiments
		var env = XLine.kr(0.1, 1, sustain, 5, doneAction: 2);
		// variable- envelope
		var son = BBandPass.ar(WhiteNoise.ar(0.4),freq*XLine.kr(1.1,0.8,sustain/4), 0.2, 3);
		//sinewave sound generator with se
	Out.ar(out, Pan2.ar(son * env * amp, pan));
	}).add;
);
/*
Synth(\hhRev);
*/


(
SynthDef(\hhSimple, { arg out=0, amp=0.4, sustain=1, pan=0;
	var shape, sound, env, dur;
	dur=2*sustain;
	env = EnvGen.kr(Env.new([0, 1, 1, 0],[0, dur, 0]), doneAction:2);
	shape = Decay2.kr(Impulse.kr(1/dur,0),0.02*sustain,0.05,4) * env;
	sound = WhiteNoise.ar(shape);
	Out.ar(out,Pan2.ar(sound*amp, pan));
}).add;
);
/*
Synth(\hhSimple);
*/

(
SynthDef('hhXLine', { arg out = 0, freq=8000, sustain=0.01, amp=0.5, pan = 0.0;
		var window;
		window = Env.new([ amp, 0.001 ], [ sustain ], 'exponential');
		Out.ar(out,
			Pan2.ar(
				BPF.ar(ClipNoise.ar, freq, 0.1),
				pan,
				3
			) * EnvGen.ar(window, doneAction:2)
		)
}).add;
);
/*
Synth(\hhXLine);
*/
(
SynthDef('hhXLRev', { arg out = 0, freq=8000, sustain=0.01, amp=0.5, pan = 0.0;
		var window;
		window = Env.new([ 0.001, amp ], [ sustain ], 'exponential');
		Out.ar(out,
			Pan2.ar(
				BPF.ar(ClipNoise.ar, freq, 0.1),
				pan,
				3
			) * EnvGen.ar(window, doneAction:2)
		)
}).add;
);
/*
Synth(\hhXLRev);
*/

// SOShats -------
// http://www.soundonsound.com/sos/Jun02/articles/synthsecrets0602.asp

(
SynthDef(\hhSOS, {arg out = 0, freq = 6000, sustain = 0.1, pan=0,amp = 0.1;
	var root_cymbal, root_cymbal_square, root_cymbal_pmosc;
	var initial_bpf_contour, initial_bpf, initial_env;
	var body_hpf, body_env;
	var cymbal_mix;

	root_cymbal_square = Pulse.ar(freq, 0.5, mul: 1);
	root_cymbal_pmosc = PMOsc.ar(root_cymbal_square,
					[freq*1.34, freq*2.405, freq*3.09, freq*1.309],
					[310/1.3, 26/0.5, 11/3.4, 0.72772],
					mul: 1,
					add: 0);
	root_cymbal = Mix.new(root_cymbal_pmosc);
	initial_bpf_contour = Line.kr(15000, 9000, 0.1);
	initial_env = EnvGen.ar(Env.perc(0.005, 0.1), 1.0);
	initial_bpf = BPF.ar(root_cymbal, initial_bpf_contour, mul:initial_env);
	body_env = EnvGen.ar(Env.perc(0.005, sustain, 1, -2), 1.0, doneAction: 2);
	body_hpf = HPF.ar(in: root_cymbal, freq: Line.kr(9000, 12000, sustain),mul: body_env, add: 0);
	cymbal_mix = Mix.new([initial_bpf, body_hpf]) * amp;
	Out.ar(out, Pan2.ar(cymbal_mix, pan))
	}).add
);
/*
Synth(\hhSOS);
*/

//////////////////////////////////////////////////
// A CLAP


(
SynthDef(\clap, {	arg out=0, pan=0, amp = 0.1;
		var env1, env2, sig, noise1, noise2;

		env1 = EnvGen.ar(Env.new([0, 1, 0, 1, 0, 1, 0, 1, 0], [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03], [0, -3, 0, -3, 0, -3, 0, -4]));
		env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2);

		noise1 = WhiteNoise.ar(env1);
		noise1 = HPF.ar(noise1, 600);
		noise1 = BPF.ar(noise1, 2000, 3);

		noise2 = WhiteNoise.ar(env2);
		noise2 = HPF.ar(noise2, 1000);
		noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

		sig = noise1 + noise2;
		sig = sig * 2;
		sig = sig.softclip * amp * -6.dbamp;

	Out.ar(out, Pan2.ar(sig,pan));
	}).add;
);
/*
Synth(\clap);
*/

////////// SOME FX Sounds from PBUP...

(
SynthDef('press', { |out, amp = 0.1, p0 = 1, p1 = 0, sustain = 10, freq = 4000, ratio = 2, pan=0|
	var pressure, son, map, param;
	pressure = EnvGen.ar(Env.new([p0, p1.max(0.001)], [sustain], [-4]), doneAction: 2);
	param = pressure.linlin(1, 0, 1.32, 1.99);

	son = Crackle.ar(param + [0, Rand(0, 0.001)]);
	freq = pressure.linlin(1, 0, freq * ratio, freq) * LFNoise1.kr(80,  1 - pressure * 0.1, 1);
	son = Ringz.ar(son, freq, 0.01,freq/2000);// mul was *10
	Out.ar(out, Splay.ar(son * pressure * amp, 0,1,pan))
}).add;
);

/*
Synth(\press);
*/

(
SynthDef('press2', { |out, amp = 0.1, p0 = 1, p1 = 0, sustain = 5, freq = 4000, ratio = 2, pan=0|
	var pressure, son, map, n = 4;
	pressure = EnvGen.ar(Env.new([p0, p1.max(0.0001)], [sustain], [\exp]), doneAction: 2);
	map = { |i|
		var a = rrand(0.0, 1.0);  // need info postin?
		InRange.ar(pressure, a, a + 0.1) * SinOsc.ar(rand(9000, 12000), 0, 0.1)
	} ! n;
	son = Crackle.ar(pressure.linlin(1, 0, 1.32, 1.99) + [0, Rand(0, 0.001)]);
	freq = pressure.linlin(1, 0, freq * ratio, freq) * LFNoise1.kr(80,  1-pressure * 0.1, 1);
	son = Ringz.ar(son, freq, 0.01);
	son = son + map.sum;
	Out.ar(out, Splay.ar(son * pressure * amp*(freq/4000), 0,1,pan))
}).add;
);
/*
Synth(\press2);
*/


//////////////////////////////////////////////////
// SNARE DRUMS


(
SynthDef(\snare, {	arg out=0, freq=261.6, pan=0, amp=0.1, bend=1;
		var env0, env1, env2, env1m, oscs, noise, sig, note;
	note = freq.cpsmidi;

		env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));
		env1 = EnvGen.ar(Env.new([1.83, 1, 0.817*bend]*note, [0.005, 0.1], [-4, -5]));
		env1m = env1.midicps;
		env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

		oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
		oscs = LPF.ar(oscs, env1m*1.2, env0);
		oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

		noise = WhiteNoise.ar(0.5);
		noise = HPF.ar(noise, 200, 2);
		noise = BPF.ar(noise, 6900, 0.6, 3) + noise;
		noise = noise * env2;

		sig = oscs + noise;
		sig = sig.clip2(1) * amp * -3.dbamp;

	Out.ar(out, Pan2.ar(sig, pan));
	}).add;

);

/*
Synth(\snare, [\freq, 261, \amp, 0.2, \bend, 1.05]);
*/

(
SynthDef(\snareSoft, { arg out=0, thresh=0.3, below=1, above=0.3, amp=0.5, sustain=1, atk=0.01, dcy=0.1, pan=0;
	var sound, env, trig;
	trig = Impulse.kr(1/sustain, 1);
	env = EnvGen.kr(Env.new([0, 1, 0],[atk, dcy*10]), timeScale:sustain, doneAction:2);
	sound = Decay2.kr(trig,0.01,dcy,PinkNoise.ar(2));
	sound = Compander.ar(sound, sound, thresh, below, above, mul: 2);
	Out.ar(out,Pan2.ar(sound.softclip*amp*env, pan));
}).add;
);
/*
Synth(\snareSoft);
*/

(
SynthDef(\snare909,{ |out=0,amp=0.1, vol=1, pan=0|

      var excitation, membrane;
      excitation = LPF.ar(WhiteNoise.ar(1), 7040, 1) * (0.1 + vol);
      membrane = (
 // Two simple enveloped oscillators represent the loudest resonances of the drum membranes
                     (LFTri.ar(330,0,1) * EnvGen.ar(Env.perc(0.0005,0.055), doneAction:0) * 0.25)
                    + (LFTri.ar(185,0,1) * EnvGen.ar(Env.perc(0.0005,0.075), doneAction:0) * 0.25)

     // Filtered white noise represents the snare
                    +(excitation * EnvGen.ar(Env.perc(0.0005,0.4),doneAction:2) * 0.2)
                    +(HPF.ar(excitation, 523, 1) * EnvGen.ar(Env.perc(0.0005,0.283), doneAction:0) * 0.2)

                   ) * amp;
	Out.ar(out, Splay.ar(membrane, 0, 1, pan))
   }).add;
);
/*
Synth(\snare909, [amp:0.5]);
*/




// SOSsnare -------
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp
(
SynthDef(\snareSOS,
	{arg out = 0, sustain = 0.1, ring = 0.25, noise = 40, crisp = 1000,
	freq = 405, amp = 0.3, pan=0;
	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var snare_noise, snare_brf_1, snare_brf_2, snare_brf_3, snare_brf_4, snare_reson;
	var snare_env;
	var snare_drum_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.53, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar(	Saw.ar(freq*0.85),
					184,
					0.5/1.3,
					mul: drum_mode_env*5,
					add: 0);
	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * ring;

// choose either noise source below
//	snare_noise = Crackle.ar(2.01, 1);
	snare_noise = LFNoise0.ar(20000, 0.1);
	snare_env = EnvGen.ar(Env.perc(0.005, sustain), doneAction: 2);
	snare_brf_1 = BRF.ar(in: snare_noise, freq: 8000, mul: 0.5, rq: 0.1);
	snare_brf_2 = BRF.ar(in: snare_brf_1, freq: 5000, mul: 0.5, rq: 0.1);
	snare_brf_3 = BRF.ar(in: snare_brf_2, freq: 3600, mul: 0.5, rq: 0.1);
	snare_brf_4 = BRF.ar(in: snare_brf_3, freq: 2000, mul: snare_env, rq: 0.0001);
	snare_reson = Resonz.ar(snare_brf_4, crisp, mul: noise) ;
	snare_drum_mix = Mix.new([drum_mode_mix, snare_reson]) * 2 * amp;
	Out.ar(out, Pan2.ar(snare_drum_mix, pan).softclip)
	}
).add
);
/*
Synth(\snareSOS, [\amp, 0.1, \noise, 100, \ring, 1, \sustain, 0.1]); // regular
Synth(\snareSOS, [\amp, 0.1, \noise, 0, \ring, 1, \sustain, 3]); // gong-like
*/




//////////////////////////////////////////////////
// TOMS

// SOStom -------
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp

(
SynthDef(\tomSOS, 	{ arg out = 0, sustain = 0.4, ring = 0.25, freq = 190, timbre = 1.0, amp = 0.3,pan=0;

	var drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc, drum_mode_mix, drum_mode_env;
	var stick_noise, stick_env;
	var drum_reson, tom_mix;

	drum_mode_env = EnvGen.ar(Env.perc(0.1, sustain), 1.0, doneAction: 2);
	drum_mode_sin_1 = SinOsc.ar(freq*0.8, 0, drum_mode_env * 0.5);
	drum_mode_sin_2 = SinOsc.ar(freq, 0, drum_mode_env * 0.5);
	drum_mode_pmosc = PMOsc.ar( Saw.ar(freq*0.9),
								freq*0.85,
								timbre/1.3,
								mul: drum_mode_env*5,
								add: 0);

	drum_mode_mix = Mix.new([drum_mode_sin_1, drum_mode_sin_2, drum_mode_pmosc]) * ring;
	stick_noise = Crackle.ar(2.01, 0.1);
	stick_env = EnvGen.ar(Env.perc(0.005, 0.01), 1.0, timeScale:sustain) * 0.1;
	tom_mix = Mix.new([drum_mode_mix, stick_noise*stick_env]) * amp;
	Out.ar(out, Pan2.ar(tom_mix, pan).softclip)
	}
).add
);
/*
Synth(\tomSOS);
Synth(\tomSOS, [\amp, 0.1, \freq, 300, \ring, 0.13, \timbre, 5, \sustain, 3]); // metal rods?
Synth(\tomSOS, [\amp, 0.1, \freq, 300, \ring, 1, \timbre, 1.0, \sustain, 0.2]);
*/




//////////////////////////////////////////////////
// BASS DRUMS
(
SynthDef(\kick, {	arg out=0, amp=0.1, freq=185, pan=0;
		var env0, env1, env1m, sig, note;
	note = freq.cpsmidi.clip(0,50);

		env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
		env1 = EnvGen.ar(Env.new([1.86, 1, 0.53]*note, [0.005, 0.29], [-4, -5]));
		env1m = env1.midicps;
		sig = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
		sig = sig + WhiteNoise.ar(1);
		sig = LPF.ar(sig, env1m*1.5, env0);
		sig = sig + SinOsc.ar(env1m, 0.5, env0);

		sig = sig * 1.2 * amp;
		sig = sig.clip2(1);

	Out.ar(out, Pan2.ar(sig,pan));
	}).add;
);
/*
Synth(\kick);
*/


(
SynthDef(\kickGarage, { arg out, amp=0.4, dur=2, freq=140, ffreq=300, pan=0;
	var shape, sound, env;
	env = EnvGen.kr(Env.new([0, 0.6, 0.2, 0],[0, dur, 0]), doneAction:2);
	shape = Decay2.kr(Impulse.kr(1/dur,0),0,0.4,4) * env;
	sound = HPF.ar(BrownNoise.ar(shape)*SinOsc.ar(freq, mul:2*amp),60);
	sound = Pan2.ar(LPF.ar(sound,ffreq),pan);
	Out.ar(out,sound);
}).add;
);
/*
Synth(\kickGarage);
*/
(
SynthDef(\kickFX, { |out=0, freq=200, amp=0.3, sustain=2, dly=0.2,decay=2, pan=0|

	var son,env,delaymod, source, noise, trig, trig2, vib, impulse, rev;
	//var decaygen = (BrownNoise.kr(1, add:1).abs).lag(0.1);
	trig = Impulse.kr(1/sustain);
	delaymod = Phasor.kr(trig,0.0001,0.001,0.8);
	env = EnvGen.ar(Env.linen(0.01, sustain/2,sustain/2, level:amp), doneAction:2);

	source = SinOsc.ar(freq, mul:0.1);
	source = Decay.ar(K2A.ar(trig), dly, source);
	son = CombN.ar(source, 2, delaymod, decay, amp);
	//son = son.tanh;
	son = LeakDC.ar(son);
	son = RLPF.ar(son, 500, 0.2, 1);
	son = son * env;
	Out.ar(out, Splay.ar(son,0,1, pan))
	}
	).add;
);
/*
Synth(\kickFX);
*/

// some soft bass kick
// has high level output! needs compression...
(
SynthDef(\kickSoft, { |freq=50, sustain=2, detune=0, amp=0.4, out=0, pan=0|
	var son, env, noise, trig;
	freq=freq.clip(20,200);
	trig = Impulse.kr((sustain));
	son = Mix.fill(8, {|i| SinOsc.ar(freq*(1+((detune/100).abs*i)),i*0.1*pi, mul:amp**(i+1))});
	noise = BrownNoise.ar((amp*0.02).dup);
	son = son+noise;
	env = EnvGen.ar(Env.new([0.5, 0.95, 0.5, 0], [0.005, 0.6, 0.26]*sustain, [-4, -2, -4]), doneAction:2);
	son = LPF.ar(son, 300);
	son = Compander.ar(son, son, 0.3, 1, 0.3);
	Out.ar(out, Splay.ar(son*env*amp, 0,1, pan))
}).add;

);
/*
Synth(\kickSoft);
*/

(
SynthDef(\kickLo, { |out=0, freq=90, ffreq=70, amp=0.4, dcy=0.14, rq=0.005, rq2=0.04, sustain=2,pan=0|
	var son,env,mod, src, addnoise, sweep, trigger;
	trigger = Impulse.ar(sustain.reciprocal);
	//	mod = SinOsc.kr(freq/20, pi/2,0.1,1);
	mod = XLine.kr(4, 0.5, sustain/2);
	sweep = Sweep.ar(trigger,0.05);
	addnoise = Decay.ar(trigger, 0.5,PinkNoise.ar(2));
	src = LFTri.ar(freq, 0.05);
	src = Decay.ar(trigger,dcy, src);
	src = Mix.fill(4, {|i| BAllPass.ar(src, ffreq, rq, amp); });

	son = BLowPass.ar(src+addnoise, ffreq*mod, rq2, amp);
	env = EnvGen.ar(Env.linen(0.001,sustain, 0.3), doneAction:2);

	son = son * env;
	Out.ar(out,Pan2.ar(son, pan))
}).add;

);
/*
Synth(\kickLo);
*/

(
// this one is based on the old 'rfo3/hhRev' instrument with some reverb added
SynthDef(\kickRev, {|out, sustain = 1, freq = 80, ffreq=800, amp=0.1, wet=1, pan=0|
		var verb, son, env, rand;
		rand = LFNoise0.kr(sustain, 0.1,1);
		env = EnvGen.kr(Env.linen(0.1,sustain),doneAction:2);
		son = BPF.ar(WhiteNoise.ar(amp, 2), freq, 0.5);
		verb = GVerb.ar(son,15,1.85*rand,0.51,0.39,15,0.5,0.3,0.2, mul:0.4);
		son = LPF.ar(son, ffreq) * env;
	Out.ar(out, Splay.ar(son+(wet*verb), 0,1,pan));
	}).add;
);
/*
Synth(\kickRev, [\pan, -1]);
*/

// SOSkick -------
// http://www.soundonsound.com/sos/jan02/articles/synthsecrets0102.asp
// increase mod_freq and mod_index for interesting electronic percussion
(
SynthDef(\kickSOS,
	{ arg out = 0, freq = 50, mfreq = 5, mod_index = 5, sustain = 0.4, amp = 0.4, noise = 0.025, pan=0;
	var pitch_contour, drum_osc, drum_lpf, drum_env;
	var beater_source, beater_hpf, beater_lpf, lpf_cutoff_contour, beater_env;
	var kick_mix;
	pitch_contour = Line.kr(freq*2, freq, 0.02);
	drum_osc = PMOsc.ar(	pitch_contour,
				mfreq,
				mod_index/1.3,
				mul: 1,
				add: 0);
	drum_lpf = LPF.ar(in: drum_osc, freq: 1000, mul: 1, add: 0);
	drum_env = drum_lpf * EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
	beater_source = WhiteNoise.ar(noise);
	beater_hpf = HPF.ar(in: beater_source, freq: 500, mul: 1, add: 0);
	lpf_cutoff_contour = Line.kr(6000, 500, 0.03);
	beater_lpf = LPF.ar(in: beater_hpf, freq: lpf_cutoff_contour, mul: 1, add: 0);
	beater_env = beater_lpf * EnvGen.ar(Env.perc, 1.0, timeScale: sustain, doneAction: 2);
	kick_mix = Mix.new([drum_env, beater_env]) * 2 * amp;
	Out.ar(out, Pan2.ar(kick_mix, pan))
	}
	).add
);
/*
Synth(\kickSOS);
*/


// variation of the above, similar to percSine
(
SynthDef(\percSine, { arg out, freq=440, amp = 0.1, sustain=0.1, dur=1, pan=0, noise=0.1;
		var sound, env, src;
		sound = SinOsc.ar(freq,0, 2);
		noise = PinkNoise.ar(noise);
	sound = Mix(sound+noise);
		env = EnvGen.ar(Env.perc(0.01, sustain*dur, -6.dbamp), doneAction:2);
		src = Pan2.ar(sound.softclip*env, pan, amp);
		Out.ar(out, src)
		}).add;
);
/*
Synth(\percSine);
*/

// low percussion, nice Ringing Filter...
(
SynthDef(\kalimba, {|out, sustain = 0.3, freq = 200, amp=0.1, ring=0.1, noise=1, pan=0|
		var env1, env2, son;
		env1 = Line.kr(XLine.kr(0.9,0.4, 0.01), 0, sustain, doneAction: 2);
		env2 = EnvGen.kr(Env.perc(0.001, sustain));
		son = BPF.ar(PinkNoise.ar(1, 2), XLine.kr(freq*2,freq,0.01), 0.5);
		son = Ringz.ar(son, freq, ring, mul:0.1);
		noise = noise*WhiteNoise.ar(LFNoise1.kr(6).range(1/30, 1/60))*env2;

	Out.ar(out, Splay.ar((son.tanh + HPF.ar(noise,freq*2, 0.1)) * env1, 0,amp, pan));
	}).add;
);
/*
Synth(\kalimba, [\amp,0.5]);
*/


( // random freqs!
  SynthDef(\metal, { |out=0, freq=300, ffreq=12000, rq=0.7, amp=0.5, sustain=1, pan=0|
	var src, env, filt, partials, amps, rings, num=10;
	env = EnvGen.kr(Env.perc(0.01, sustain, amp), doneAction:2);

	partials = [1] ++ Array.fill(num-1, { |i| ((0.5*i)+0.5.linrand)});
	amps = Array.fill(num,{|i| ((0.1*i) + 0.1.rand)}).reverse;
	rings = Array.fill(num, { (sustain + 4.0.rand) });

	src = Mix.fill(num, { arg i;
		var trigger, pluck, metal, z;
		trigger = Impulse.kr(1);
		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05, 0.04));
		z = `[	freq*partials.postln, amps, rings ];
		metal = Klank.ar(z, pluck);
		//metal = SinOsc.ar(800, 0, 0.1);
		metal
	});
	src = LeakDC.ar(HPF.ar(src, 40));
	src = BLowPass.ar(src*env, ffreq*LFNoise2.kr(3,0.2,1),rq, 0.5);
	Out.ar(out, Splay.ar(src.softclip, 0,1,pan));
}).add;


);
/*
Synth(\metal, [\amp, 1, \sustain, 1, \pan, 0]);
*/

);

