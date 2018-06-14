// ============================================
// Simple MIDI-controlled sampler
// 2011-11-07, BTR
// 2014-07-02 (update), BTR
// 2018-January-02, modified and extended by JTM
// ============================================

// ************
// LOAD SAMPLES
// ************

//~buffers = "/home/milde/projekte/udemy/00-instrument-building-with-sc-raspberry/code/GrandPiano/v8/*.wav".pathMatch.collect({ arg i;  Buffer.read(s, i)});

~buffers = "/Users/audio_a_01/Desktop/system1/SuperCollider/code/GrandPiano/v8/*.wav".pathMatch.collect({ arg i;  Buffer.read(s, i)});


// *********
// SYNTHDEF
// *********
// Create a SynthDef

(
SynthDef("midi-sample-playback", {
	arg bufnum = 0, rate = 1, amp = 1, gate = 1;
	var snd, env;
	env = EnvGen.ar(
		envelope: Env.adsr(
			attackTime: 0.01,
			decayTime: 0.3,
			sustainLevel: 0.5,
			releaseTime: 0.3),
		gate: gate,
		doneAction: 2);
	snd = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate, loop: 0);
	snd = snd * env * amp;
	Out.ar(0, snd)
}).add;

)

// test
f = Synth("midi-sample-playback", [\bufnum, 22.postln, \rate, 0.94387431268169]);
g = Synth("midi-sample-playback", [\bufnum, 22.postln, \rate, 1.0]);
h = Synth("midi-sample-playback", [\bufnum, 22.postln, \rate, 1.0594630943593]);

// MIDI STUFF

MIDIIn.connectAll;

(
// array has one slot per possible MIDI note
var getBufferIndex;
var getTransposeFactor;
var midiSamplerArray = Array.newClear(128);

// transpose factors: semi tone down, none, semi tone up
~transposeFactors = [0.94387431268169, 1.0, 1.0594630943593];

getBufferIndex = {
	|note = 60|
	max (0, ((note - 11) / 3).trunc);
};

getTransposeFactor = {
	|note = 60|
	~transposeFactors[((note-11) % 3)];
};


// MIDI processing
MIDIdef.noteOn(key: \sampleOn,
	       func: { arg velocity, noteNumber;
   		 midiSamplerArray[noteNumber] = Synth("midi-sample-playback", [
			\bufnum, getBufferIndex.value(noteNumber),
			\rate, getTransposeFactor.value(noteNumber),
			\amp, velocity.linlin(0, 127, 0, 1)
			])});

MIDIdef.noteOff(key: \sampleOff,
	        func: { arg velocity, noteNumber;
			midiSamplerArray[noteNumber].set(\gate, 0)});

)